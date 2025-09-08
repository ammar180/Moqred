import '/utils/app_util.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'drawer_model.dart';
export 'drawer_model.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late DrawerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DrawerModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
      child: Container(
        width: 165.77,
        height: 240.4,
        decoration: BoxDecoration(
          color: AppTheme.of(context).secondaryBackground,
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              FFButtonWidget(
                onPressed: () async {
                  safeSetState(() {});
                },
                text: "استلام اشعارات",
                options: FFButtonOptions(
                  height: 31.09,
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: AppTheme.of(context).primary,
                  textStyle: AppTheme.of(context).titleSmall.override(
                        font: GoogleFonts.inter(
                          fontWeight:
                              AppTheme.of(context).titleSmall.fontWeight,
                          fontStyle: AppTheme.of(context).titleSmall.fontStyle,
                        ),
                        color: Colors.white,
                        letterSpacing: 0.0,
                        fontWeight: AppTheme.of(context).titleSmall.fontWeight,
                        fontStyle: AppTheme.of(context).titleSmall.fontStyle,
                      ),
                  elevation: 0.0,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "الوضع المظلم",
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
                  Switch.adaptive(
                    value: _model.switchValue ??=
                        Theme.of(context).brightness == Brightness.dark,
                    onChanged: (newValue) async {
                      safeSetState(() => _model.switchValue = newValue);
                      if (newValue) {
                        setDarkModeSetting(
                          context,
                          _model.switchValue!
                              ? ThemeMode.dark
                              : ThemeMode.light,
                        );
                      } else {
                        setDarkModeSetting(
                          context,
                          _model.switchValue!
                              ? ThemeMode.dark
                              : ThemeMode.light,
                        );
                      }
                    },
                    activeColor: AppTheme.of(context).primary,
                    activeTrackColor: AppTheme.of(context).primary,
                    inactiveTrackColor: AppTheme.of(context).alternate,
                    inactiveThumbColor:
                        AppTheme.of(context).secondaryBackground,
                  ),
                ],
              ),
              FFButtonWidget(
                onPressed: () async {},
                text: "تحديث كلمة المرور",
                icon: Icon(
                  Icons.lock,
                  color: AppTheme.of(context).primaryBackground,
                  size: 15.0,
                ),
                options: FFButtonOptions(
                  height: 40.0,
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: AppTheme.of(context).primary,
                  textStyle: AppTheme.of(context).titleSmall.override(
                        font: GoogleFonts.inter(
                          fontWeight:
                              AppTheme.of(context).titleSmall.fontWeight,
                          fontStyle: AppTheme.of(context).titleSmall.fontStyle,
                        ),
                        color: Colors.white,
                        letterSpacing: 0.0,
                        fontWeight: AppTheme.of(context).titleSmall.fontWeight,
                        fontStyle: AppTheme.of(context).titleSmall.fontStyle,
                      ),
                  elevation: 0.0,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ].divide(SizedBox(height: 10.0)),
          ),
        ),
      ),
    );
  }
}
