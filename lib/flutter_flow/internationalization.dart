import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

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

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
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

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith('_')
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // HomePage
  {
    'ck5uo4n2': {
      'ar': 'مرحباً، ',
      'en': 'Welcome,',
    },
    'f92j5iul': {
      'ar': 'الإجازات (العارضة)',
      'en': 'Leaves (Casual)',
    },
    'l3uvfh86': {
      'ar': 'الإجازات (الاعتيادية)',
      'en': 'Leaves (regular)',
    },
    'zpg9x7sr': {
      'ar': 'أنشاء طلب',
      'en': 'New Request',
    },
    'bv1ia011': {
      'ar': 'تفاصيل الرصيد',
      'en': 'Balance Details',
    },
    'r2eks3oa': {
      'ar': 'طلبات الموظفين',
      'en': 'Staff Requests',
    },
    '3k8negc4': {
      'ar': 'الطلبات السابقة',
      'en': 'Past Requests',
    },
    'ytmie65a': {
      'ar': 'أنشاء طلب',
      'en': 'New Request',
    },
    'yxor8jdp': {
      'ar': 'تفاصيل الرصيد',
      'en': 'Balance Details',
    },
    'ibewobd7': {
      'ar': 'طلبات الموظفين',
      'en': 'Staff Requests',
    },
    'ape7dq7o': {
      'ar': 'الطلبات السابقة',
      'en': 'Past Requests',
    },
    'glg56agq': {
      'ar': 'تسجيل الخروج',
      'en': 'Sign out',
    },
    'ppsl4cwu': {
      'ar': 'Home',
      'en': 'Home',
    },
  },
  // Login
  {
    'bixi8vgu': {
      'ar': 'Elsewedy HR',
      'en': 'Elsewedy HR',
    },
    'yie4jqyp': {
      'ar': 'مدير طلبات الموظفين',
      'en': 'Employee Requests Manager',
    },
    'anjl8175': {
      'ar':
          'تواصل مع مسؤول الHR للحصول على معلومات  تسجيل الدخول للتطبيق للقيام بعمليات ارسال الطلبات الى المدير',
      'en':
          'Contact your HR manager to get the app login information to send requests to your manager.',
    },
    'zym19whp': {
      'ar': 'كود الموظف',
      'en': 'Employee Code',
    },
    'xm9v25oq': {
      'ar': 'كلمة المرور',
      'en': 'password',
    },
    '5dg28wk6': {
      'ar': 'تسجيل الدخول',
      'en': 'Log in',
    },
    'zb2ce6p7': {
      'ar': 'برجاء التحقق من الاتصال بالشبكة، ثم إعادة المحاولة',
      'en': 'Please check your network connection and try again.',
    },
    'w45rv5yv': {
      'ar': 'نعم',
      'en': 'Yes',
    },
    'bo824oqk': {
      'ar': 'نعم',
      'en': 'Yes',
    },
    '8fwz69eg': {
      'ar': 'كود الموظف مطلوب',
      'en': 'EmployeeCode Is required',
    },
    '6i1ranyw': {
      'ar': 'Please choose an option from the dropdown',
      'en': '',
    },
    'fooz2fkw': {
      'ar': 'كلمة المرور مطلوبة',
      'en': 'Password required',
    },
    'prth9qfk': {
      'ar': 'Please choose an option from the dropdown',
      'en': '',
    },
    '8mdapvu0': {
      'ar': 'Home',
      'en': '',
    },
  },
  // PastRequests
  {
    '2xgb1tfb': {
      'ar': 'الطلبات السابقة',
      'en': 'Past Requests',
    },
    'y5htwb9n': {
      'ar': 'تنبيه',
      'en': 'Alert',
    },
    '5365w3zo': {
      'ar': 'هل تريد الغاء الطلب',
      'en': 'Did you want to delete Transaction',
    },
    'jgmk98m8': {
      'ar': 'نعم',
      'en': 'yes',
    },
    'fq6rwgap': {
      'ar': 'مشكلة',
      'en': 'Alert',
    },
    'kg0mldyx': {
      'ar': 'نعم',
      'en': 'yes',
    },
    '18js75n0': {
      'ar': 'إلغاء',
      'en': 'Cancel',
    },
    'tleebcfp': {
      'ar': 'Home',
      'en': '',
    },
  },
  // StaffRequests
  {
    'zhsb0l8z': {
      'ar': 'طلبات الموظفين',
      'en': 'Staff Requests',
    },
    'kg23s0x1': {
      'ar': 'Home',
      'en': '',
    },
  },
  // StaffRequestDetails
  {
    'tc8vycpd': {
      'ar': 'تفاصيل طلب الموظف',
      'en': 'Employee Request Details',
    },
    'k664yqap': {
      'ar': ' #',
      'en': '',
    },
    'rqikob8z': {
      'ar': 'تاريخ الإرسال: ',
      'en': '',
    },
    '8ctrwtg6': {
      'ar': 'طلب ',
      'en': '',
    },
    'sfrnx5t5': {
      'ar': ' ',
      'en': '',
    },
    'ihcht7kx': {
      'ar': 'تاريخ البداية',
      'en': '',
    },
    'wfep9cu4': {
      'ar': 'المدة',
      'en': '',
    },
    '4tl1hd3h': {
      'ar': 'تاريخ النهاية',
      'en': '',
    },
    'dwzyavf6': {
      'ar': 'خط السير',
      'en': 'خط السير',
    },
    'yooxbg1c': {
      'ar': 'الجيزة',
      'en': '',
    },
    'svuac7nd': {
      'ar': 'الموظف البديل',
      'en': '',
    },
    'vy3ca4em': {
      'ar': ' #',
      'en': '',
    },
    'cm9fhzrn': {
      'ar': 'رد المدير',
      'en': 'Manager Responce Message',
    },
    'jo16vekd': {
      'ar': 'الرسالة اللتي ستظهر للموظف في الرد ...',
      'en': '',
    },
    'augdl2jd': {
      'ar': 'رد المدير مطلوب في حالة رفض الطلب',
      'en': 'Response Message Required in rejection',
    },
    'nh587ar6': {
      'ar': 'برجاء تقديم رسالة واضحة',
      'en': 'Please provide good message',
    },
    'cic59opm': {
      'ar': 'Please choose an option from the dropdown',
      'en': '',
    },
    'agdsnew7': {
      'ar': 'رفض الطلب',
      'en': '',
    },
    '8nd3eo36': {
      'ar': 'نعم',
      'en': 'yes',
    },
    '0svoi46d': {
      'ar': 'نعم',
      'en': 'Yes',
    },
    '2t3vh8n2': {
      'ar': 'قبول الطلب',
      'en': '',
    },
    'uc3jjsbj': {
      'ar': 'نعم',
      'en': 'yes',
    },
    'ofpcxh66': {
      'ar': 'نعم',
      'en': 'Yes',
    },
  },
  // UpdatePassword
  {
    'qriqqojk': {
      'ar': 'كلمة المرور القديمة',
      'en': 'password',
    },
    '6evqsi6p': {
      'ar': ' كلمة المرور الجديدة',
      'en': 'password',
    },
    'ab5co6l2': {
      'ar': 'تاكيد كلمة المرور',
      'en': 'password',
    },
    '8bhvt3ek': {
      'ar': 'تحديث كلمة المرور',
      'en': 'Update',
    },
    'lovyq5ji': {
      'ar': 'برجاء التحقق من الاتصال بالشبكة، ثم إعادة المحاولة',
      'en': 'Please check your network connection and try again.',
    },
    'z3mun7oi': {
      'ar': 'نعم',
      'en': 'Yes',
    },
    '6tmket1l': {
      'ar': 'نعم',
      'en': 'Yes',
    },
    'qvow8rhg': {
      'ar': 'كلمة المرور مطلوبة',
      'en': 'Password required',
    },
    '8kxxme5o': {
      'ar': 'Please choose an option from the dropdown',
      'en': '',
    },
    '1uko0py4': {
      'ar': ' كلمة المرور الجديدة مطلوب',
      'en': '',
    },
    '1zmkexyl': {
      'ar': 'Please choose an option from the dropdown',
      'en': '',
    },
    '77zgd4s5': {
      'ar': 'تاكيد كلمة المرور مطلوب',
      'en': '',
    },
    '7m8afud7': {
      'ar': 'Please choose an option from the dropdown',
      'en': '',
    },
    'oztsc8r5': {
      'ar': 'تحديث كلمة المرور',
      'en': 'Update password',
    },
    '780x5dcc': {
      'ar': 'Home',
      'en': '',
    },
  },
  // BalanceReport
  {
    'xizc65p7': {
      'ar': 'تقرير الرصيد',
      'en': 'Balance Report',
    },
    'hn59r4ud': {
      'ar': 'تفاصيل الموظف',
      'en': '',
    },
    'b7cjrzfq': {
      'ar': 'درجة الموظف: من الفئة (1)',
      'en': '',
    },
    '103u96mm': {
      'ar': 'رصيد الإجازات',
      'en': '',
    },
    'bgntex23': {
      'ar': 'نوع الاجازة',
      'en': 'leave type',
    },
    't777udh5': {
      'ar': 'عارضة',
      'en': '',
    },
    '6kdlmz5m': {
      'ar': 'إعتيادية',
      'en': '',
    },
    'd144sdk1': {
      'ar': 'العام الحالي',
      'en': 'Current Year',
    },
    'sz9j4tzz': {
      'ar': 'العام السابق',
      'en': '',
    },
    '6lzb4207': {
      'ar': 'المستهلكات',
      'en': '',
    },
    'yjl7c59f': {
      'ar': 'الإجمالي',
      'en': '',
    },
    'rtyz9mlv': {
      'ar': 'سجل الإجازات',
      'en': '',
    },
    '0ngtaxmt': {
      'ar': 'بداية الاجازة',
      'en': '',
    },
    '25cum0n4': {
      'ar': 'نهاية الاجازة',
      'en': '',
    },
    'wgfwfp94': {
      'ar': 'المدة',
      'en': '',
    },
    'xg47yntw': {
      'ar': 'Home',
      'en': '',
    },
  },
  // SendRequest
  {
    'w0mxk95u': {
      'ar': 'إجازة',
      'en': 'Leave',
    },
    '074u46uj': {
      'ar': 'المدير: ',
      'en': 'Manager',
    },
    '7v4m42eq': {
      'ar': 'الادارة: ',
      'en': 'Department',
    },
    'tcf8yc84': {
      'ar': 'من: ',
      'en': 'From',
    },
    's8rpvnri': {
      'ar': 'إلى: ',
      'en': 'To: ',
    },
    'y34olog1': {
      'ar': 'النوع: ',
      'en': 'Type: ',
    },
    'pzj9qzm8': {
      'ar': 'اختر نوع الاجازة',
      'en': 'leave type',
    },
    'ai4bayo8': {
      'ar': 'إجازة جزئية',
      'en': 'Type: ',
    },
    '6aac6fuf': {
      'ar': 'الزميل البديل:',
      'en': 'Type: ',
    },
    'jjlzbfq6': {
      'ar': 'اختر الموظف البديل',
      'en': 'leave type',
    },
    '039ipfc9': {
      'ar': 'مأمورية',
      'en': 'Mission',
    },
    'lsqzmtch': {
      'ar': 'ارسال الطلب',
      'en': 'Send Request',
    },
    'bj7akq8c': {
      'ar': 'تم',
      'en': 'Yes',
    },
    '56jfsp90': {
      'ar': 'تم',
      'en': 'Yes',
    },
    'z5x1mlbo': {
      'ar': 'تم',
      'en': 'Yes',
    },
    'qabjorho': {
      'ar': 'ارسال طلب',
      'en': '',
    },
    'njlv34am': {
      'ar': 'Home',
      'en': '',
    },
  },
  // MyRequestDetails
  {
    '1j6ifzje': {
      'ar': 'تفاصيل الطلب',
      'en': 'My Request Details',
    },
    '0s2u4if0': {
      'ar': 'إلى المدير: ',
      'en': '',
    },
    'eimcco9y': {
      'ar': 'تاريخ الإرسال: ',
      'en': '',
    },
    '2i622pfg': {
      'ar': 'تاريخ الاستجابة: ',
      'en': '',
    },
    'xp2qrm5l': {
      'ar': 'طلب ',
      'en': '',
    },
    '1bkoqtr4': {
      'ar': ' ',
      'en': '',
    },
    'ts8zmugm': {
      'ar': 'تاريخ البداية',
      'en': '',
    },
    'aesle943': {
      'ar': 'المدة',
      'en': '',
    },
    '7sa4jtfq': {
      'ar': 'تاريخ النهاية',
      'en': '',
    },
    '7bi5r1fl': {
      'ar': 'خط السير',
      'en': 'خط السير',
    },
    '1rtthqyn': {
      'ar': 'الجيزة',
      'en': '',
    },
    '353x8ou6': {
      'ar': 'الموظف البديل',
      'en': '',
    },
    'pscgnxvd': {
      'ar': ' #',
      'en': '',
    },
    'bph6x468': {
      'ar': 'رد المدير',
      'en': 'Manager Responce Message',
    },
    'm2prz2b8': {
      'ar': 'إلغاء الطلب',
      'en': 'Cancel Request',
    },
    'k2a34cn3': {
      'ar': 'نعم',
      'en': 'yes',
    },
    '14wm8z54': {
      'ar': 'نعم',
      'en': 'Yes',
    },
    'a9842z7q': {
      'ar': 'إعادة إرسال',
      'en': 'Resend Request',
    },
    'ibtm0zr1': {
      'ar': 'نعم',
      'en': 'yes',
    },
    'cn7hekie': {
      'ar': 'نعم',
      'en': 'Yes',
    },
  },
  // EditRequest
  {
    'qab8pr52': {
      'ar': 'تفاصيل الطلب',
      'en': '',
    },
    'xa2bt6v5': {
      'ar': 'من: ',
      'en': 'From',
    },
    'mwblj1zu': {
      'ar': 'إلى: ',
      'en': 'To: ',
    },
    'pxsi7r2c': {
      'ar': 'النوع: ',
      'en': 'Type: ',
    },
    'm81drpyi': {
      'ar': 'اختر نوع الاجازة',
      'en': 'leave type',
    },
    'zxthodkb': {
      'ar': 'الزميل البديل:',
      'en': 'Type: ',
    },
    'xxso5oev': {
      'ar': 'اختر الموظف البديل',
      'en': 'leave type',
    },
    'sylzhen9': {
      'ar': 'ارسال الطلب',
      'en': 'Send Request',
    },
    'r90n1yuv': {
      'ar': 'تم',
      'en': 'Yes',
    },
    'k0h1frh3': {
      'ar': 'تم',
      'en': 'Yes',
    },
    'e3rt0hm9': {
      'ar': 'تم',
      'en': 'Yes',
    },
    'edwv3nw3': {
      'ar': 'تعديل طلب',
      'en': '',
    },
    's48o3dhf': {
      'ar': 'Home',
      'en': '',
    },
  },
  // PastRequestsListItem
  {
    'vat9bmkp': {
      'ar': ' ',
      'en': '',
    },
    'p0l2ux06': {
      'ar': 'Mon. July 3rd',
      'en': '',
    },
    'j1vekgi3': {
      'ar': 'إلغاء الطلب',
      'en': 'Cancel',
    },
  },
  // StaffRequestsListItem
  {
    '7dklu43g': {
      'ar': 'طلب',
      'en': '',
    },
    '1k8cbqlu': {
      'ar': ' ',
      'en': '',
    },
    'yc3nl8ql': {
      'ar': ' (',
      'en': '',
    },
    '8oz4li1l': {
      'ar': ')',
      'en': '',
    },
    '0qgt6v2m': {
      'ar': 'Mon. July 3rd',
      'en': '',
    },
    'pt12u6ft': {
      'ar': 'إشعار جديد',
      'en': 'الحالة',
    },
    'vkugn5py': {
      'ar': ' | ',
      'en': '',
    },
  },
  // DrawerComp
  {
    '7o37k0v5': {
      'ar': 'استلام اشعارات',
      'en': 'Enable Notifications',
    },
    'ez81j993': {
      'ar': '',
      'en': '',
    },
    'j6sjpwu5': {
      'ar': 'اختر اللغة...',
      'en': 'Choos Language',
    },
    'xgjg2qhd': {
      'ar': 'Search...',
      'en': '',
    },
    '9weh2cno': {
      'ar': 'العربية',
      'en': 'Arabic',
    },
    '9mfw75bt': {
      'ar': 'الانجليزية',
      'en': 'English',
    },
    'q6xqdami': {
      'ar': 'الوضع المظلم',
      'en': 'Dark Mode',
    },
    '9f8uy4uc': {
      'ar': 'تحديث كلمة المرور',
      'en': 'update password',
    },
  },
  // Miscellaneous
  {
    'f8nhc0bi': {
      'ar':
          'برجاء السماح للإشعارات للبقاء على اطلاع دائم بأحدث التنبيهات والتحديثات. يمكنك إدارة إعدادات الإشعارات في أي وقت من خلال تفضيلاتك.',
      'en': '',
    },
    'l4bzjec9': {
      'ar': '',
      'en': '',
    },
    'phq9jb2g': {
      'ar': '',
      'en': '',
    },
    'gf239dgv': {
      'ar': '',
      'en': '',
    },
    'dlerl5ag': {
      'ar': '',
      'en': '',
    },
    'fgqqyvt2': {
      'ar': '',
      'en': '',
    },
    'ui78o5am': {
      'ar': '',
      'en': '',
    },
    'u9fpm0lv': {
      'ar': '',
      'en': '',
    },
    'mw87j96z': {
      'ar': '',
      'en': '',
    },
    'arh4i9uk': {
      'ar': '',
      'en': '',
    },
    'kumiblob': {
      'ar': '',
      'en': '',
    },
    'gtepiyrl': {
      'ar': '',
      'en': '',
    },
    'w7j6pzrj': {
      'ar': '',
      'en': '',
    },
    'cgd5zmcs': {
      'ar': '',
      'en': '',
    },
    '17u504y3': {
      'ar': '',
      'en': '',
    },
    'xpm9ia7z': {
      'ar': '',
      'en': '',
    },
    'frwl8h6h': {
      'ar': '',
      'en': '',
    },
    '8w2z5swl': {
      'ar': '',
      'en': '',
    },
    '2j2bx5mg': {
      'ar': '',
      'en': '',
    },
    'g4byk2re': {
      'ar': '',
      'en': '',
    },
    'tbofym9i': {
      'ar': '',
      'en': '',
    },
    'azv1o3m3': {
      'ar': '',
      'en': '',
    },
    'np71kcja': {
      'ar': '',
      'en': '',
    },
    '4lky3a3u': {
      'ar': '',
      'en': '',
    },
    'gjfe2dut': {
      'ar': '',
      'en': '',
    },
    '3ldr55dd': {
      'ar': '',
      'en': '',
    },
  },
].reduce((a, b) => a..addAll(b));
