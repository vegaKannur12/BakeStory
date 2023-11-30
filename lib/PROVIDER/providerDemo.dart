import 'package:bakestory_report/PROVIDER/valuenotifier.dart';
import 'package:flutter/material.dart';

class ProviderDemo with ChangeNotifier {
  String fav = UserSimplePreferences.getname() ?? "sreey";

  void changevalue(String val) {
    fav = val;
    notifyListeners();
  }
}