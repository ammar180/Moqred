import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:moqred/backend/db_requests/db_calls.dart';
import 'package:moqred/backend/schema/dtos/lookup.dart';
import '/utils/internationalization.dart';
import '/components/add_person/add_person_widget.dart';
import '../../utils/app_theme.dart';
import 'dart:ui';
import '/flutter_flow/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'new_transaction_model.dart';
export 'new_transaction_model.dart';

class NewTransactionWidget extends StatefulWidget {
  const NewTransactionWidget({super.key});

  @override
  State<NewTransactionWidget> createState() => _NewTransactionWidgetState();
}

class _NewTransactionWidgetState extends State<NewTransactionWidget> {
  late NewTransactionModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NewTransactionModel());

    _model.transactionAmountTextController ??= TextEditingController();
    _model.transactionAmountFocusNode ??= FocusNode();

    _model.transactionPersonNotesTextController ??= TextEditingController();
    _model.transactionPersonNotesFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 7.0,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Color(0x7F101213),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxWidth: 530.0,
                  ),
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
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                AppLocalizations.of(context)
                                    .getText('new_tx_title'),
                                style: AppTheme.of(context).headlineSmall),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  color: AppTheme.of(context).secondaryText,
                                  size: 24.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 4.0, 0.0, 0.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .getText('new_tx_subtitle'),
                            style: AppTheme.of(context).bodySmall.override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            child: Form(
                              key: _model.formKey,
                              autovalidateMode: AutovalidateMode.onUnfocus,
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      dateTimeFormat(
                                        "MMMEd",
                                        getCurrentTimestamp,
                                        locale: AppLocalizations.of(context)
                                            .languageCode,
                                      ),
                                      style: AppTheme.of(context)
                                          .titleLarge
                                          .override(
                                            fontFamily: 'Sora',
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                    SizedBox(
                                      width: 200.0,
                                      child: Divider(
                                        thickness: 3.0,
                                        color: AppTheme.of(context).primary,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)
                                              .getText('new_tx_amount_label'),
                                          style: AppTheme.of(context)
                                              .titleMedium
                                              .override(
                                                color: AppTheme.of(context)
                                                    .primaryText,
                                              ),
                                        ),
                                        Container(
                                          width: 170.0,
                                          child: TextFormField(
                                            controller: _model
                                                .transactionAmountTextController,
                                            focusNode: _model
                                                .transactionAmountFocusNode,
                                            autofocus: false,
                                            textInputAction:
                                                TextInputAction.next,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelText: AppLocalizations.of(
                                                      context)
                                                  .getText(
                                                      'new_tx_amount_field_label'),
                                              labelStyle: AppTheme.of(context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily: 'Inter',
                                                    letterSpacing: 0.0,
                                                  ),
                                              hintText:
                                                  AppLocalizations.of(context)
                                                      .getText(
                                                          'new_tx_amount_hint'),
                                              hintStyle: AppTheme.of(context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily: 'Inter',
                                                    letterSpacing: 0.0,
                                                  ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: AppTheme.of(context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: AppTheme.of(context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              filled: true,
                                              fillColor: AppTheme.of(context)
                                                  .secondaryBackground,
                                              contentPadding:
                                                  EdgeInsets.all(12.0),
                                            ),
                                            style: AppTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Inter',
                                                  letterSpacing: 0.0,
                                                ),
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            cursorColor: AppTheme.of(context)
                                                .primaryText,
                                            validator: _model
                                                .transactionAmountTextControllerValidator
                                                .asValidator(context),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'^[1-9][0-9]*$'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)
                                              .getText('new_tx_type_label'),
                                          style: AppTheme.of(context)
                                              .titleMedium
                                              .override(
                                                color: AppTheme.of(context)
                                                    .primaryText,
                                              ),
                                        ),
                                        FutureBuilder<List<Lookup>>(
                                          future: LoadLookupCall.call(
                                              tableName: 'transaction_types'),
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
                                            final transactionTypeLoadTypesRowList =
                                                snapshot.data!;

                                            return FlutterFlowDropDown<String>(
                                              controller: _model
                                                      .transactionTypeValueController ??=
                                                  FormFieldController<String>(
                                                      null),
                                              options:
                                                  transactionTypeLoadTypesRowList
                                                      .map((e) => e.id)
                                                      .toList(),
                                              optionLabels:
                                                  transactionTypeLoadTypesRowList
                                                      .map((e) => e.name)
                                                      .toList(),
                                              onChanged: (val) => safeSetState(
                                                  () => _model
                                                          .transactionTypeValue =
                                                      val),
                                              width: 220,
                                              height: 40.0,
                                              textStyle: AppTheme.of(context)
                                                  .bodyMedium,
                                              hintText: AppLocalizations.of(
                                                      context)
                                                  .getText('new_tx_type_hint'),
                                              fillColor: AppTheme.of(context)
                                                  .secondaryBackground,
                                              elevation: 2.0,
                                              borderColor: AppTheme.of(context)
                                                  .secondary,
                                              borderWidth: 1.0,
                                              borderRadius: 8.0,
                                              margin: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 0.0, 12.0, 0.0),
                                              hidesUnderline: true,
                                              isSearchable: false,
                                              isMultiSelect: false,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)
                                              .getText('new_tx_person_label'),
                                          style: AppTheme.of(context)
                                              .titleMedium
                                              .override(
                                                color: AppTheme.of(context)
                                                    .primaryText,
                                              ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
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
                                                final transactionPersonLoadPersonsRowList =
                                                    snapshot.data!;

                                                return FlutterFlowDropDown<
                                                    String>(
                                                  controller: _model
                                                          .transactionPersonValueController ??=
                                                      FormFieldController<
                                                          String>(''),
                                                  options: List<String>.from(
                                                      transactionPersonLoadPersonsRowList
                                                          .map((e) => e.id)
                                                          .toList()),
                                                  optionLabels:
                                                      transactionPersonLoadPersonsRowList
                                                          .map((e) => e.name)
                                                          .toList(),
                                                  onChanged: (val) =>
                                                      safeSetState(() => _model
                                                              .transactionPersonValue =
                                                          val),
                                                  width: 200.1,
                                                  height: 40.0,
                                                  searchTextStyle: TextStyle(),
                                                  textStyle:
                                                      AppTheme.of(context)
                                                          .bodyMedium,
                                                  hintText: AppLocalizations.of(
                                                          context)
                                                      .getText(
                                                          'new_tx_person_hint'),
                                                  searchCursorColor:
                                                      AppTheme.of(context)
                                                          .primaryText,
                                                  fillColor:
                                                      AppTheme.of(context)
                                                          .secondaryBackground,
                                                  elevation: 2.0,
                                                  borderColor:
                                                      AppTheme.of(context)
                                                          .secondary,
                                                  borderWidth: 1.0,
                                                  borderRadius: 8.0,
                                                  margin: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          12.0, 0.0, 12.0, 0.0),
                                                  hidesUnderline: true,
                                                  isSearchable: true,
                                                  isMultiSelect: false,
                                                );
                                              },
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      10.0, 0.0, 0.0, 0.0),
                                              child: FlutterFlowIconButton(
                                                borderRadius: 8.0,
                                                buttonSize: 40.0,
                                                fillColor: AppTheme.of(context)
                                                    .secondary,
                                                icon: Icon(
                                                  Icons.add,
                                                  color:
                                                      AppTheme.of(context).info,
                                                  size: 24.0,
                                                ),
                                                onPressed: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return Padding(
                                                        padding: MediaQuery
                                                            .viewInsetsOf(
                                                                context),
                                                        child:
                                                            AddPersonWidget(),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller: _model
                                            .transactionPersonNotesTextController,
                                        focusNode: _model
                                            .transactionPersonNotesFocusNode,
                                        autofocus: false,
                                        textInputAction: TextInputAction.next,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: AppLocalizations.of(context)
                                              .getText('new_tx_notes_hint'),
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
                                            Icons.sticky_note_2_outlined,
                                          ),
                                        ),
                                        style: AppTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              letterSpacing: 0.0,
                                            ),
                                        maxLines: null,
                                        cursorColor:
                                            AppTheme.of(context).primaryText,
                                        validator: _model
                                            .transactionPersonNotesTextControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                    FFButtonWidget(
                                      onPressed: () async {
                                        if (_model.formKey.currentState ==
                                                null ||
                                            !_model.formKey.currentState!
                                                .validate()) {
                                          safeSetState(() => ());
                                          return;
                                        }
                                        if (_model.transactionTypeValue
                                                ?.isEmpty ??
                                            true) return;

                                        try {
                                          await _model.verifyAmount();

                                          await InsertTransaction.call(
                                            type: _model.transactionTypeValue!,
                                            person:
                                                _model.transactionPersonValue ??
                                                    '',
                                            amount: int.parse(_model
                                                .transactionAmountTextController!
                                                .text),
                                            notes: _model
                                                .transactionPersonNotesTextController!
                                                .text,
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                AppLocalizations.of(context)
                                                    .getText('new_tx_success'),
                                                style: TextStyle(
                                                  color: AppTheme.of(context)
                                                      .primaryText,
                                                ),
                                              ),
                                              duration:
                                                  Duration(milliseconds: 4000),
                                              backgroundColor:
                                                  AppTheme.of(context)
                                                      .secondary,
                                            ),
                                          );

                                          Navigator.pop(context);
                                        } on Exception catch (e) {
                                          safeSetState(() {
                                            _model.errorMessage = e
                                                .toString()
                                                .replaceFirst(
                                                    'Exception: ', '');
                                          });
                                        }
                                      },
                                      text: AppLocalizations.of(context)
                                          .getText('new_tx_submit'),
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        disabledColor:
                                            AppTheme.of(context).secondaryText,
                                        disabledTextColor:
                                            AppTheme.of(context).alternate,
                                      ),
                                    ),
                                    if (_model.errorMessage != null)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          _model.errorMessage!,
                                          style: AppTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                color:
                                                    AppTheme.of(context).error,
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
}
