import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:moqred/backend/db_requests/db_calls.dart';
import 'package:moqred/backend/schema/models/transaction.dart';
import 'package:moqred/backend/schema/util/pagination_util.dart';
import '/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'transactions_page_model.dart';
export 'transactions_page_model.dart';

class TransactionsDataSource extends DataGridSource {
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

  TransactionsDataSource({required this.loadPage});

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
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        alignment: Alignment.center,
        child: Tooltip(
          child: AutoSizeText(
            tx.personName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          message: tx.personName,
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        alignment: Alignment.center,
        child: Text(tx.amount.toString()),
      ),
      Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: _typeColor(tx.typeDetails?.type ?? ''),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(tx.typeName),
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
    final result = await loadPage(_currentPage, TransactionsPageModel.pageSize,
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

  @override
  Future<void> performSorting(List<DataGridRow> rows) async {
    // Sorting delegated to DB via orderBy; update order and reload
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

class TransactionsPageWidget extends StatefulWidget {
  const TransactionsPageWidget({super.key});

  static String routeName = 'transactions_page';
  static String routePath = '/transactionsPage';

  @override
  State<TransactionsPageWidget> createState() => _TransactionsPageWidgetState();
}

class _TransactionsPageWidgetState extends State<TransactionsPageWidget> {
  late TransactionsPageModel _model;
  late TransactionsDataSource _dataSource;
  final DataGridController _gridController = DataGridController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TransactionsPageModel());
    _dataSource = TransactionsDataSource(
      loadPage: (page, pageSize, orderBy, descending, filters) async {
        final pageResult = await FetchTransactionsCall.call(
          page: page,
          perPage: pageSize,
          orderBy: orderBy,
          descending: descending,
          filters: filters,
        );
        return pageResult;
      },
    );
    // Initial data load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dataSource.initialLoad();
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppTheme.of(context).secondaryBackground,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (responsiveVisibility(
                context: context,
                tabletLandscape: false,
                desktop: false,
              ))
                Container(
                  height: 44.0,
                  color: AppTheme.of(context).secondaryBackground,
                ),

              // Page title
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0.0),
                child: Text(
                  'سجل كل المعاملات',
                  style: AppTheme.of(context).displaySmall.override(
                        fontFamily: 'Sora',
                        letterSpacing: 0.0,
                      ),
                ),
              ),
              Divider(
                height: 24.0,
                thickness: 1.0,
                color: AppTheme.of(context).lineColor,
              ),

              // Main content area (takes all remaining space)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: AppTheme.of(context).lineColor,
                        width: 1.0,
                      ),
                    ),
                    child: SfDataGrid(
                      source: _dataSource,
                      controller: _gridController,
                      frozenColumnsCount: 1,
                      allowSorting: true,
                      allowFiltering: true,
                      allowPullToRefresh: true,
                      loadMoreViewBuilder: (context, loadMoreRows) {
                        return FutureBuilder<void>(
                          future: loadMoreRows(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        );
                      },
                      columns: [
                        GridColumn(
                          columnName: 'personName',
                          columnWidthMode: ColumnWidthMode.auto,
                          label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('الشخص',
                                style: AppTheme.of(context).bodySmall),
                          ),
                        ),
                        GridColumn(
                          columnName: 'amount',
                          columnWidthMode: ColumnWidthMode.auto,
                          label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('المبلغ',
                                style: AppTheme.of(context).bodySmall),
                          ),
                        ),
                        GridColumn(
                          columnName: 'typeName',
                          label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('النوع',
                                style: AppTheme.of(context).bodySmall),
                          ),
                        ),
                        GridColumn(
                          columnName: 'created',
                          label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('تاريخ',
                                style: AppTheme.of(context).bodySmall),
                          ),
                        ),
                        GridColumn(
                          columnName: 'actions',
                          allowSorting: false,
                          label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('حذف',
                                style: AppTheme.of(context).bodySmall),
                          ),
                        ),
                      ],
                      onColumnSortChanged:
                          (newSortedColumn, oldSortedColumn) async {
                        if (newSortedColumn == null || oldSortedColumn == null)
                          return;
                        final columnName = newSortedColumn.name;
                        final descending = newSortedColumn.sortDirection ==
                            DataGridSortDirection.descending;
                        await _dataSource.updateDataSource(
                          orderBy: columnName,
                          descending: descending,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color typeColor(String type) => switch (type) {
        'loan' => Colors.red,
        'payment' => Colors.green,
        'filling' => Colors.blue,
        'donate' => Colors.yellowAccent,
        _ => Colors.grey,
      };
}
