import 'package:flutter/material.dart';

// possibility to add notifications in the settings

class SettingsProvider with ChangeNotifier {
  bool _isDarkTheme = false;
 // bool _areNotificationsEnabled = true;

  bool get isDarkTheme => _isDarkTheme;
 // bool get areNotificationsEnabled => _areNotificationsEnabled;

  void toggleDarkTheme(bool value) {
    _isDarkTheme = value;
    notifyListeners();
  }

 /* void toggleNotifications(bool value) {
    _areNotificationsEnabled = value;
    notifyListeners();
  }
  */
}


