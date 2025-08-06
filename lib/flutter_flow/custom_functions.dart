import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/auth/custom_auth/auth_util.dart';

DateTime? getExpireTimeFromJWTToken(String token) {
  // get Expire date Time From JWT Token
  final Map<String, dynamic> payloadMap = getTokenPayload(token);

  if (!payloadMap.containsKey('exp')) {
    return null;
  }

  final exp = payloadMap['exp'];
  if (exp is! int) {
    return null;
  }

  return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
}

dynamic getTokenPayload(String token) {
  // get Token Payload as json
  // Decode the JWT token and return the payload as a JSON object
  List<String> parts = token.split('.');
  if (parts.length != 3) {
    throw FormatException('Invalid JWT token');
  }

  String payload = parts[1];
  String normalizedPayload = base64Url.normalize(payload);
  String jsonPayload = utf8.decode(base64Url.decode(normalizedPayload));

  return json.decode(jsonPayload);
}

String getStatusColorValue(
  String status,
  String? transparanceValue,
) {
  String trans = transparanceValue ?? "";
  String colorval = "";

  switch (status) {
    case 'مقبول':
      colorval = "00FF00"; // Accepted (green)
    case 'مرفوض':
      colorval = "FF0000"; // Rejected (red)
    case 'معلق':
      colorval = "FFA500"; // Pending (yello)
    case 'معدل':
      colorval = "0000FF"; // Modified (blue)
    default:
      colorval = "808080"; // Default for unknown status (gray)
  }

  return "#${colorval}${trans}";
}

String? createLeaveRequestValidation(
  String type,
  DateTime startDate,
  String endDate,
) {
  return "";
}
