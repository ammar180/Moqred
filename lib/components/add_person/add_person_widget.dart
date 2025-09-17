import 'package:flutter/services.dart'
    show FilteringTextInputFormatter, MaxLengthEnforcement;
import 'package:moqred/backend/db_requests/db_calls.dart';
import 'package:moqred/backend/schema/dtos/lookup.dart' show Lookup;
import '/utils/app_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'add_person_model.dart';
import 'package:moqred/backend/schema/models/index.dart';
export 'add_person_model.dart';

class AddPersonWidget extends StatefulWidget {
  const AddPersonWidget({super.key, this.person});

  final Person? person;

  @override
  State<AddPersonWidget> createState() => _AddPersonWidgetState();
}

class _AddPersonWidgetState extends State<AddPersonWidget> {
  late AddPersonModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();

    _model = createModel(context, () => AddPersonModel());

    _model.personNameTextController ??=
        TextEditingController(text: widget.person?.name ?? '');
    _model.personNameFocusNode ??= FocusNode();

    _model.personPhoneTextController ??=
        TextEditingController(text: widget.person?.phone ?? '');
    _model.personPhoneFocusNode ??= FocusNode();

    _model.personBioTextController ??=
        TextEditingController(text: widget.person?.bio ?? '');
    _model.personBioFocusNode ??= FocusNode();

    _model.personRelatedToValue = widget.person?.relatedTo;
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
                              'إضافة شخص لقاعدة البيانات',
                              style:
                                  AppTheme.of(context).headlineSmall.override(
                                        fontFamily: 'Sora',
                                        letterSpacing: 0.0,
                                      ),
                            ),
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
                              'من الضروري ان يكون الشخص مسجل حتى يتم تسجيل العمليات عليه',
                              style: AppTheme.of(context).bodySmall),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                              width: double.infinity,
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
                                              controller: _model
                                                  .personNameTextController,
                                              focusNode:
                                                  _model.personNameFocusNode,
                                              autofocus: false,
                                              textInputAction:
                                                  TextInputAction.next,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'الاسم',
                                                labelStyle: AppTheme.of(context)
                                                    .labelMedium,
                                                hintText: 'اسم الشخص',
                                                hintStyle: AppTheme.of(context)
                                                    .labelMedium,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppTheme.of(context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppTheme.of(context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
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
                                              style: AppTheme.of(context)
                                                  .bodyMedium,
                                              maxLines: null,
                                              maxLength: 150,
                                              maxLengthEnforcement:
                                                  MaxLengthEnforcement.enforced,
                                              buildCounter: (context,
                                                      {required currentLength,
                                                      required isFocused,
                                                      maxLength}) =>
                                                  null,
                                              cursorColor: AppTheme.of(context)
                                                  .primaryText,
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
                                            controller: _model
                                                .personPhoneTextController,
                                            focusNode:
                                                _model.personPhoneFocusNode,
                                            autofocus: false,
                                            textInputAction:
                                                TextInputAction.next,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelText: 'رقم الهاتف',
                                              labelStyle: AppTheme.of(context)
                                                  .labelMedium,
                                              alignLabelWithHint: false,
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
                                                  color: AppTheme.of(context)
                                                      .error,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: AppTheme.of(context)
                                                      .error,
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
                                            style:
                                                AppTheme.of(context).bodyMedium,
                                            maxLines: null,
                                            maxLength: 12,
                                            maxLengthEnforcement:
                                                MaxLengthEnforcement.enforced,
                                            buildCounter: (context,
                                                    {required currentLength,
                                                    required isFocused,
                                                    maxLength}) =>
                                                null,
                                            keyboardType: TextInputType.phone,
                                            cursorColor: AppTheme.of(context)
                                                .primaryText,
                                            validator: _model
                                                .personPhoneTextControllerValidator
                                                .asValidator(context),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp('[0-9]'))
                                            ],
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
                                              final personsRowList =
                                                  snapshot.data!;

                                              return FlutterFlowDropDown<
                                                  String>(
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
                                                onChanged: (val) =>
                                                    safeSetState(() => _model
                                                            .personRelatedToValue =
                                                        val),
                                                width: 200.0,
                                                height: 40.0,
                                                searchTextStyle: TextStyle(),
                                                textStyle: AppTheme.of(context)
                                                    .bodyMedium,
                                                hintText: 'اختر شخص على صلة به',
                                                searchCursorColor:
                                                    AppTheme.of(context)
                                                        .primaryText,
                                                fillColor: AppTheme.of(context)
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
                                          maxLengthEnforcement:
                                              MaxLengthEnforcement.enforced,
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
                                        onPressed: () async {
                                          if (_model.formKey.currentState ==
                                                  null ||
                                              !_model.formKey.currentState!
                                                  .validate()) {
                                            safeSetState(() => ());
                                            return;
                                          }
                                              if (_model.personNameTextController
                                                  .text.isEmpty) return;
                                              try {
                                                if (widget.person == null) {
                                                  await InsertPerson.call(
                                                      name: _model
                                                          .personNameTextController
                                                          .text,
                                                      phone: _model
                                                          .personPhoneTextController
                                                          .text,
                                                      relatedTo: _model
                                                              .personRelatedToValue ??
                                                          '',
                                                      bio: _model
                                                          .personBioTextController
                                                          .text);
                                                } else {
                                                  final updated = Person(
                                                    id: widget.person!.id,
                                                    name: _model
                                                        .personNameTextController
                                                        .text,
                                                    bio: _model
                                                        .personBioTextController
                                                        .text,
                                                    phone: _model
                                                        .personPhoneTextController
                                                        .text,
                                                    relatedTo: _model
                                                            .personRelatedToValue ??
                                                        '',
                                                    created:
                                                        widget.person!.created,
                                                    updated: DateTime.now(),
                                                  );
                                                  await UpdatePersonCall.call(
                                                      person: updated);
                                                }

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
                                        text: 'إضافة',
                                        options: FFButtonOptions(
                                          width: double.infinity,
                                          height: 40.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
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
                                                  color: AppTheme.of(context)
                                                      .error,
                                                ),
                                          ),
                                        ),
                                    ]
                                        .divide(SizedBox(height: 19.0))
                                        .addToStart(SizedBox(height: 5.0)),
                                  ),
                                ),
                              )),
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
