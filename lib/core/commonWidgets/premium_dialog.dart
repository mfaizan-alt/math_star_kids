import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/premium_service.dart';
import 'parental_gate.dart';

/// Purchase sheet for the one-time "Remove Ads + Unlock Everything" product.
/// Always open via [PremiumDialog.show] so the parental gate runs first.
class PremiumDialog extends StatelessWidget {
  const PremiumDialog({super.key});

  static Future<void> show() async {
    if (!PremiumService.active) {
      final passed = await showParentalGate();
      if (!passed) return;
    }
    Get.dialog(const PremiumDialog());
  }

  @override
  Widget build(BuildContext context) {
    final premium = PremiumService.to;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [Color(0xFF7B2FBE), Color(0xFF4CC9F0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Obx(() {
          if (premium.isPremium.value) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('👑', style: TextStyle(fontSize: 52)),
                const SizedBox(height: 12),
                Text(
                  'You have Premium!',
                  style: GoogleFonts.aBeeZee(
                      fontSize: 22, color: Colors.white, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  'No ads, and every story is unlocked. Enjoy!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(fontSize: 15, color: Colors.white),
                ),
                const SizedBox(height: 20),
                _whiteButton('Awesome!', onTap: Get.back),
              ],
            );
          }

          final price = premium.product.value?.price;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('👑', style: TextStyle(fontSize: 52)),
              const SizedBox(height: 12),
              Text(
                'Go Premium',
                style: GoogleFonts.aBeeZee(
                    fontSize: 24, color: Colors.white, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 16),
              _benefit('🚫', 'No more ads — ever'),
              _benefit('📚', 'All premium stories unlocked'),
              _benefit('💜', 'One-time purchase, yours forever'),
              const SizedBox(height: 20),
              if (premium.purchasePending.value)
                const CircularProgressIndicator(color: Colors.white)
              else if (!premium.storeAvailable.value || price == null)
                Text(
                  'Store not available right now.\nPlease try again later.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(fontSize: 14, color: Colors.white70),
                )
              else
                _whiteButton('Unlock for $price', onTap: premium.buy),
              const SizedBox(height: 8),
              TextButton(
                onPressed: premium.restore,
                child: Text(
                  'Restore purchase',
                  style: GoogleFonts.nunito(
                      color: Colors.white70,
                      fontSize: 14,
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _benefit(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.nunito(
                  fontSize: 15, color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _whiteButton(String label, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.aBeeZee(
              fontSize: 16,
              color: const Color(0xFF7B2FBE),
              fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
