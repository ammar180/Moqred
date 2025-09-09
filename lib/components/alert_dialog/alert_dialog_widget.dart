import '../../utils/app_theme.dart';
import '/flutter_flow/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'alert_dialog_model.dart';
export 'alert_dialog_model.dart';

class AlertDialogWidget extends StatefulWidget {
  const AlertDialogWidget({
    super.key,
    required this.title,
    required this.description,
    String? confirmButton,
    String? cancelButton,
    this.confirmCallback,
  })  : this.confirmButton = confirmButton ?? 'Confirm',
        this.cancelButton = cancelButton ?? 'Cancel';

  final String? title;
  final String? description;
  final String confirmButton;
  final String cancelButton;
  final Future Function()? confirmCallback;

  @override
  State<AlertDialogWidget> createState() => _AlertDialogWidgetState();
}

class _AlertDialogWidgetState extends State<AlertDialogWidget> {
  late AlertDialogModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AlertDialogModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
        child: Material(
          color: Colors.transparent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Container(
            width: 340.0,
            constraints: BoxConstraints(
              maxWidth: 530.0,
            ),
            decoration: BoxDecoration(
              color: AppTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    valueOrDefault<String>(
                      widget.title,
                      'Title',
                    ),
                    style: AppTheme.of(context).titleLarge.override(
                          font: GoogleFonts.sora(
                            fontWeight:
                                AppTheme.of(context).titleLarge.fontWeight,
                            fontStyle:
                                AppTheme.of(context).titleLarge.fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight:
                              AppTheme.of(context).titleLarge.fontWeight,
                          fontStyle: AppTheme.of(context).titleLarge.fontStyle,
                        ),
                  ),
                  Text(
                    valueOrDefault<String>(
                      widget.description,
                      'Description',
                    ),
                    style: AppTheme.of(context).bodyLarge.override(
                          font: GoogleFonts.inter(
                            fontWeight:
                                AppTheme.of(context).bodyLarge.fontWeight,
                            fontStyle: AppTheme.of(context).bodyLarge.fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: AppTheme.of(context).bodyLarge.fontWeight,
                          fontStyle: AppTheme.of(context).bodyLarge.fontStyle,
                        ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.cancelButton != '')
                        FFButtonWidget(
                          onPressed: () async {
                            Navigator.pop(context, false);
                          },
                          text: valueOrDefault<String>(
                            widget.cancelButton,
                            'Cancel',
                          ),
                          options: FFButtonOptions(
                            width: 140.0,
                            height: 50.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: AppTheme.of(context).alternate,
                            textStyle: AppTheme.of(context).titleSmall.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: AppTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: AppTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: AppTheme.of(context).secondaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: AppTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle:
                                      AppTheme.of(context).titleSmall.fontStyle,
                                ),
                            elevation: 1.0,
                            borderSide: BorderSide(
                              color: AppTheme.of(context).secondaryText,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      FFButtonWidget(
                        onPressed: () async {
                          Navigator.pop(context, true);
                          await widget.confirmCallback?.call();
                        },
                        text: valueOrDefault<String>(
                          widget.confirmButton,
                          'Confirm',
                        ),
                        options: FFButtonOptions(
                          width: 140.0,
                          height: 50.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: AppTheme.of(context).accent1,
                          textStyle: AppTheme.of(context).titleSmall.override(
                                font: GoogleFonts.inter(
                                  fontWeight: AppTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle:
                                      AppTheme.of(context).titleSmall.fontStyle,
                                ),
                                color: AppTheme.of(context).primary,
                                letterSpacing: 0.0,
                                fontWeight:
                                    AppTheme.of(context).titleSmall.fontWeight,
                                fontStyle:
                                    AppTheme.of(context).titleSmall.fontStyle,
                              ),
                          elevation: 0.0,
                          borderSide: BorderSide(
                            color: AppTheme.of(context).primary,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ],
                  ),
                ].divide(SizedBox(height: 16.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
