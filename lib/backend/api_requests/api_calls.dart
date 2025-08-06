import 'dart:convert';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;


/// Start employee oprations Group Code

class EmployeeOprationsGroup {
  static String getBaseUrl({
    String? bearerToken = '',
  }) =>
      'https://requests-management-system.runasp.net/api/Employee';
  static Map<String, String> headers = {
    'Authorization': 'Bearer [bearerToken]',
  };
  static LoginCall loginCall = LoginCall();
  static ProfileCall profileCall = ProfileCall();
  static RefreshTokenCall refreshTokenCall = RefreshTokenCall();
  static UpdatePasswordCall updatePasswordCall = UpdatePasswordCall();
  static GetEmployeesByDepartmentNameCall getEmployeesByDepartmentNameCall =
      GetEmployeesByDepartmentNameCall();
  static GetEmployeesByDepartmentNameCall FeatchPersonsOverviewCall =
      GetEmployeesByDepartmentNameCall();
}

class LoginCall {
  Future<ApiCallResponse> call({
    String? code = '000000',
    String? password = 'Pass#123',
    String? bearerToken = '',
  }) async {
    final baseUrl = EmployeeOprationsGroup.getBaseUrl(
      bearerToken: bearerToken,
    );

    final ffApiRequestBody = '''
{
  "employeeCode": "${escapeStringForJson(code)}",
  "password": "${escapeStringForJson(password)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'login',
      apiUrl: '${baseUrl}/Login',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.status''',
      ));
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  int? employeeId(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.employeeDto.employeeId''',
      ));
}

class ProfileCall {
  Future<ApiCallResponse> call({
    String? employeeId = '',
    String? bearerToken = '',
  }) async {
    final baseUrl = EmployeeOprationsGroup.getBaseUrl(
      bearerToken: bearerToken,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'profile',
      apiUrl: '${baseUrl}/Profile/${employeeId}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  int? employeeId(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.employeeId''',
      ));
  String? employeeCode(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.employeeCode''',
      ));
  String? employeeName(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.employeeName''',
      ));
  String? departmentName(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.departmentName''',
      ));
  String? casualLeaveCount(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.casualLeaveCount''',
      ));
  String? regularLeaveCount(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.regularLeaveCount''',
      ));
  String? dateOfEmployment(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.dateOfEmployment''',
      ));
}

