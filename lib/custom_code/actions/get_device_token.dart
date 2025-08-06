// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> getDeviceToken() async {
  // Add your function code here!
  return await FirebaseMessaging.instance.getToken(
      vapidKey:
          "BOt5Xj96aPeEwbdHNUrOajEQ1iESHx6lQfPOVO2uBRo6c-ysmjZZ3j9m2qMwKd7thR8pBPdLJKgPvbXDMFnlpoA");
}
