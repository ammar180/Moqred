import 'package:moqred/backend/db_requests/db_calls.dart';
import 'package:moqred/backend/schema/dtos/balance.dart';
import 'package:moqred/backend/schema/structs/index.dart';
import 'package:moqred/components/new_transaction/new_transaction_widget.dart';
import 'package:moqred/pages/person_details/person_details_widget.dart';
import '/utils/app_util.dart';
import '/utils/app_state.dart';
import '/utils/internationalization.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'home_page';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
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
        body: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 12.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context).getText(
                                                  'home_current_loans' /* Current Loans */),
                                              style: AppTheme.of(context)
                                                  .displaySmall,
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 4.0, 0.0, 0.0),
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .getText(
                                                          'home_subtitle' /* Preview current balance plus list */),
                                                  style: AppTheme.of(context)
                                                      .bodySmall),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 16.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: AppTheme.of(context).lineColor,
                                        width: 1.0,
                                      ),
                                    ),
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 12.0, 0.0, 12.0),
                                        child: FutureBuilder<Balance>(
                                          future:
                                              FetchElQardBalancesCall.call(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Wrap(
                                                spacing: 12.0,
                                                runSpacing: 0.0,
                                                alignment:
                                                    WrapAlignment.spaceBetween,
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.end,
                                                children:
                                                    List.generate(3, (index) {
                                                  return Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        width: 80,
                                                        height: 16,
                                                        color: Colors.grey[300],
                                                      ),
                                                      const SizedBox(
                                                          height: 16),
                                                      Shimmer.fromColors(
                                                        baseColor:
                                                            Colors.grey[300]!,
                                                        highlightColor:
                                                            Colors.grey[100]!,
                                                        child: Container(
                                                          width: 100,
                                                          height: 24,
                                                          color:
                                                              Colors.grey[300],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }),
                                              );
                                            }

                                            if (snapshot.hasError) {
                                              return Text(
                                                  AppLocalizations.of(context)
                                                      .getText(
                                                          'home_error_loading_balance' /* Sorry, error loading balance details */),
                                                  style: AppTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                          fontFamily: 'Sora',
                                                          color: AppTheme.of(
                                                                  context)
                                                              .error));
                                            }

                                            if (!snapshot.hasData) {
                                              return Text(
                                                  AppLocalizations.of(context)
                                                      .getText(
                                                          'home_no_data' /* No data yet */),
                                                  style: AppTheme.of(context)
                                                      .labelMedium);
                                            }

                                            var balanceData = snapshot.data!;
                                            AppState().balance = balanceData;
                                            return Wrap(
                                              spacing: 12.0,
                                              runSpacing: 0.0,
                                              alignment:
                                                  WrapAlignment.spaceBetween,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.end,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .getText(
                                                              'home_available_amount' /* Available Amount */),
                                                      style:
                                                          AppTheme.of(context)
                                                              .labelMedium,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              16.0, 0.0, 0.0),
                                                      child: Text(
                                                        formatNumber(
                                                          balanceData.TotalIn,
                                                          formatType: FormatType
                                                              .decimal,
                                                          decimalType:
                                                              DecimalType
                                                                  .periodDecimal,
                                                        ),
                                                        style:
                                                            AppTheme.of(context)
                                                                .headlineSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Sora',
                                                                  color: AppTheme.of(
                                                                          context)
                                                                      .success,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .getText(
                                                              'home_total_amount' /* Total Amount */),
                                                      style:
                                                          AppTheme.of(context)
                                                              .labelMedium,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              16.0, 0.0, 0.0),
                                                      child: Text(
                                                        formatNumber(
                                                          balanceData
                                                              .CurrentBalance,
                                                          formatType: FormatType
                                                              .decimal,
                                                          decimalType:
                                                              DecimalType
                                                                  .periodDecimal,
                                                        ),
                                                        style:
                                                            AppTheme.of(context)
                                                                .headlineSmall,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .getText(
                                                              'home_outgoing_amount' /* Outgoing Amount */),
                                                      style:
                                                          AppTheme.of(context)
                                                              .labelMedium,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              16.0, 0.0, 0.0),
                                                      child: Text(
                                                        formatNumber(
                                                          balanceData.TotalOut,
                                                          formatType: FormatType
                                                              .decimal,
                                                          decimalType:
                                                              DecimalType
                                                                  .periodDecimal,
                                                        ),
                                                        style:
                                                            AppTheme.of(context)
                                                                .headlineSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Sora',
                                                                  color: AppTheme.of(
                                                                          context)
                                                                      .error,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (responsiveVisibility(
                                  context: context,
                                  tabletLandscape: false,
                                  desktop: false,
                                ))
                                  Divider(
                                    height: 10.0,
                                    thickness: 1.0,
                                    color: AppTheme.of(context).lineColor,
                                  ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 10.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          await showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            enableDrag: false,
                                            context: context,
                                            builder: (context) {
                                              return GestureDetector(
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                                child: Padding(
                                                  padding:
                                                      MediaQuery.viewInsetsOf(
                                                          context),
                                                  child: NewTransactionWidget(),
                                                ),
                                              );
                                            },
                                          ).then(
                                              (value) => safeSetState(() {}));
                                        },
                                        text: AppLocalizations.of(context).getText(
                                            'home_new_transaction' /* New Transaction */),
                                        options: FFButtonOptions(
                                          height: 40.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: AppTheme.of(context).primary,
                                          textStyle: AppTheme.of(context)
                                              .titleSmall
                                              .override(
                                                fontFamily: 'Inter',
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                              ),
                                          elevation: 0.0,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                    FutureBuilder<List<PersonOverviewStruct>>(
                                      future: FetchPersonsOverviewCall.call(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color:
                                                  AppTheme.of(context).primary,
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                              'Error: ${snapshot.error}',
                                              style: AppTheme.of(context)
                                                  .headlineSmall
                                                  .override(
                                                    color: AppTheme.of(context)
                                                        .error,
                                                    letterSpacing: 0.0,
                                                  ),
                                            ),
                                          );
                                        }
                                        final person = snapshot.data!;
                                        return SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          child: FlutterFlowDataTable<
                                              PersonOverviewStruct>(
                                            controller: _model
                                                .paginatedDataTableController,
                                            data: person,
                                            columnsBuilder: (onSortChanged) => [
                                              DataColumn2(
                                                label: DefaultTextStyle.merge(
                                                  softWrap: true,
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .getText(
                                                            'home_borrower' /* Borrower */),
                                                    textAlign: TextAlign.center,
                                                    style: AppTheme.of(context)
                                                        .bodyLarge,
                                                  ),
                                                ),
                                              ),
                                              DataColumn2(
                                                label: DefaultTextStyle.merge(
                                                  softWrap: true,
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .getText(
                                                            'home_remaining' /* Remaining */),
                                                    textAlign: TextAlign.center,
                                                    style: AppTheme.of(context)
                                                        .bodyLarge,
                                                  ),
                                                ),
                                              ),
                                              DataColumn2(
                                                label: DefaultTextStyle.merge(
                                                  softWrap: true,
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .getText(
                                                            'home_date' /* Date */),
                                                    textAlign: TextAlign.center,
                                                    style: AppTheme.of(context)
                                                        .bodyLarge,
                                                  ),
                                                ),
                                              ),
                                            ],
                                            dataRowBuilder: (personItem,
                                                    personIndex,
                                                    selected,
                                                    onSelectChanged) =>
                                                DataRow(
                                              color: WidgetStateProperty.all(
                                                personIndex % 2 == 0
                                                    ? AppTheme.of(context)
                                                        .secondaryBackground
                                                    : AppTheme.of(context)
                                                        .primaryBackground,
                                              ),
                                              cells: [
                                                GestureDetector(
                                                  onTap: () =>
                                                      context.pushNamed(
                                                    PersonDetailsPageWidget
                                                        .routeName,
                                                    queryParameters: {
                                                      'id': serializeParam(
                                                        personItem.id,
                                                        ParamType.String,
                                                      ),
                                                    }.withoutNulls,
                                                  ),
                                                  child: Text(
                                                    valueOrDefault<String>(
                                                        personItem.name,
                                                        AppLocalizations.of(
                                                                context)
                                                            .getText(
                                                                'home_borrower' /* Borrower */)),
                                                    style: AppTheme.of(context)
                                                        .labelSmall
                                                        .override(
                                                          color: AppTheme.of(
                                                                  context)
                                                              .secondary,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                        ),
                                                  ),
                                                ),
                                                Text(
                                                  valueOrDefault<String>(
                                                    formatNumber(
                                                      personItem.remainder,
                                                      formatType:
                                                          FormatType.decimal,
                                                      decimalType: DecimalType
                                                          .periodDecimal,
                                                    ),
                                                    '-0',
                                                  ),
                                                  style: AppTheme.of(context)
                                                      .labelSmall,
                                                ),
                                                Text(
                                                  dateTimeFormat(
                                                    "d/M h:mm a",
                                                    personItem.lastTransaction,
                                                    locale: AppLocalizations.of(
                                                            context)
                                                        .languageCode,
                                                  ),
                                                  style: AppTheme.of(context)
                                                      .bodySmall,
                                                ),
                                              ]
                                                  .map((c) => DataCell(c))
                                                  .toList(),
                                            ),
                                            emptyBuilder: () => Center(
                                                child: Text(AppLocalizations.of(
                                                        context)
                                                    .getText(
                                                        'home_no_loans' /* No active loans yet */))),
                                            paginated: true,
                                            selectable: false,
                                            hidePaginator: false,
                                            headingRowHeight: 60.0,
                                            dataRowHeight: 60.0,
                                            columnSpacing: 5.0,
                                            headingRowColor:
                                                AppTheme.of(context).primary,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