class RefreshTokenCall {
  Future<ApiCallResponse> call({
    String? refreshToken = '',
    String? bearerToken = '',
  }) async {
    final baseUrl = EmployeeOprationsGroup.getBaseUrl(
      bearerToken: bearerToken,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'refreshToken',
      apiUrl: '${baseUrl}/NewToken',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerToken}',
      },
      params: {
        'refreshToken': refreshToken,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdatePasswordCall {
  Future<ApiCallResponse> call({
    int? empId,
    String? oldPassword = '',
    String? password = '',
    String? confirmPassword = '',
    String? bearerToken = '',
  }) async {
    final baseUrl = EmployeeOprationsGroup.getBaseUrl(
      bearerToken: bearerToken,
    );

    final ffApiRequestBody = '''
{
  "employeeId": ${empId},
  "oldPassword": "${escapeStringForJson(oldPassword)}",
  "password": "${escapeStringForJson(password)}",
  "confirmPassword": "${escapeStringForJson(confirmPassword)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'UpdatePassword',
      apiUrl: '${baseUrl}/UpdatePassword',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetEmployeesByDepartmentNameCall {
  Future<ApiCallResponse> call({
    String? departmentName = 'Quality',
    String? bearerToken = '',
  }) async {
    final baseUrl = EmployeeOprationsGroup.getBaseUrl(
      bearerToken: bearerToken,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'GetEmployeesByDepartmentName',
      apiUrl: '${baseUrl}/GetEmployeesByDepartmentName/${departmentName}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End employee oprations Group Code

/// Start transaction oprations Group Code

class TransactionOprationsGroup {
  static String getBaseUrl({
    String? bearerToken = '',
  }) =>
      'https://requests-management-system.runasp.net/api/Transaction/';
  static Map<String, String> headers = {
    'Authorization': 'Bearer [bearerToken]',
  };
  static PostTransactionCall postTransactionCall = PostTransactionCall();
  static GetStaffTransactionsCall getStaffTransactionsCall =
      GetStaffTransactionsCall();
  static GetTransactionDetailCall getTransactionDetailCall =
      GetTransactionDetailCall();
  static GetAllTransactionsByEmployeeIdCall getAllTransactionsByEmployeeIdCall =
      GetAllTransactionsByEmployeeIdCall();
  static SeenCall seenCall = SeenCall();
  static EditTransactionCall editTransactionCall = EditTransactionCall();
  static CanelTransactionCall canelTransactionCall = CanelTransactionCall();
  static SetStatusCall setStatusCall = SetStatusCall();
  static EmployeeReportCall employeeReportCall = EmployeeReportCall();
}

class PostTransactionCall {
  Future<ApiCallResponse> call({
    String? title = 'Leave',
    String? type = 'CasualLeave',
    String? startDate = '',
    String? endDate = '',
    int? substdEmpId,
    List<String>? itineraryList,
    int? empId,
    String? bearerToken = '',
  }) async {
    final baseUrl = TransactionOprationsGroup.getBaseUrl(
      bearerToken: bearerToken,
    );
    final itinerary = _serializeList(itineraryList);

    final ffApiRequestBody = '''
{
  "title": "${escapeStringForJson(title)}",
  "type": "${escapeStringForJson(type)}",
  "startDate": "${escapeStringForJson(startDate)}",
  "endDate": "${escapeStringForJson(endDate)}",
  "substituteEmployeeId": ${substdEmpId},
  "itinerary": ${itinerary},
  "employeeId": ${empId}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'PostTransaction',
      apiUrl: '${baseUrl}PostTransaction',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetStaffTransactionsCall {
  Future<ApiCallResponse> call({
    String? managerId = '',
    String? bearerToken = '',
  }) async {
    final baseUrl = TransactionOprationsGroup.getBaseUrl(
      bearerToken: bearerToken,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'GetStaffTransactions',
      apiUrl: '${baseUrl}GetStaffTransactions/${managerId}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetTransactionDetailCall {
  Future<ApiCallResponse> call({
    String? transactionId = '',
    String? bearerToken = '',
  }) async {
    final baseUrl = TransactionOprationsGroup.getBaseUrl(
      bearerToken: bearerToken,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'GetTransactionDetail',
      apiUrl: '${baseUrl}GetTransactionDetails/${transactionId}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetAllTransactionsByEmployeeIdCall {
  Future<ApiCallResponse> call({
    String? employeeId = '',
    String? bearerToken = '',
  }) async {
    final baseUrl = TransactionOprationsGroup.getBaseUrl(
      bearerToken: bearerToken,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'GetAllTransactionsByEmployeeId',
      apiUrl: '${baseUrl}GetAllTransactionsByEmployeeId/${employeeId}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SeenCall {
  Future<ApiCallResponse> call({
    String? id = '',
    String? whoSeen = '',
    String? bearerToken = '',
  }) async {
    final baseUrl = TransactionOprationsGroup.getBaseUrl(
      bearerToken: bearerToken,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'seen',
      apiUrl: '${baseUrl}${id}/seen?whoSeen=${whoSeen}',
      callType: ApiCallType.PATCH,
      headers: {
        'Authorization': 'Bearer ${bearerToken}',
      },
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class EditTransactionCall {
  Future<ApiCallResponse> call({
    int? transactionId,
    String? bearerToken = '',
  }) async {
    final baseUrl = TransactionOprationsGroup.getBaseUrl(
      bearerToken: bearerToken,
    );

    final ffApiRequestBody = '''
{
  "title": "",
  "type": "",
  "startDate": "",
  "endDate": "",
  "substituteEmployeeId": 0,
  "itinerary": [
    ""
  ]
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'EditTransaction',
      apiUrl: '${baseUrl}EditTransaction?transactionId=${transactionId}',
      callType: ApiCallType.PUT,
      headers: {
        'Authorization': 'Bearer ${bearerToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CanelTransactionCall {
  Future<ApiCallResponse> call({
    int? transactionId,
    String? bearerToken = '',
  }) async {
    final baseUrl = TransactionOprationsGroup.getBaseUrl(
      bearerToken: bearerToken,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'CanelTransaction',
      apiUrl: '${baseUrl}CanelTransaction/${transactionId}',
      callType: ApiCallType.DELETE,
      headers: {
        'Authorization': 'Bearer ${bearerToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SetStatusCall {
  Future<ApiCallResponse> call({
    String? id = '',
    String? status = 'Approved',
    String? message = '',
    String? bearerToken = '',
  }) async {
    final baseUrl = TransactionOprationsGroup.getBaseUrl(
      bearerToken: bearerToken,
    );

    final ffApiRequestBody = '''
{
  "status": "${escapeStringForJson(status)}",
  "responceMessage": "${escapeStringForJson(message)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SetStatus',
      apiUrl: '${baseUrl}SetStatus/${id}',
      callType: ApiCallType.PUT,
      headers: {
        'Authorization': 'Bearer ${bearerToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.status''',
      ));
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
}

class EmployeeReportCall {
  Future<ApiCallResponse> call({
    String? empId = '2',
    String? balanceFor = 'CasualLeave',
    String? startDate = '',
    String? endDate = '',
    String? bearerToken = '',
  }) async {
    final baseUrl = TransactionOprationsGroup.getBaseUrl(
      bearerToken: bearerToken,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'EmployeeReport',
      apiUrl: '${baseUrl}EmployeeReport/${empId}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerToken}',
      },
      params: {
        'p_type': balanceFor,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End transaction oprations Group Code

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}


String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
