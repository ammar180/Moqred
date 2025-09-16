import 'package:flutter/material.dart';
import 'package:moqred/backend/schema/dtos/lookup.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '/utils/app_util.dart';
import 'person_details_model.dart';
export 'person_details_model.dart';

import 'package:moqred/backend/db_requests/db_calls.dart';
import 'package:moqred/backend/schema/models/index.dart';
import 'package:moqred/backend/schema/util/pagination_util.dart';

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

class PersonDetailsPageWidget extends StatefulWidget {
  const PersonDetailsPageWidget({super.key, required this.personId});

  static String routeName = 'person_details_page';
  static String routePath = '/person';

  final String personId;

  @override
  State<PersonDetailsPageWidget> createState() =>
      _PersonDetailsPageWidgetState();
}

class _PersonDetailsPageWidgetState extends State<PersonDetailsPageWidget> {
  late PersonDetailsPageModel _model;
  late PersonTransactionsDataSource _dataSource;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Person? _person;
  bool _loadingPerson = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PersonDetailsPageModel());

    _model.personNameFocusNode ??= FocusNode();
    _model.personPhoneFocusNode ??= FocusNode();
    _model.personBioFocusNode ??= FocusNode();

    _dataSource = PersonTransactionsDataSource(
      loadPage: (page, pageSize, orderBy, descending, filters) async {
        final mergedFilters = {
          ...?filters,
          'person': widget.personId,
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadPerson();
      await _dataSource.initialLoad();
    });
  }

  Future<void> _loadPerson() async {
    setState(() => _loadingPerson = true);
    final p = await FetchPersonByIdCall.call(id: widget.personId);
    _person = p;
    _model.personNameTextController ??=
        TextEditingController(text: p?.name ?? '');
    _model.personPhoneTextController ??=
        TextEditingController(text: p?.phone ?? '');
    _model.personRelatedToValue = p?.phone ?? '';
    _model.personRelatedToValueController ??=
        FormFieldController<String>(_model.personRelatedToValue);
    _model.personBioTextController ??=
        TextEditingController(text: p?.relatedTo ?? '');

    setState(() => _loadingPerson = false);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _savePerson() async {
    if (_model.formKey.currentState == null ||
        !_model.formKey.currentState!.validate()) {
      safeSetState(() => ());
      return;
    }
    if (_model.personNameTextController.text.isEmpty) return;
    if (_person == null) return;
    try {
      final updated = Person(
        id: _person!.id,
        name: _model.personNameTextController?.text ?? '',
        bio: _model.personBioTextController?.text ?? '',
        phone: _model.personBioTextController?.text ?? '',
        relatedTo: _model.personRelatedToValueController?.initialValue ?? '',
        created: _person!.created,
        updated: DateTime.now(),
      );
      await UpdatePersonCall.call(person: updated);
      await _loadPerson();
    } on Exception catch (e) {
      safeSetState(() {
        _model.errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
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
        appBar: AppBar(
          backgroundColor: AppTheme.of(context).secondaryBackground,
          iconTheme: IconThemeData(color: AppTheme.of(context).primaryText),
          automaticallyImplyLeading: true,
          title: Text(
            'تفاصيل الشخص',
            style: AppTheme.of(context).headlineMedium,
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        backgroundColor: AppTheme.of(context).secondaryBackground,
        body: SafeArea(
          child: _loadingPerson
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0.0),
                        child: Text(_person?.name ?? 'تفاصيل شخص',
                            style: AppTheme.of(context).displaySmall),
                      ),
                      Divider(
                        height: 18.0,
                        thickness: 1.0,
                        color: AppTheme.of(context).lineColor,
                      ),
                      // Editable form
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: AppTheme.of(context).primaryBackground,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x33000000),
                                offset: Offset(
                                  0.0,
                                  2.0,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Form(
                            key: _model.formKey,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    child: Container(
                                      width: double.infinity,
                                      child: TextFormField(
                                          controller:
                                              _model.personNameTextController,
                                          focusNode: _model.personNameFocusNode,
                                          autofocus: false,
                                          textInputAction: TextInputAction.next,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            labelText: 'الاسم',
                                            labelStyle: AppTheme.of(context)
                                                .labelMedium,
                                            hintText: 'اسم الشخص',
                                            hintStyle: AppTheme.of(context)
                                                .labelMedium,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    AppTheme.of(context).error,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    AppTheme.of(context).error,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            fillColor: AppTheme.of(context)
                                                .secondaryBackground,
                                            prefixIcon: Icon(
                                              Icons.person,
                                              color: AppTheme.of(context)
                                                  .secondaryText,
                                            ),
                                          ),
                                          style:
                                              AppTheme.of(context).bodyMedium,
                                          maxLines: null,
                                          maxLength: 150,
                                          buildCounter: (context,
                                                  {required currentLength,
                                                  required isFocused,
                                                  maxLength}) =>
                                              null,
                                          cursorColor:
                                              AppTheme.of(context).primaryText,
                                          validator: _model
                                              .personNameTextControllerValidator
                                              .asValidator(context)),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(),
                                    child: Container(
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller:
                                            _model.personPhoneTextController,
                                        focusNode: _model.personPhoneFocusNode,
                                        autofocus: false,
                                        textInputAction: TextInputAction.next,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          labelText: 'رقم الهاتف',
                                          labelStyle:
                                              AppTheme.of(context).labelMedium,
                                          alignLabelWithHint: false,
                                          hintStyle:
                                              AppTheme.of(context).labelMedium,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppTheme.of(context).error,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppTheme.of(context).error,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          filled: true,
                                          fillColor: AppTheme.of(context)
                                              .secondaryBackground,
                                          prefixIcon: Icon(
                                            Icons.phone_enabled,
                                            color: AppTheme.of(context)
                                                .secondaryText,
                                          ),
                                        ),
                                        style: AppTheme.of(context).bodyMedium,
                                        maxLines: null,
                                        maxLength: 12,
                                        buildCounter: (context,
                                                {required currentLength,
                                                required isFocused,
                                                maxLength}) =>
                                            null,
                                        keyboardType: TextInputType.phone,
                                        cursorColor:
                                            AppTheme.of(context).primaryText,
                                        validator: _model
                                            .personPhoneTextControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'على صلة ب: ',
                                        style: AppTheme.of(context)
                                            .titleMedium
                                            .override(
                                              color: AppTheme.of(context)
                                                  .primaryText,
                                            ),
                                      ),
                                      FutureBuilder<List<Lookup>>(
                                        future: LoadLookupCall.call(
                                            tableName: 'persons'),
                                        builder: (context, snapshot) {
                                          // Customize what your widget looks like when it's loading.
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child: SizedBox(
                                                width: 50.0,
                                                height: 50.0,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    AppTheme.of(context)
                                                        .primary,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          final personsRowList = snapshot.data!;

                                          return FlutterFlowDropDown<String>(
                                            controller: _model
                                                    .personRelatedToValueController ??=
                                                FormFieldController<String>(
                                              _model.personRelatedToValue ??=
                                                  '',
                                            ),
                                            options: List<String>.from(
                                                personsRowList
                                                    .map((e) => e.id)
                                                    .toList()),
                                            optionLabels: personsRowList
                                                .map((e) => e.name)
                                                .toList(),
                                            onChanged: (val) => safeSetState(
                                                () => _model
                                                        .personRelatedToValue =
                                                    val),
                                            width: 200.0,
                                            height: 40.0,
                                            searchTextStyle: TextStyle(),
                                            textStyle:
                                                AppTheme.of(context).bodyMedium,
                                            hintText: 'اختر شخص على صلة به',
                                            searchCursorColor:
                                                AppTheme.of(context)
                                                    .primaryText,
                                            fillColor: AppTheme.of(context)
                                                .secondaryBackground,
                                            elevation: 2.0,
                                            borderColor:
                                                AppTheme.of(context).secondary,
                                            borderWidth: 1.0,
                                            borderRadius: 8.0,
                                            margin:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    12.0, 0.0, 12.0, 0.0),
                                            hidesUnderline: true,
                                            isSearchable: true,
                                            isMultiSelect: false,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: TextFormField(
                                      controller:
                                          _model.personBioTextController,
                                      focusNode: _model.personBioFocusNode,
                                      autofocus: false,
                                      textInputAction: TextInputAction.next,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: 'ملاحظات اضافية',
                                        hintStyle: AppTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Sora',
                                              letterSpacing: 0.0,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppTheme.of(context).error,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppTheme.of(context).error,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        filled: true,
                                        fillColor: AppTheme.of(context)
                                            .secondaryBackground,
                                        prefixIcon: Icon(
                                          Icons.sticky_note_2_outlined,
                                        ),
                                      ),
                                      style: AppTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                      maxLines: 2,
                                      maxLength: 500,
                                      buildCounter: (context,
                                              {required currentLength,
                                              required isFocused,
                                              maxLength}) =>
                                          null,
                                      cursorColor:
                                          AppTheme.of(context).primaryText,
                                      validator: _model
                                          .personBioTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                  FFButtonWidget(
                                    onPressed: _savePerson,
                                    text: 'إضافة',
                                    icon: const Icon(Icons.save),
                                    options: FFButtonOptions(
                                      width: double.infinity,
                                      height: 40.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: AppTheme.of(context).secondary,
                                      textStyle: AppTheme.of(context)
                                          .titleSmall
                                          .override(
                                            color: Colors.white,
                                          ),
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  if (_model.errorMessage != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        _model.errorMessage!,
                                        style: AppTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              color: AppTheme.of(context).error,
                                            ),
                                      ),
                                    ),
                                ]
                                    .divide(SizedBox(height: 19.0))
                                    .addToStart(SizedBox(height: 5.0)),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 12.0),
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
                            frozenColumnsCount: 0,
                            allowSorting: true,
                            allowFiltering: true,
                            allowPullToRefresh: true,
                            columnWidthMode: ColumnWidthMode.fill,
                            loadMoreViewBuilder: (context, loadMoreRows) {
                              return FutureBuilder<void>(
                                future: loadMoreRows(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              );
                            },
                            columns: [
                              GridColumn(
                                columnName: 'amount',
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
                                columnWidthMode: ColumnWidthMode.auto,
                                label: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('حذف',
                                      style: AppTheme.of(context).bodySmall),
                                ),
                              ),
                            ],
                            onColumnSortChanged:
                                (newSortedColumn, oldSortedColumn) async {
                              if (newSortedColumn == null ||
                                  oldSortedColumn == null) return;
                              final columnName = newSortedColumn.name;
                              final descending =
                                  newSortedColumn.sortDirection ==
                                      DataGridSortDirection.descending;
                              await _dataSource.updateDataSource(
                                orderBy: columnName,
                                descending: descending,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
