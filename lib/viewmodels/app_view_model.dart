import 'package:flutter/foundation.dart';

/// Drives the bottom navigation tab selection for [AppShell].
class AppViewModel extends ChangeNotifier {
  int _tab = 0;
  int get tab => _tab;

  void setTab(int index) {
    if (_tab == index) return;
    _tab = index;
    notifyListeners();
  }
}
