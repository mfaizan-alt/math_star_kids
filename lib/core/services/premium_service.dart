import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// One-time "Remove Ads + Unlock All Stories" purchase.
///
/// Entitlement is persisted to GetStorage + SharedPreferences (same dual
/// backup as StarsService) so it survives offline launches; Restore covers
/// reinstalls and new devices.
class PremiumService extends GetxService {
  static PremiumService get to => Get.find();

  /// Safe check usable from plain singletons (AdManager etc.) that may run
  /// before/without GetX registration.
  static bool get active =>
      Get.isRegistered<PremiumService>() && Get.find<PremiumService>().isPremium.value;

  /// Product id must match the one configured in Play Console / App Store
  /// Connect.
  static const String productId = 'remove_ads_unlock_all';

  final box = GetStorage();

  final RxBool isPremium = false.obs;
  final RxBool storeAvailable = false.obs;
  final RxBool purchasePending = false.obs;
  final Rxn<ProductDetails> product = Rxn<ProductDetails>();

  StreamSubscription<List<PurchaseDetails>>? _sub;

  @override
  void onInit() {
    super.onInit();
    // Sync read so banners/interstitials are suppressed from the very first
    // frame on an already-premium device.
    isPremium.value = box.read('isPremium') as bool? ?? false;
    _restoreFromPrefsBackup();

    _sub = InAppPurchase.instance.purchaseStream.listen(_onPurchases);
    _loadProduct();
  }

  Future<void> _restoreFromPrefsBackup() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isPremium') ?? false) isPremium.value = true;
  }

  Future<void> _loadProduct() async {
    storeAvailable.value = await InAppPurchase.instance.isAvailable();
    if (!storeAvailable.value) return;
    final resp = await InAppPurchase.instance.queryProductDetails({productId});
    if (resp.productDetails.isNotEmpty) {
      product.value = resp.productDetails.first;
    }
  }

  Future<void> buy() async {
    final details = product.value;
    if (details == null) {
      await _loadProduct();
      if (product.value == null) return;
    }
    purchasePending.value = true;
    await InAppPurchase.instance.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: product.value!),
    );
  }

  Future<void> restore() => InAppPurchase.instance.restorePurchases();

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      if (p.productID != productId) continue;
      switch (p.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _grantEntitlement();
          purchasePending.value = false;
          break;
        case PurchaseStatus.error:
        case PurchaseStatus.canceled:
          purchasePending.value = false;
          break;
        case PurchaseStatus.pending:
          purchasePending.value = true;
          break;
      }
      if (p.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(p);
      }
    }
  }

  Future<void> _grantEntitlement() async {
    isPremium.value = true;
    await box.write('isPremium', true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPremium', true);
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
