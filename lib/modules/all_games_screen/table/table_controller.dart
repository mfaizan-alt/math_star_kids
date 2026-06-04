import 'package:get/get.dart';

class TablesController extends GetxController {
  int selectedTable = 2;

  void changeTable(int value) {
    selectedTable = value;
    update();
  }
}