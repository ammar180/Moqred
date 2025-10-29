import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  static List<String> languages() => ['ar', 'en'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? arText = '',
    String? enText = '',
  }) =>
      [arText, enText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {'en', 'ar'};
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture<AppLocalizations>(AppLocalizations(locale));

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return AppLocalizations.languages().contains(
    language.endsWith('_')
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // NavBarPage
  {
    '40zv2ebw': {
      'en': 'Home',
      'ar': 'الرئيسية',
    },
    'nav_transactions': {
      'en': 'Transactions',
      'ar': 'المعاملات',
    },
    'nav_settings': {
      'en': 'Settings',
      'ar': 'الإعدادات',
    },
  },
  // Transactions Page
  {
    'transactions_title': {
      'en': 'All Transactions Record',
      'ar': 'سجل كل المعاملات',
    },
    'transactions_person': {
      'en': 'Person',
      'ar': 'الشخص',
    },
    'transactions_amount': {
      'en': 'Amount',
      'ar': 'المبلغ',
    },
    'transactions_type': {
      'en': 'Type',
      'ar': 'النوع',
    },
    'transactions_date': {
      'en': 'Date',
      'ar': 'تاريخ',
    },
    'transactions_delete': {
      'en': 'Delete',
      'ar': 'حذف',
    },
  },
  // Settings Page
  {
    'settings_title': {
      'en': 'Settings',
      'ar': 'الإعدادات',
    },
    'settings_backup_restore': {
      'en': 'Backup & Restore',
      'ar': 'النسخ الاحتياطي والاستعادة',
    },
    'settings_backup': {
      'en': 'Backup',
      'ar': 'نسخ احتياطي',
    },
    'settings_restore': {
      'en': 'Restore',
      'ar': 'استعادة',
    },
    'settings_backup_success': {
      'en': 'Backup successful',
      'ar': 'تم النسخ الاحتياطي بنجاح',
    },
    'settings_backup_failed': {
      'en': 'Backup failed',
      'ar': 'فشل النسخ الاحتياطي',
    },
    'settings_restore_success': {
      'en': 'Restore successful',
      'ar': 'تمت الاستعادة بنجاح',
    },
    'settings_restore_failed': {
      'en': 'Restore failed',
      'ar': 'فشلت الاستعادة',
    },
    'settings_synced': {
      'en': 'Data synchronized',
      'ar': 'البيانات متزامنة',
    },
    'settings_not_synced': {
      'en': 'Data not synchronized',
      'ar': 'البيانات غير متزامنة',
    },
    'settings_language': {
      'en': 'Language',
      'ar': 'اللغة',
    },
    'settings_language_en': {
      'en': 'English',
      'ar': 'الإنجليزية',
    },
    'settings_language_ar': {
      'en': 'العربية',
      'ar': 'العربية',
    },
    'settings_dark_mode': {
      'en': 'Dark Mode',
      'ar': 'الوضع الداكن',
    },
    'settings_default_types': {
      'en': 'Default Transaction Types',
      'ar': 'أنواع المعاملات الافتراضية',
    },
    'settings_loading_types_error': {
      'en': 'Failed to load types',
      'ar': 'تعذر تحميل الأنواع',
    },
    'settings_no_types': {
      'en': 'No types defined',
      'ar': 'لا يوجد أنواع معرفة',
    },
    'settings_add_new_type': {
      'en': 'Add New Type',
      'ar': 'إضافة نوع جديد',
    },
    'settings_type_id': {
      'en': 'Type ID (e.g., loan/payment)',
      'ar': 'المعرف (type) مثل loan/payment',
    },
    'settings_display_name': {
      'en': 'Display Name',
      'ar': 'الاسم الظاهر',
    },
    'settings_sign': {
      'en': 'Sign',
      'ar': 'الإشارة (sign)',
    },
    'settings_positive_sign': {
      'en': 'Positive (+1)',
      'ar': 'موجب (+1)',
    },
    'settings_negative_sign': {
      'en': 'Negative (-1)',
      'ar': 'سالب (-1)',
    },
    'settings_zero_sign': {
      'en': 'None (0)',
      'ar': 'لاشيء (0)',
    },
    'settings_save': {
      'en': 'Save',
      'ar': 'حفظ',
    },
    'settings_type_added_success': {
      'en': 'Transaction type added successfully',
      'ar': 'تم إضافة نوع المعاملة بنجاح',
    },
    'settings_type_add_failed': {
      'en': 'Add failed. Make sure type is not duplicate',
      'ar': 'فشل الإضافة. تأكد أن النوع غير مكرر',
    },
    'settings_processing': {
      'en': 'Processing... Please wait',
      'ar': 'جاري التنفيذ... برجاء الانتظار',
    },
  },
  // Person Details Page
  {
    'person_details_title': {
      'en': 'Person Details',
      'ar': 'تفاصيل الشخص',
    },
    'person_edit': {
      'en': 'Edit',
      'ar': 'تعديل',
    },
    'person_name': {
      'en': 'Name',
      'ar': 'الاسم',
    },
    'person_name_required': {
      'en': 'Name is required',
      'ar': 'الاسم أساسي',
    },
  },
  // Transaction Type names
  {
    'type_loan': {
      'en': 'Loan',
      'ar': 'قرض',
    },
    'type_payment': {
      'en': 'Payment',
      'ar': 'سداد',
    },
    'type_filling': {
      'en': 'Filling',
      'ar': 'ملئ',
    },
    'type_donate': {
      'en': 'Donation',
      'ar': 'تبرع',
    },
    'type_unknown': {
      'en': 'Unknown',
      'ar': 'غير معروف',
    },
  },
  // General
  {
    'required_field': {
      'en': 'Required',
      'ar': 'مطلوب',
    },
    'error': {
      'en': 'Error',
      'ar': 'خطأ',
    },
  },
  // Add Person Component
  {
    'add_person_title': {
      'en': 'Add Person to Database',
      'ar': 'إضافة شخص لقاعدة البيانات',
    },
    'add_person_subtitle': {
      'en': 'Person must be registered before recording transactions',
      'ar': 'من الضروري ان يكون الشخص مسجل حتى يتم تسجيل العمليات عليه',
    },
    'add_person_name_label': {
      'en': 'Name',
      'ar': 'الاسم',
    },
    'add_person_name_hint': {
      'en': 'Person name',
      'ar': 'اسم الشخص',
    },
    'add_person_phone_label': {
      'en': 'Phone number',
      'ar': 'رقم الهاتف',
    },
    'add_person_related_to_label': {
      'en': 'Related to:',
      'ar': 'على صلة ب: ',
    },
    'add_person_related_to_hint': {
      'en': 'Select related person',
      'ar': 'اختر شخص على صلة به',
    },
    'add_person_notes_hint': {
      'en': 'Additional notes',
      'ar': 'ملاحظات اضافية',
    },
    'add_person_submit': {
      'en': 'Add',
      'ar': 'إضافة',
    },
  },
  // New Transaction Component
  {
    'new_tx_title': {
      'en': 'New Transaction Details',
      'ar': 'بيانات المعاملة الجديدة',
    },
    'new_tx_subtitle': {
      'en': 'Enter details and type: loan, payment, donation',
      'ar': 'أدخل تفاصيل المعاملة ونوعها: قرض، سداد، تبرع ',
    },
    'new_tx_amount_label': {
      'en': 'Amount:',
      'ar': 'المبلغ:',
    },
    'new_tx_amount_field_label': {
      'en': 'Amount',
      'ar': 'المبلغ',
    },
    'new_tx_amount_hint': {
      'en': '0 EGP',
      'ar': '0 ج.م',
    },
    'new_tx_type_label': {
      'en': 'Transaction type:',
      'ar': 'نوع المعاملة: ',
    },
    'new_tx_type_hint': {
      'en': 'Select transaction type',
      'ar': 'اختر نوع المعاملة',
    },
    'new_tx_person_label': {
      'en': 'Person:',
      'ar': 'الشخص:',
    },
    'new_tx_person_hint': {
      'en': 'Select person',
      'ar': 'اختر صاحب العملية',
    },
    'new_tx_notes_hint': {
      'en': 'Notes',
      'ar': 'ملاحظات',
    },
    'new_tx_submit': {
      'en': 'Submit',
      'ar': 'تنفيذ',
    },
    'new_tx_success': {
      'en': 'Transaction added successfully',
      'ar': 'تم إضافة المعاملة بنجاح',
    },
  },
  // Backend error messages
  {
    'err_add_transaction': {
      'en': 'An error occurred while adding the transaction',
      'ar': 'حدث خطأ أثناء إضافة المعاملة',
    },
    'err_add_person': {
      'en': 'An error occurred while adding the person',
      'ar': 'حدث خطأ أثناء إضافة الشخص',
    },
    'err_update_person': {
      'en': 'An error occurred while updating the person',
      'ar': 'حدث خطأ أثناء تحديث بيانات الشخص',
    },
    'err_delete': {
      'en': 'An error occurred while deleting',
      'ar': 'حدث خطأ أثناء الحذف',
    },
    'err_add_tx_type': {
      'en': 'An error occurred while adding transaction type',
      'ar': 'حدث خطأ أثناء إضافة نوع المعاملة',
    },
  },
  // Home Page
  {
    'home_current_loans': {
      'en': 'Current Loans',
      'ar': 'القروض الحالية',
    },
    'home_subtitle': {
      'en': 'Preview current balance plus list of people and current loans',
      'ar':
          'يتيح معاينة الرصيد الحالي بالاضافة لقائمة بالاشخاص والقروض الحالية',
    },
    'home_available_amount': {
      'en': 'Available Amount',
      'ar': 'المبلغ المتوافر',
    },
    'home_total_amount': {
      'en': 'Total Amount',
      'ar': 'المبلغ الاجمالي',
    },
    'home_outgoing_amount': {
      'en': 'Outgoing Amount',
      'ar': 'المبلغ الخارج',
    },
    'home_error_loading_balance': {
      'en': 'Sorry, error loading balance details',
      'ar': 'عذرا، خطأ في تحميل تفاصيل الرصيد',
    },
    'home_no_data': {
      'en': 'No data yet',
      'ar': 'لا يوجد بيانات حتى الان',
    },
    'home_new_transaction': {
      'en': 'New Transaction',
      'ar': 'معاملة جديدة',
    },
    'home_borrower': {
      'en': 'Borrower',
      'ar': 'المقترض',
    },
    'home_remaining': {
      'en': 'Remaining',
      'ar': 'المتبقي',
    },
    'home_date': {
      'en': 'Date',
      'ar': 'تاريخ',
    },
    'home_no_loans': {
      'en': 'No active loans yet',
      'ar': 'لا يوجد قروض قائمة حتى الان',
    },
  }
].reduce((a, b) => a..addAll(b));
