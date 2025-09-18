import 'package:flutter/material.dart';
import 'package:moqred/backend/db_requests/db_service.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '/utils/app_util.dart';
import 'person_details_model.dart';
export 'person_details_model.dart';

import 'package:moqred/backend/db_requests/db_calls.dart';
import 'package:moqred/backend/schema/models/index.dart';
import 'package:moqred/components/add_person/add_person_widget.dart';

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

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Person? _person;
  bool _loadingPerson = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(
        context, () => PersonDetailsPageModel(personId: widget.personId));

    _model.personNameFocusNode ??= FocusNode();
    _model.personPhoneFocusNode ??= FocusNode();
    _model.personBioFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadPerson();
      await _model.dataSource.initialLoad();
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
    _model.personRelatedToValue = p?.relatedTo ?? '';
    _model.personBioTextController ??=
        TextEditingController(text: p?.bio ?? '');

    setState(() => _loadingPerson = false);
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
              : Column(
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
                      // Read-only compact info with Edit button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: AppTheme.of(context).primaryBackground,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x33000000),
                                offset: Offset(0.0, 2.0),
                              )
                            ],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.person, size: 18),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            _person?.name ?? '-',
                                            style: AppTheme.of(context)
                                                .titleMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone, size: 16),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            (_person?.phone ?? '').isEmpty
                                                ? '-'
                                                : _person!.phone,
                                            style:
                                                AppTheme.of(context).bodySmall,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.group, size: 16),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: FutureBuilder<Person?>(
                                            future: DbReader<Person>(
                                              tableName: Person.TABLE_NAME,
                                              fromMap: (m) => Person.fromMap(m),
                                            ).getById(_person?.relatedTo ?? ''),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Text('...');
                                              }
                                              final relatedName =
                                                  snapshot.data?.name ?? '-';
                                              return Text(
                                                relatedName,
                                                style: AppTheme.of(context)
                                                    .bodySmall,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    if ((_person?.bio ?? '').isNotEmpty)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          _person!.bio,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTheme.of(context).bodySmall,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) => Dialog(
                                      insetPadding: const EdgeInsets.all(12.0),
                                      backgroundColor: Colors.transparent,
                                      child: AddPersonWidget(person: _person),
                                    ),
                                  );
                                  await _loadPerson();
                                  await _model.dataSource.updateDataSource();
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text('تعديل'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Padding(
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
                              source: _model.dataSource,
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
                                  allowFiltering: false,
                                  width: 50,
                                  label: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('حذف',
                                        style: AppTheme.of(context).bodySmall),
                                  ),
                                ),
                              ],
                              onColumnSortChanged:
                                  (newSortedColumn, oldSortedColumn) async {
                                if (newSortedColumn == null) return;
                                final columnName = switch (
                                    newSortedColumn.name) {
                                  "typeName" => "type",
                                  _ => newSortedColumn.name
                                };
                                final descending =
                                    newSortedColumn.sortDirection ==
                                        DataGridSortDirection.descending;
                                await _model.dataSource.updateDataSource(
                                  orderBy: columnName,
                                  descending: descending,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ]),
        ),
      ),
    );
  }
}
