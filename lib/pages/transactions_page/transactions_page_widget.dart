import 'package:auto_size_text/auto_size_text.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:moqred/backend/db_requests/db_calls.dart';
import 'package:moqred/backend/schema/models/transaction.dart';
import '/flutter_flow/flutterflow_ui.dart';
import '/utils/internationalization.dart';
import '/utils/app_theme.dart';
import 'package:flutter/material.dart';

import 'transactions_page_model.dart';
export 'transactions_page_model.dart';

class TransactionsPageWidget extends StatefulWidget {
  const TransactionsPageWidget({super.key});

  static String routeName = 'transactions_page';
  static String routePath = '/transactionsPage';

  @override
  State<TransactionsPageWidget> createState() => _TransactionsPageWidgetState();
}

class _TransactionsPageWidgetState extends State<TransactionsPageWidget> {
  late TransactionsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TransactionsPageModel());
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
                    child: Column(
                      children: [
                        // Header row
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'الشخص',
                                  style:
                                      AppTheme.of(context).bodySmall.override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'المبلغ',
                                  style:
                                      AppTheme.of(context).bodySmall.override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'النوع',
                                  style:
                                      AppTheme.of(context).bodySmall.override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'تاريخ',
                                  style:
                                      AppTheme.of(context).bodySmall.override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                ),
                              ),
                              Expanded(
                                child: Text('حذف',
                                    style: AppTheme.of(context).bodySmall),
                              ),
                            ],
                          ),
                        ),

                        // Transactions list
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async =>
                                _model.pagingController.refresh(),
                            child: PagingListener(
                              controller: _model.pagingController,
                              builder: (context, state, fetchNextPage) =>
                                  PagedListView<int, Transaction>(
                                state: state,
                                fetchNextPage: fetchNextPage,
                                builderDelegate:
                                    PagedChildBuilderDelegate<Transaction>(
                                  itemBuilder: (context, transaction, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 2.0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: AppTheme.of(context)
                                              .secondaryBackground,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 0.0,
                                              color: AppTheme.of(context)
                                                  .lineColor,
                                              offset: const Offset(0.0, 1.0),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: AutoSizeText(
                                                  (transaction.personDetails
                                                              ?.name ??
                                                          'غير معروف')
                                                      .maybeHandleOverflow(
                                                    maxChars: 32,
                                                    replacement: '…',
                                                  ),
                                                  style: AppTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  transaction.amount.toString(),
                                                  style: AppTheme.of(context)
                                                      .bodyMedium,
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 2,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: typeColor(transaction
                                                            .typeDetails
                                                            ?.type ??
                                                        ''),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Text(
                                                    transaction.typeDetails
                                                            ?.name ??
                                                        "غير معروف",
                                                    style: AppTheme.of(context)
                                                        .bodyMedium,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  dateTimeFormat(
                                                    "yMd",
                                                    transaction.created,
                                                    locale: AppLocalizations.of(
                                                            context)
                                                        .languageCode,
                                                  ),
                                                  style: AppTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: FlutterFlowIconButton(
                                                  borderRadius: 8.0,
                                                  buttonSize: 40.0,
                                                  fillColor:
                                                      AppTheme.of(context)
                                                          .secondary,
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: AppTheme.of(context)
                                                        .error,
                                                    size: 24.0,
                                                  ),
                                                  onPressed: () async {
                                                    try {
                                                      await RemoveRecord.call(
                                                          tableName: Transaction
                                                              .TABLE_NAME,
                                                          id: transaction.id ??
                                                              '');

                                                      _model.pagingController
                                                          .refresh();
                                                    } catch (e) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            e.toString(),
                                                            style: TextStyle(
                                                              color: AppTheme.of(
                                                                      context)
                                                                  .error,
                                                            ),
                                                          ),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  4000),
                                                          backgroundColor:
                                                              AppTheme.of(
                                                                      context)
                                                                  .secondary,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  firstPageProgressIndicatorBuilder: (_) =>
                                      Center(
                                    child: CircularProgressIndicator(
                                      color: AppTheme.of(context).primary,
                                    ),
                                  ),
                                  newPageProgressIndicatorBuilder: (_) =>
                                      const Center(
                                          child: CircularProgressIndicator()),
                                  noItemsFoundIndicatorBuilder: (_) =>
                                      const Center(
                                          child: Text(
                                              "لا يوجد اي معاملات حتى الان.")),
                                  firstPageErrorIndicatorBuilder: (context) =>
                                      const Center(
                                          child: Text(
                                              "خطأ غير متوقع في تحميل المعاملات.")),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
