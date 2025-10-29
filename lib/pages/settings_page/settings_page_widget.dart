import 'package:flutter/material.dart';
import 'package:moqred/backend/db_requests/db_calls.dart';
import 'package:moqred/backend/schema/models/transaction_type.dart';
import 'package:moqred/backend/sync/sync_manager.dart';
import 'package:moqred/main.dart';
import 'package:moqred/utils/app_theme.dart';
import '/utils/internationalization.dart';
import '/flutter_flow/flutterflow_ui.dart';

class SettingsPageWidget extends StatefulWidget {
  const SettingsPageWidget({super.key});

  static String routeName = 'settings_page';
  static String routePath = '/settings';

  @override
  State<SettingsPageWidget> createState() => _SettingsPageWidgetState();
}

class _SettingsPageWidgetState extends State<SettingsPageWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  int _sign = 1;
  bool _busy = false;
  final _sync = SyncManager();

  @override
  void dispose() {
    _typeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await InsertTransactionTypeCall.call(
        type: _typeController.text.trim(),
        name: _nameController.text.trim(),
        sign: _sign,
      );
      _typeController.clear();
      _nameController.clear();
      safeSetState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).getText('settings_type_added_success' /* Transaction type added successfully */),
            style: TextStyle(
              color: AppTheme.of(context).primaryText,
            ),
          ),
          duration: Duration(milliseconds: 4000),
          backgroundColor: AppTheme.of(context).secondary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).getText('settings_type_add_failed' /* Add failed */))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.of(context).secondaryBackground,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).getText('settings_title' /* Settings */)),
        backgroundColor: AppTheme.of(context).secondaryBackground,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AppTheme.of(context).lineColor),
                  ),
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: _sync.syncStatus(),
                    builder: (context, snapshot) {
                      final inSync = snapshot.hasData
                          ? (snapshot.data!.values
                              .cast<Map>()
                              .every((v) => v['inSync'] == true))
                          : false;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(AppLocalizations.of(context).getText('settings_backup_restore' /* Backup & Restore */),
                              style: AppTheme.of(context).titleMedium),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: FFButtonWidget(
                                  onPressed: (_busy || inSync)
                                      ? null
                                      : () async {
                                          safeSetState(() => _busy = true);
                                          try {
                                            await _sync.backupToPocketBase();
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    backgroundColor:
                                                        AppTheme.of(context)
                                                            .success,
                                                  content: Text(
                                                      AppLocalizations.of(context).getText('settings_backup_success' /* Backup successful */))),
                                              );
                                            }
                                          } catch (e) {
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      '${AppLocalizations.of(context).getText('settings_backup_failed' /* Backup failed */)}: $e')),
                                              );
                                            }
                                          } finally {
                                            if (mounted)
                                              safeSetState(() => _busy = false);
                                          }
                                        },
                                  text: AppLocalizations.of(context).getText('settings_backup' /* Backup */),
                                  options: FFButtonOptions(
                                    height: 40.0,
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                    disabledColor: AppTheme.of(context).accent3,
                                    color: AppTheme.of(context).primary,
                                    textStyle: AppTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Colors.white,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FFButtonWidget(
                                  onPressed: (_busy || inSync)
                                      ? null
                                      : () async {
                                          safeSetState(() => _busy = true);
                                          try {
                                            await _sync.restoreFromPocketBase();
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    backgroundColor:
                                                        AppTheme.of(context)
                                                            .success,
                                                    content: Text(
                                                        AppLocalizations.of(context).getText('settings_restore_success' /* Restore successful */))),
                                              );
                                            }
                                          } catch (e) {
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        '${AppLocalizations.of(context).getText('settings_restore_failed' /* Restore failed */)}: $e')),
                                              );
                                            }
                                          } finally {
                                            if (mounted)
                                              safeSetState(() => _busy = false);
                                          }
                                        },
                                  text: AppLocalizations.of(context).getText('settings_restore' /* Restore */),
                                  options: FFButtonOptions(
                                    height: 40.0,
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                    color: AppTheme.of(context).secondary,
                                    disabledColor: AppTheme.of(context).accent3,
                                    textStyle: AppTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Colors.white,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                              inSync
                                  ? AppLocalizations.of(context).getText('settings_synced' /* Data synchronized */)
                                  : AppLocalizations.of(context).getText('settings_not_synced' /* Data not synchronized */),
                              style: AppTheme.of(context).labelMedium),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AppTheme.of(context).lineColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context).getText('settings_language' /* Language */),
                          style: AppTheme.of(context).bodyLarge),
                      DropdownButton<String>(
                        value: AppLocalizations.of(context).languageCode == 'ar' ? 'ar' : 'en',
                        items: [
                          DropdownMenuItem(
                            value: 'en',
                            child: Text(AppLocalizations.of(context).getText('settings_language_en' /* English */)),
                          ),
                          DropdownMenuItem(
                            value: 'ar',
                            child: Text(AppLocalizations.of(context).getText('settings_language_ar' /* العربية */)),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            MyApp.of(context).setLocale(value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AppTheme.of(context).lineColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context).getText('settings_dark_mode' /* Dark Mode */),
                          style: AppTheme.of(context).bodyLarge),
                      Switch.adaptive(
                        value: Theme.of(context).brightness == Brightness.dark,
                        onChanged: (isDark) {
                          final mode =
                              isDark ? ThemeMode.dark : ThemeMode.light;
                          MyApp.of(context).setThemeMode(mode);
                        },
                        activeColor: AppTheme.of(context).primary,
                        activeTrackColor: AppTheme.of(context).primary,
                        inactiveTrackColor: AppTheme.of(context).secondaryText,
                        inactiveThumbColor:
                            AppTheme.of(context).secondaryBackground,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context).getText('settings_default_types' /* Default Transaction Types */),
                    style: AppTheme.of(context).titleMedium),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AppTheme.of(context).lineColor),
                  ),
                  child: FutureBuilder<List<TransactionType>>(
                    future: FetchTransactionTypesCall.call(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                              child: CircularProgressIndicator(
                                  color: AppTheme.of(context).primary)),
                        );
                      }
                      if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(AppLocalizations.of(context).getText('settings_loading_types_error' /* Failed to load types */),
                              style: AppTheme.of(context).bodyMedium),
                        );
                      }
                      final items = snapshot.data ?? [];
                      if (items.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(AppLocalizations.of(context).getText('settings_no_types' /* No types defined */),
                              style: AppTheme.of(context).bodyMedium),
                        );
                      }
                      return Column(
                        children: items
                            .map((e) => ListTile(
                                  title: Text(e.name),
                                  subtitle: Text(e.type),
                                  trailing: Text(e.sign.toString(),
                                      style: AppTheme.of(context).labelMedium),
                                ))
                            .toList(),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context).getText('settings_add_new_type' /* Add New Type */), style: AppTheme.of(context).titleMedium),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AppTheme.of(context).lineColor),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _typeController,
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context).getText('settings_type_id' /* Type ID */)),
                          validator: (v) =>
                              (v == null || v.trim().isEmpty) ? AppLocalizations.of(context).getText('required_field' /* Required */) : null,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          decoration:
                              InputDecoration(labelText: AppLocalizations.of(context).getText('settings_display_name' /* Display Name */)),
                          validator: (v) =>
                              (v == null || v.trim().isEmpty) ? AppLocalizations.of(context).getText('required_field' /* Required */) : null,
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _sign,
                          items: [
                            DropdownMenuItem(
                                value: 1, child: Text(AppLocalizations.of(context).getText('settings_positive_sign' /* Positive */))),
                            DropdownMenuItem(
                                value: -1, child: Text(AppLocalizations.of(context).getText('settings_negative_sign' /* Negative */))),
                            DropdownMenuItem(
                                value: 0, child: Text(AppLocalizations.of(context).getText('settings_zero_sign' /* None */))),
                          ],
                          onChanged: (v) => safeSetState(() => _sign = v ?? 1),
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context).getText('settings_sign' /* Sign */)),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FFButtonWidget(
                            onPressed: _submit,
                            text: AppLocalizations.of(context).getText('settings_save' /* Save */),
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              color: AppTheme.of(context).primary,
                              textStyle:
                                  AppTheme.of(context).titleSmall.override(
                                        fontFamily: 'Inter',
                                        color: Colors.white,
                                      ),
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_busy) ...[
            ModalBarrier(dismissible: false, color: Colors.black26),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.of(context).lineColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          color: AppTheme.of(context).primary, strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Text(AppLocalizations.of(context).getText('settings_processing' /* Processing... Please wait */),
                        style: AppTheme.of(context).bodyMedium),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
