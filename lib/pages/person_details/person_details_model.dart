import 'package:flutter/material.dart';
import 'package:moqred/utils/nav.dart' show appNavigatorKey;
import '/flutter_flow/flutterflow_ui.dart';
import '/utils/internationalization.dart';
import 'package:moqred/backend/schema/util/pagination_util.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:moqred/backend/db_requests/db_calls.dart';
import 'package:moqred/backend/schema/models/index.dart';

import 'person_details_widget.dart' show PersonDetailsPageWidget;

class PersonTransactionsDataSource extends DataGridSource {
  final Future<PaginatedResult<Transaction>> Function(
    int page,
    int pageSize,
    String? orderBy,
    bool descending,
    Map<String, String>? filters,
  ) loadPage;

  final List<DataGridRow> _rows = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _orderBy;
  bool _descending = true;
  Map<String, String> _filters = {};

  PersonTransactionsDataSource({required this.loadPage});

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final rowMap = {
      for (final cell in row.getCells()) cell.columnName: cell.value,
    };
    final tx = Transaction.fromMap(rowMap);
    return DataGridRowAdapter(cells: [
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Text(tx.formattedAmount),
      ),
      Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: _typeColor(tx.typeDetails?.type ?? ''),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          tx.typeName,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Text(dateTimeFormat('d/M h:mm a', tx.created,
            locale: AppLocalizations.of(appNavigatorKey.currentContext!)
                .languageCode)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            await RemoveRecord.call(
              tableName: Transaction.TABLE_NAME,
              id: tx.id ?? '',
            );
            _rows.remove(row);
            notifyListeners();
          },
        ),
      ),
    ]);
  }

  Color _typeColor(String type) => switch (type) {
        'loan' => Colors.red,
        'payment' => Colors.green,
        'filling' => Colors.blue,
        'donate' => Colors.indigo,
        _ => Colors.grey,
      };

  Future<void> initialLoad() async {
    if (_rows.isNotEmpty) return;
    _currentPage = 1;
    _hasMore = true;
    _rows.clear();
    await _loadMore();
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    final result = await loadPage(_currentPage, PersonDetailsPageModel.pageSize,
        _orderBy, _descending, _filters);
    final items = result.items;
    _rows.addAll(items
        .map((dataGridRow) => DataGridRow(
            cells: dataGridRow
                .toMap()
                .entries
                .map((c) => DataGridCell(columnName: c.key, value: c.value))
                .toList()))
        .toList());
    _currentPage += 1;
    _hasMore = _rows.length < result.totalCount;
    _isLoading = false;
    notifyListeners();
  }

  @override
  Future<void> handleLoadMoreRows() async {
    await _loadMore();
  }

  Future<void> updateDataSource({
    String? orderBy,
    bool? descending,
    Map<String, String>? filters,
  }) async {
    _orderBy = orderBy ?? _orderBy;
    _descending = descending ?? _descending;
    _filters = filters ?? _filters;
    _currentPage = 1;
    _hasMore = true;
    _rows.clear();
    await _loadMore();
  }
}

class PersonDetailsPageModel extends FlutterFlowModel<PersonDetailsPageWidget> {
  static const pageSize = 7;
  late PersonTransactionsDataSource dataSource;
  final formKey = GlobalKey<FormState>();
  final String personId;
  String? errorMessage;
  // State field(s) for personName widget.
  FocusNode? personNameFocusNode;
  TextEditingController? personNameTextController;
  String? Function(BuildContext, String?)? personNameTextControllerValidator;
  String? _personNameTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'الاسم أساسي';
    }

    return null;
  }

  // State field(s) for personPhone widget.
  FocusNode? personPhoneFocusNode;
  TextEditingController? personPhoneTextController;
  String? Function(BuildContext, String?)? personPhoneTextControllerValidator;
  // State field(s) for personRelatedTo widget.
  String? personRelatedToValue;
  FormFieldController<String>? personRelatedToValueController;
  // State field(s) for personBio widget.
  FocusNode? personBioFocusNode;
  TextEditingController? personBioTextController;
  String? Function(BuildContext, String?)? personBioTextControllerValidator;

  PersonDetailsPageModel({required this.personId});
  @override
  void initState(BuildContext context) {
    personNameTextControllerValidator = _personNameTextControllerValidator;
    dataSource = PersonTransactionsDataSource(
      loadPage: (page, pageSize, orderBy, descending, filters) async {
        final mergedFilters = {
          ...?filters,
          'person': this.personId,
        };
        final pageResult = await FetchTransactionsCall.call(
          page: page,
          perPage: pageSize,
          orderBy: orderBy,
          descending: descending,
          filters: mergedFilters,
        );
        return pageResult;
      },
    );
  }

  @override
  void dispose() {
    personNameFocusNode?.dispose();
    personNameTextController?.dispose();

    personPhoneFocusNode?.dispose();
    personPhoneTextController?.dispose();

    personBioFocusNode?.dispose();
    personBioTextController?.dispose();
  }
}
