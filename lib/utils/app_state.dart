import 'package:flutter/material.dart';
import 'package:moqred/backend/schema/dtos/index.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();

  factory AppState() => _instance;

  AppState._internal();

  // Update method to trigger rebuilds
  void update(VoidCallback callback) {
    callback(); // Apply changes
    notifyListeners(); // Notify listeners to rebuild
  }

  // Optional: Reset method
  static void reset() {
    _instance._balance = Balance(TotalIn: 0, TotalOut: 0);
    _instance.notifyListeners();
  }

  // Add your state variables and methods here
  Balance _balance = Balance(TotalIn: 0, TotalOut: 0);
  Balance get balance => _balance;
  set balance(Balance value) {
    _balance = value;
    notifyListeners();
  }
}
