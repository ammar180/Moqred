import 'package:flutter/material.dart';
import 'package:moqred/backend/db_requests/db_calls.dart';
import 'package:moqred/backend/schema/models/transaction_type.dart';
import 'package:moqred/main.dart';
import 'package:moqred/utils/app_theme.dart';
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
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم إضافة نوع المعاملة بنجاح',
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
        SnackBar(content: Text('فشل الإضافة. تأكد أن النوع غير مكرر')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.of(context).secondaryBackground,
      appBar: AppBar(
        title: Text('الإعدادات'),
        backgroundColor: AppTheme.of(context).secondaryBackground,
      ),
      body: Padding(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('الوضع الداكن', style: AppTheme.of(context).bodyLarge),
                  Switch.adaptive(
                    value: Theme.of(context).brightness == Brightness.dark,
                    onChanged: (isDark) {
                      final mode = isDark ? ThemeMode.dark : ThemeMode.light;
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
            Text('أنواع المعاملات الافتراضية',
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
                      child: Text('تعذر تحميل الأنواع',
                          style: AppTheme.of(context).bodyMedium),
                    );
                  }
                  final items = snapshot.data ?? [];
                  if (items.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('لا يوجد أنواع معرفة',
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
            Text('إضافة نوع جديد', style: AppTheme.of(context).titleMedium),
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
                      decoration: const InputDecoration(
                          labelText: 'المعرف (type) مثل loan/payment'),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration:
                          const InputDecoration(labelText: 'الاسم الظاهر'),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: _sign,
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('موجب (+1)')),
                        DropdownMenuItem(value: -1, child: Text('سالب (-1)')),
                        DropdownMenuItem(value: 0, child: Text('لاشيء (0)')),
                      ],
                      onChanged: (v) => safeSetState(() => _sign = v ?? 1),
                      decoration:
                          const InputDecoration(labelText: 'الإشارة (sign)'),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FFButtonWidget(
                        onPressed: _submit,
                        text: 'حفظ',
                        options: FFButtonOptions(
                          height: 40.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          color: AppTheme.of(context).primary,
                          textStyle: AppTheme.of(context).titleSmall.override(
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
    );
  }
}
