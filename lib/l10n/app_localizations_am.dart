// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Amharic (`am`).
class AppLocalizationsAm extends AppLocalizations {
  AppLocalizationsAm([String locale = 'am']) : super(locale);

  @override
  String get appTitle => 'የአሽከርካሪ እገዛ';

  @override
  String get loginPhoneInvalidSnackbar =>
      'ትክክለኛ ስልክ ያስገቡ፦ 09…፣ 251… ወይም +251… (9 አኃዝ ሞባይል)።';

  @override
  String get loginWelcomeTitle => 'እንኳን ደህና መጡ';

  @override
  String get loginWelcomeSubtitle => 'ወደ መለያዎ ለመቀጠል ይግቡ';

  @override
  String get loginPhoneLabel => 'ስልክ ቁጥር';

  @override
  String get loginPhoneHint => '09…፣ 251… ወይም +251…';

  @override
  String get loginPasswordLabel => 'የይለፍ ቃል';

  @override
  String get loginPasswordHint => 'የይለፍ ቃልዎን ያስገቡ';

  @override
  String get loginButton => 'ግባ';

  @override
  String get loginNoAccountPrompt => 'መለያ የለዎትም? ';

  @override
  String get loginCreateAccount => 'መለያ ይፍጠሩ';

  @override
  String get signupEnterValidPhoneOtp => 'ኦቲፒ ከመጠየቅዎ በፊት ትክክለኛ ስልክ ያስገቡ።';

  @override
  String get signupPhoneVerifiedAutomatic => 'ስልክ ቁጥር በራስ-ሰር ተረጋግጧል።';

  @override
  String get signupFailedSendOtp => 'ኦቲፒ መላክ አልተሳካም።';

  @override
  String get signupOtpSentCheckSms => 'ኦቲፒ ተልኳል። ኤስኤምኤስዎን ይመልከቱ።';

  @override
  String signupOtpSetupFailed(String error) {
    return 'የኦቲፒ ማዋቀር አልተሳካም፦ $error';
  }

  @override
  String get signupRequestOtpFirst => 'መጀመሪያ ኦቲፒ ይጠይቁ።';

  @override
  String get signupEnterValidPhone => 'ትክክለኛ ስልክ ቁጥር ያስገቡ።';

  @override
  String get signupEnterSixDigitOtp => 'የ6 አኃዝ ኦቲፒ ኮድ ያስገቡ።';

  @override
  String get signupPasswordsMismatch => 'የይለፍ ቃሎች አይጣጣሙም';

  @override
  String get signupPasswordMin8 => 'የይለፍ ቃል ቢያንስ 8 ቁምፊዎች መሆን አለበት';

  @override
  String get signupPhoneInvalidSnackbar =>
      'ትክክለኛ ስልክ ያስገቡ፦ 09…፣ 251… ወይም +251… (9 አኃዝ ሞባይል)።';

  @override
  String get signupVerifyPhoneBeforeSignup => 'ከመመዝገብዎ በፊት ስልክዎን በኦቲፒ ያረጋግጡ።';

  @override
  String get signupFirebaseTokenMissing =>
      'ስልክ ተረጋግጧል፣ ነገር ግን የፋየርቤዝ ቶከን የለም። ኦቲፒ እንደገና ያረጋግጡ።';

  @override
  String get signupTitle => 'መለያ ይፍጠሩ';

  @override
  String get signupSubtitle => 'ከካርኬር ጋር ለመጀመር ይመዝገቡ';

  @override
  String get signupFirstName => 'የመጀመሪያ ስም';

  @override
  String get signupLastName => 'የአባት ስም';

  @override
  String get signupHintFirstName => 'ጆን';

  @override
  String get signupHintLastName => 'ዶ';

  @override
  String get signupEmail => 'ኢሜይል';

  @override
  String get signupEmailHint => 'you@example.com';

  @override
  String get signupPhoneLabel => 'ስልክ ቁጥር';

  @override
  String get signupPhoneHint => '09…፣ 251… ወይም +251…';

  @override
  String get signupSendOtp => 'ኦቲፒ ላክ';

  @override
  String get signupResendOtp => 'ኦቲፒ እንደገና ላክ';

  @override
  String get signupOtpCodeLabel => 'የኦቲፒ ኮድ';

  @override
  String get signupOtpHint => 'የ6 አኃዝ ኮድ ያስገቡ';

  @override
  String get signupVerify => 'አረጋግጥ';

  @override
  String get signupVerified => 'ተረጋግጧል';

  @override
  String get signupPasswordLabel => 'የይለፍ ቃል';

  @override
  String get signupPasswordHint => 'ቢያንስ 8 ቁምፊዎች';

  @override
  String get signupConfirmPasswordLabel => 'የይለፍ ቃል ያረጋግጡ';

  @override
  String get signupConfirmPasswordHint => 'የይለፍ ቃልዎን እንደገና ያስገቡ';

  @override
  String get signupCreateButton => 'መለያ ይፍጠሩ';

  @override
  String get signupOtpVerifiedSuccess => 'ኦቲፒ በተሳካ ሁኔታ ተረጋግጧል።';

  @override
  String get signupInvalidOtp => 'የማይሰራ የኦቲፒ ኮድ።';

  @override
  String get settingsTitle => 'ቅንብሮች';

  @override
  String get settingsLanguageSection => 'ቋንቋ';

  @override
  String get settingsLanguageEnglish => 'እንግሊዝኛ';

  @override
  String get settingsLanguageAmharic => 'አማርኛ';

  @override
  String get authLanguageChipEnglish => 'እንግሊዝኛ';

  @override
  String get authLanguageChipAmharic => 'አማርኛ';

  @override
  String get settingsChangePasswordTitle => 'የይለፍ ቃል ለውጥ';

  @override
  String get settingsChangePasswordSubtitle => 'አዲስ የይለፍ ቃል ለመግባት የአሁኑን ይጠቀሙ።';

  @override
  String get settingsCurrentPasswordLabel => 'የአሁን የይለፍ ቃል';

  @override
  String get settingsNewPasswordLabel => 'አዲስ የይለፍ ቃል';

  @override
  String get settingsConfirmNewPasswordLabel => 'አዲሱን የይለፍ ቃል ያረጋግጡ';

  @override
  String get settingsPasswordChanged => 'የይለፍ ቃል በተሳካ ሁኔታ ተቀይሯል';

  @override
  String get settingsRequestFailed => 'ጥያቄ አልተሳካም';

  @override
  String get settingsUnableChangePassword => 'የይለፍ ቃል አሁን ለውጥ አልተቻለም።';

  @override
  String get settingsValidatorCurrentRequired => 'የአሁን የይለፍ ቃል ያስፈልጋል';

  @override
  String get settingsValidatorNewRequired => 'አዲስ የይለፍ ቃል ያስፈልጋል';

  @override
  String get settingsValidatorNewMin6 => 'የይለፍ ቃል ቢያንስ 6 ቁምፊዎች መሆን አለበት';

  @override
  String get settingsValidatorNewDifferent => 'አዲሱ የይለፍ ቃል የተለየ መሆን አለበት';

  @override
  String get settingsValidatorConfirmRequired => 'አዲሱን የይለፍ ቃል ያረጋግጡ';

  @override
  String get settingsValidatorPasswordsMismatch => 'የይለፍ ቃሎች አይጣጣሙም';

  @override
  String get settingsUpdatePasswordButton => 'የይለፍ ቃል አዘምን';

  @override
  String get brandCarCare => 'CarCare';

  @override
  String get commonRetry => 'እንደገና ሞክር';

  @override
  String get commonCancel => 'ተወው';

  @override
  String get commonYes => 'አዎ';

  @override
  String get commonNo => 'አይ';

  @override
  String get commonContinue => 'ቀጥል';

  @override
  String get commonBack => 'ተመለስ';

  @override
  String get commonSubmit => 'ላክ';

  @override
  String get commonDelete => 'ሰርዝ';

  @override
  String get commonEdit => 'አርትዖት';

  @override
  String get commonReport => 'ሪፖርት';

  @override
  String get commonSave => 'አስቀምጥ';

  @override
  String get commonAdd => 'ጨምር';

  @override
  String get commonClear => 'አጽዳ';

  @override
  String get commonViewAll => 'ሁሉንም አሳይ';

  @override
  String get commonRemove => 'አስወግድ';

  @override
  String get commonBook => 'ቦክ';

  @override
  String get commonCall => 'ደውል';

  @override
  String get commonRoute => 'መንገድ';

  @override
  String get commonNavigate => 'አቅጣጫ';

  @override
  String get commonGuest => 'እንግዳ';

  @override
  String get commonEmDash => '—';

  @override
  String get drawerNavSection => 'አሰሳ';

  @override
  String get drawerAccountSection => 'መለያ';

  @override
  String get drawerHome => 'መነሻ';

  @override
  String get drawerMyVehicles => 'የእኔ ተሽከርካሪዎች';

  @override
  String get drawerService => 'አገልግሎት';

  @override
  String get drawerCommunity => 'ማህበረሰብ';

  @override
  String get drawerEducation => 'ትምህርት';

  @override
  String get drawerProfile => 'መገለጫ';

  @override
  String get drawerSettings => 'ቅንብሮች';

  @override
  String get drawerHelpSupport => 'እገዛ እና ድጋፍ';

  @override
  String get drawerLogout => 'ውጣ';

  @override
  String get onbTitle1 => 'የመኪናዎን ጤና ይወቁ';

  @override
  String get onbBody1 =>
      'የተሽከርካሪ ዝርዝሮች፣ የጥገና ሁኔታ እና የሚመጡ አገልግሎቶችን በአንድ ቦታ ይከታተሉ።';

  @override
  String get onbTitle2 => 'ጥገናን አይተውትም';

  @override
  String get onbBody2 => 'ለዘይት ለውጥ፣ የጎማ ምርመራ እና አገልግሎቶች በወቅቱ አስታዋሾች ያግኙ።';

  @override
  String get onbTitle3 => 'እገዛ ሲፈልጉ ያግኙ';

  @override
  String get onbBody3 =>
      'በአቅራቢያ ያሉ ጋራጆችን ያግኙ፣ አገልግሎቶችን ይያዙ ወይም በማንኛውም ጊዜ እገዛ ይጠይቁ።';

  @override
  String get onbTitle4 => 'የኤአይ የመኪና ረዳት ይጠይቁ';

  @override
  String get onbBody4 =>
      'ለፈጣን እገዛ፣ የጥገና ምክሮች እና ስለ ተሽከርካሪዎ መልስ ከኤአይ ረዳት ጋር ይወያዩ።';

  @override
  String get onbTitle5 => 'ይማሩ። ያጋሩ። በተሻለ ይነዱ።';

  @override
  String get onbBody5 =>
      'የመኪና እንክብካብ መመሪያዎችን ያስሱ እና ልምድ ለመጋራት ከሌሎች አሽከርካሪዎች ጋር ይገናኙ።';

  @override
  String get onbTitle6 => 'በተሻለ ለመነዳት ዝግጁ ነዎት?';

  @override
  String get onbBody6 =>
      'ተሽከርካሪያቸውን በጥሩ ሁኔታ ለመጠበቅ የእኛን እምነት ያደርጋሉ በሺዎች የሚቆጠሩ አሽከርካሪዎች ይቀላቀሉ።';

  @override
  String get onbSkip => 'ዝለል';

  @override
  String get onbGetStarted => 'ጀምር';

  @override
  String get profileTitle => 'መገለጫ';

  @override
  String get profileUpdated => 'መገለጫ ተዘምኗል';

  @override
  String get profileFirstName => 'የመጀመሪያ ስም';

  @override
  String get profileLastName => 'የአባት ስም';

  @override
  String get profileEmail => 'ኢሜይል';

  @override
  String get profilePleaseSignIn => 'እባክዎ ይግቡ።';

  @override
  String get commCreatePost => 'ልጥፍ ፍጠር';

  @override
  String get commReportPost => 'ልጥፍ ሪፖርት';

  @override
  String get commReportSpam => 'ስፓም';

  @override
  String get commReportHarassment => 'ማሳደድ';

  @override
  String get commReportHate => 'የጥላቻ ንግግር';

  @override
  String get commReportFalseInfo => 'ሀሰተኛ መረጃ';

  @override
  String get commReportViolence => 'አመጽ';

  @override
  String get commReportNudity => 'ዕራፍ ወይም የግብረሰው ምስል';

  @override
  String get commReportScam => 'ማጭበርበር';

  @override
  String get commReportOther => 'ሌላ';

  @override
  String get eduClear => 'አጽዳ';

  @override
  String get eduViewAll => 'ሁሉንም አሳይ';

  @override
  String get eduRetry => 'እንደገና ሞክር';

  @override
  String get eduGetManual => 'መመሪያ አምጣ';

  @override
  String get eduInvalidPdf => 'የማይሰራ የፒዲኤፍ አገናኝ።';

  @override
  String get eduCouldNotOpenManual => 'ይህን መመሪያ መክፈት አልተቻለም።';

  @override
  String get notifMarkAllRead => 'ሁሉንም እንደተነበበ ምልክት አድርግ';

  @override
  String get vehScheduleMaintenance => 'ጥገና ያስቀምጡ';

  @override
  String get maintSetReminder => 'የጥገና አስታዋሽ ያስቀምጡ';

  @override
  String get maintDone => 'ተጠናቋል';

  @override
  String get maintDelete => 'ሰርዝ';

  @override
  String get logMaintNoVehicle => 'ተሽከርካሪ የለም';

  @override
  String get bookWizardGarageError => 'የጋራጅ ተገኝነት መጫን አልተቻለም';

  @override
  String get bookWizardAddVehicle => 'ተሽከርካሪ ጨምር';

  @override
  String get bookWizardSlotUnavailable => 'የተመረጠው ጊዜ የለም። የሚገኝ ቦታ ይምረጡ።';

  @override
  String get bookWizardBackHome => 'ወደ መነሻ ተመለስ';

  @override
  String get bookWizardViewAppointments => 'ሁሉንም ቀጠሮዎች አሳይ';

  @override
  String get svcApptUpdated => 'ቀጠሮ ተዘምኗል።';

  @override
  String get svcRetry => 'እንደገና ሞክር';

  @override
  String get svcRateGarage => 'ጋራጅ ደረጃ ስጥ';

  @override
  String get svcReschedule => 'እንደገና ያስቀምጡ';

  @override
  String get svcCancel => 'ተወው';

  @override
  String get svcRateExperienceTitle => 'የአገልግሎት ልምድዎ እንዴት ነበር?';

  @override
  String get svcRatingThanks => 'እናመሰግናለን! ደረጃዎ ተልኳል።';

  @override
  String get svcCancelApptTitle => 'ቀጠሮ ይሰረዝ?';

  @override
  String get svcCancelApptBody => 'ይህ እርምጃ ሊቀለበስ አይችልም።';

  @override
  String get svcBook => 'ያስይዙ';

  @override
  String get svcCall => 'ደውል';

  @override
  String get svcRoute => 'መንገድ';

  @override
  String get svcNoPhone => 'ለዚህ ጋራጅ ስልክ ቁጥር የለም።';

  @override
  String get svcCallNotSupported => 'በዚህ መሳሪያ ላይ ጥሪ አይደገፍም።';

  @override
  String get apptCancelTitle => 'ቀጠሮ ይሰረዝ?';

  @override
  String get apptCancelBody => 'ይህ እርምጃ ሊቀለበስ አይችልም።';

  @override
  String get mapLocationRequired => 'በአቅራቢያ ቦታዎችን ለመጫን ቦታ ያስፈልጋል';

  @override
  String get mapRoutingLocationRequired => 'ለመንገድ አቅጣጫ የአሁኑ ቦታ ያስፈልጋል';

  @override
  String get mapRouteUpdated => 'መንገዱ ወደ የተጫነው ቦታ ተዘምኗል';

  @override
  String get mapSetAsStart => 'እንደ መነሻ አስቀምጥ';

  @override
  String get mapApptBooked => 'ቀጠሮ በተሳካ ሁኔታ ተያዘ';

  @override
  String get mapGettingLocation => 'ቦታዎን በመጫን ላይ...';

  @override
  String get mapBookAppointment => 'ቀጠሮ ያስይዙ';

  @override
  String get mapRequestOnsite => 'በቦታ ላይ አገልግሎት ይጠይቁ';

  @override
  String get mapOnsiteLocationBody =>
      'በቦታ ላይ አገልግሎት ለመስጠት ቦታዎን ለጋራጅ እንድንልክ የቦታ መዳረሻን ያብሩ።';

  @override
  String get mapGarageDetailsTitle => 'የጋራጅ ዝርዝሮች';

  @override
  String get mapCloseTooltip => 'ዝጋ';

  @override
  String get vehDetailRemoved => 'ተሽከርካሪ ተወግዷል።';

  @override
  String get vehDetailAskAi => 'የኤአይ ረዳት ይጠይቁ';

  @override
  String get vehDetailEditVehicle => 'ተሽከርካሪ አርትዖት';

  @override
  String get vehDetailRemoveVehicle => 'ተሽከርካሪ አስወግድ';

  @override
  String get vehDetailRemoveTitle => 'ተሽከርካሪ ይወገድ?';

  @override
  String get vehDetailInsurance => 'ኢንሹራንስ';

  @override
  String get vehDetailRegistration => 'መዝገብ';

  @override
  String get vehDetailViewDocuments => 'ሰነዶችን አሳይ';

  @override
  String get vehDetailInsuranceDoc => 'የኢንሹራንስ ሰነድ';

  @override
  String get vehDetailRegistrationDoc => 'የመዝገብ ሰነድ';

  @override
  String get vehDetailTitle => 'የተሽከርካሪ ዝርዝሮች';

  @override
  String vehDetailRemoveConfirmBody(String name) {
    return '$name ይወገዳል። ይህ እርምጃ ሊቀለበስ አይችልም።';
  }

  @override
  String get vehDetailHealthUnavailable => 'አጠቃላይ ጤና ማግኘት አልተቻለም';

  @override
  String get vehDetailHealthRetryHint => 'ለማደስ ይጎትቱ ወይም እንደገና ይሞክሩ።';

  @override
  String get vehDetailDocumentsSection => 'ሰነዶች';

  @override
  String get vehDetailVehicleInformation => 'የተሽከርካሪ መረጃ';

  @override
  String get vehDetailMakeModel => 'አምራች እና ሞዴል';

  @override
  String get vehDetailYear => 'ዓመት';

  @override
  String get vehDetailVin => 'VIN';

  @override
  String get vehDetailMileage => 'ኪሎ ሜትር';

  @override
  String get vehDetailFuelType => 'የነዳጅ አይነት';

  @override
  String vehDetailInsuranceActiveExpires(String date) {
    return 'ንቁ - ይጠፋል $date';
  }

  @override
  String vehDetailRegistrationValidExpires(String date) {
    return 'ትክክለኛ - ይጠፋል $date';
  }

  @override
  String get vehDetailNoDocumentsAvailable => 'ምንም ሰነድ የለም።';

  @override
  String get commonMilesUnit => 'ማይል';

  @override
  String get addVehSuccessAdded => 'ተሽከርካሪ በተሳካ ሁኔታ ተጨመረ።';

  @override
  String get addVehSuccessUpdated => 'ተሽከርካሪ ተዘምኗል።';

  @override
  String addVehFileSelected(String name) {
    return 'ተመርጧል፦ $name';
  }

  @override
  String addVehFilePickerError(String error) {
    return 'ፋይል መራጭ መክፈት አልተቻለም፦ $error';
  }

  @override
  String get addVehFillRequired => 'አምራች፣ ሞዴል እና የሰሌዳ ቁጥር ይሙሉ።';

  @override
  String get addVehSaveChanges => 'ለውጦችን አስቀምጥ';

  @override
  String get addVehSelectFile => 'ፋይል ይምረጡ';

  @override
  String get addVehVehicleSummary => 'የተሽከርካሪ ማጠቃለያ';

  @override
  String get addVehAddVehicle => 'ተሽከርካሪ ጨምር';

  @override
  String get addVehEditDetails => 'ዝርዝሮችን አርትዖት';

  @override
  String get addVehReadyConfirmBanner =>
      'ይህን ተሽከርካሪ በጋራጅዎ ለመጨመር ዝግጁ ነው። ዝርዝሮችን በማንኛውም ጊዜ ማርትዕ ይችላሉ።';

  @override
  String get postImagesTooLarge => 'የተመረጡ ምስሎች በጣም ትልቅ ነበሩ።';

  @override
  String get postImagesExceedServer => 'ምስሎች የሰርቨር ገደብን ያልፋሉ።';

  @override
  String get postImagesSomeSkipped => 'የሰርቨር መጫን ለማሳካት አንዳንድ ምስሎች ተዘለሉ።';

  @override
  String get postImagesRemoveSome =>
      'ምስሎች ትልቅ ናቸው። አንዳንዶችን ያስወግዱ እና እንደገና ይሞክሩ።';

  @override
  String get postAddPhotos => 'ፎቶዎች ጨምር';

  @override
  String get aiAssistantTitle => 'የኤአይ ረዳት';

  @override
  String get aiChatHistoryTitle => 'የውይይት ታሪክ';

  @override
  String get aiStartNewChat => 'አዲስ ውይይት ጀምር';

  @override
  String get aiDeleteSessionTitle => 'የውይይት ክፍለ ጊዜ ይሰረዝ?';

  @override
  String get aiDeleteSessionBody => 'ውይይቱ ከታሪክ ይወገዳል። ይህ እርምጃ ሊቀለበስ አይችልም።';

  @override
  String get timeJustNow => 'አሁን';

  @override
  String timeMinAgo(int count) {
    return 'ከ$count ደቂቃ በፊት';
  }

  @override
  String timeHrAgo(int count) {
    return 'ከ$count ሰዓት በፊት';
  }

  @override
  String timeDaysAgo(int count) {
    return 'ከ$count ቀን በፊት';
  }

  @override
  String get routerPageNotFound => 'ስህተት፦ ገጽ አልተገኘም';

  @override
  String mapRouteNumbered(int routeNumber) {
    return 'መንገድ $routeNumber';
  }

  @override
  String get scheduleMaintRetry => 'እንደገና ሞክር';

  @override
  String get scheduleMaintAdd => 'ጨምር';

  @override
  String get profileSubtitle => 'ስምዎን እና ኢሜይልዎን ያዘምኑ። ለውጦች በመሳቢያው ይታያሉ።';

  @override
  String get profileHintFirstName => 'የመጀመሪያ ስም';

  @override
  String get profileHintLastName => 'የአባት ስም';

  @override
  String get profileHintEmail => 'ኢሜይል';

  @override
  String get profileSaveChanges => 'ለውጦችን አስቀምጥ';

  @override
  String get commNoPostsFound => 'ልጥፎች አልተገኙም።';

  @override
  String get commReportDetailsHint => 'ምን እንደተሳሳተ ይንገሩን';

  @override
  String get commCommunityTitle => 'ማህበረሰብ';

  @override
  String get commCommunitySubtitle => 'ከመኪና ባለቤቶች ጋር ይገናኙ';

  @override
  String timeWeeksAgo(int count) {
    return 'ከ$count ሳምንት በፊት';
  }

  @override
  String get commComments => 'አስተያየቶች';

  @override
  String get commNoComments => 'አስተያየት የለም።';

  @override
  String get commWriteComment => 'አስተያየት ይጻፉ';

  @override
  String get commActionsTooltip => 'ድርጊቶች';

  @override
  String get commShowMore => 'ተጨማሪ አሳይ';

  @override
  String get commShowLess => 'ያነሰ አሳይ';

  @override
  String get commSearchHint => 'ልጥፎችን ፈልግ...';

  @override
  String get commInvalidImage => 'የማይሰራ ምስል';

  @override
  String get commCannotLoadImage => 'ምስል መጫን አልተቻለም';

  @override
  String get commInvalidImageUrl => 'የማይሰራ የምስል አድራሻ';

  @override
  String get tabAll => 'ሁሉም';

  @override
  String get tabMyPosts => 'የእኔ ልጥፎች';

  @override
  String get tabBookmarks => 'ምልክቶች';

  @override
  String get navHome => 'መነሻ';

  @override
  String get navVehicle => 'ተሽከርካሪ';

  @override
  String get navService => 'አገልግሎት';

  @override
  String get navCommunity => 'ማህበረሰብ';

  @override
  String get navEducation => 'ትምህርት';

  @override
  String get notifTitle => 'ማስታወሻዎች';

  @override
  String get notifSubtitle => 'የጥገና አስታዋሾች እና የመተግበሪያ ዝመናዎች';

  @override
  String get commonGarage => 'ጋራጅ';

  @override
  String apptGarageLine(String name) {
    return 'ጋራጅ፦ $name';
  }

  @override
  String apptCarLine(String name) {
    return 'መኪና፦ $name';
  }

  @override
  String get apptServiceDefault => 'አገልግሎት';

  @override
  String get navVehicles => 'ተሽከርካሪዎች';

  @override
  String get navEduShort => 'ትም.';

  @override
  String get dashNoVehicle => 'ተሽከርካሪ የለም';

  @override
  String get dashAddVehiclePlateHint => 'ተሽከርካሪ ጨምር';

  @override
  String get dashSelectVehicleForHealth => 'የመኪና ጤና ለመጫን ተሽከርካሪ ይምረጡ ወይም ያክሉ።';

  @override
  String get dashCouldNotLoadVehicleHealth => 'የተሽከርካሪ ጤና መጫን አልተቻለም።';

  @override
  String get dashVehicleHealthTitle => 'የተሽከርካሪ ጤና';

  @override
  String get dashOverallCarHealthTitle => 'አጠቃላይ የመኪና ጤና';

  @override
  String get dashHealthScoresFallback =>
      'ውጤቶች ከዚህ ተሽከርካሪ የጥገና እንቅስቃሴ እና የጋራጅ ውሂብ ይመነጫሉ።';

  @override
  String get dashNoSubsystemData => 'እስካሁን የ ንዑስ ስርዓት ውሂብ የለም።';

  @override
  String get dashMaintenanceRemindersTitle => 'የጥገና አስታዋሾች';

  @override
  String get dashViewAll => 'ሁሉንም አሳይ';

  @override
  String get dashNoRemindersYet => 'እስካሁን አስታዋሽ የለም። ጥገና ያስቀምጡ።';

  @override
  String dashOverdueByDays(int days) {
    return 'በ$days ቀን ተዘግይቷል';
  }

  @override
  String get dashDueToday => 'ዛሬ ይጠበቃል';

  @override
  String get dashDueTomorrow => 'ነገ ይጠበቃል';

  @override
  String dashDueInDays(int days) {
    return 'በ$days ቀን ይጠበቃል';
  }

  @override
  String dashDueInWeeks(int weeks) {
    return 'በ$weeks ሳምንት ይጠበቃል';
  }

  @override
  String get dashStatusUrgent => 'አስቸኳይ';

  @override
  String get dashStatusSoon => 'በቅርቡ';

  @override
  String get dashStatusGood => 'ጥሩ';

  @override
  String get dashStatusDone => 'ተጠናቋል';

  @override
  String dashPlateLine(String plate) {
    return 'ሰሌዳ $plate';
  }

  @override
  String get dashQuickActionsTitle => 'ፈጣን ድርጊቶች';

  @override
  String get dashBookService => 'አገልግሎት ያስይዙ';

  @override
  String get dashFindNearbyGarage => 'በአቅራቢያ ጋራጅ ያግኙ';

  @override
  String get dashChatAiAssistant => 'ከኤአይ ረዳት ይወያዩ';

  @override
  String get dashMaintenanceHistory => 'የጥገና ታሪክ';

  @override
  String get dashRecentActivityTitle => 'የቅርብ እንቅስቃሴ';

  @override
  String get dashNoRecentActivity => 'እስካሁን እንቅስቃሴ የለም።';

  @override
  String dashActivityCompleted(String title) {
    return '$title ተጠናቋል';
  }

  @override
  String dashVehicleAdded(String name) {
    return 'ተሽከርካሪ ተጨመረ፦ $name';
  }

  @override
  String timeMonthsAgo(int count) {
    return 'ከ$count ወር በፊት';
  }

  @override
  String get vehListTitleMyVehicles => 'የእኔ ተሽከርካሪዎች';

  @override
  String get vehListTitleUpcoming => 'የሚመጣ ጥገና';

  @override
  String get vehListTitleHistory => 'የጥገና ታሪክ';

  @override
  String get vehListSubtitleMyVehicles => 'ተሽከርካሪዎችዎን እና ጥገና ያቀናብሩ';

  @override
  String get vehListSubtitleUpcoming => 'የታቀዱ እና የሚመከሩ አገልግሎቶች';

  @override
  String get vehListSubtitleHistory => 'የታቀዱ አስታዋሾች እና የተጠናቀቁ አገልግሎቶች';

  @override
  String get vehSegmentMyVehicles => 'የእኔ ተሽከርካሪዎች';

  @override
  String get vehSegmentUpcoming => 'የሚመጣ';

  @override
  String get vehSegmentHistory => 'ታሪክ';

  @override
  String get vehRetry => 'እንደገና ሞክር';

  @override
  String get vehFabAddNewVehicle => 'አዲስ ተሽከርካሪ ጨምር';

  @override
  String get vehFabRegisterAnother => 'ሌላ መኪና ይመዝገቡ';

  @override
  String get vehHistoryEmpty =>
      'እስካሁን ምንም የለም።\n\nየታቀዱ አስታዋሾች እና የተጠናቀቁ አገልግሎቶች እዚህ ከሁኔታ (ጥሩ፣ በቅርቡ፣ ተዘግይቷል፣ ተጠናቋል) ጋር ይታያሉ። ጥገና ለማስቀመጥ ወይም እንደተጠናቀቀ ለማመልከት የሚመጣን ይጠቀሙ።';

  @override
  String get vehCardStatusGood => 'ጥሩ';

  @override
  String get vehCardStatusAttention => 'ትኩረት';

  @override
  String get eduAllArticlesTitle => 'ሁሉም መጣጥፎች';

  @override
  String eduArticlesInCategory(String category) {
    return '$category መጣጥፎች';
  }

  @override
  String get eduNoArticlesInCategory => 'በዚህ ምድብ መጣጥፎች የሉም።';

  @override
  String get eduArticleLabel => 'መጣጥፍ';

  @override
  String eduCategoryGuide(String category) {
    return '$category መመሪያ';
  }

  @override
  String get eduCouldNotLoadArticle => 'ይህን መጣጥፍ መጫን አልተቻለም።';

  @override
  String eduReadMinutes(int minutes) {
    return '$minutes ደቂቃ';
  }

  @override
  String get eduCenterTitle => 'የትምህርት ማዕከል';

  @override
  String get eduCenterSubtitle => 'ተሽከርካሪዎን እንዴት እንደሚጠብቁ ይማሩ';

  @override
  String get eduSearchHint => 'መመሪያዎችን እና መጣጥፎችን ይፈልጉ...';

  @override
  String eduResultsFor(String query) {
    return 'ውጤቶች ለ \"$query\"';
  }

  @override
  String get eduFeaturedArticles => 'የተመረጡ መጣጥፎች';

  @override
  String get eduNoArticlesMatchSearch => 'ለፍለጋዎ የሚስማሙ መጣጥፎች የሉም።';

  @override
  String get eduNoArticlesYet => 'እስካሁን መጣጥፎች የሉም። በቅርቡ ይመለሱ።';

  @override
  String eduCategoryArticleCount(int count) {
    return '$count መጣጥፎች';
  }

  @override
  String get eduCatRepairs => 'ጥገና';

  @override
  String get eduCatSafety => 'ደህንነት';

  @override
  String get eduCatMaintenance => 'ጥገና አስተዳደር';

  @override
  String get eduCatTips => 'ምክሮች';

  @override
  String get eduCatManuals => 'መመሪያዎች';

  @override
  String get eduReadMore => 'አንብብ ›';

  @override
  String get eduDifficultyBeginner => 'ጀማሪ';

  @override
  String get eduDifficultyIntermediate => 'መካከለኛ';

  @override
  String get eduTopicSafety => 'የደህንነት ምክሮች';

  @override
  String get eduTopicMaintenance => 'የጥገና መሰረታዊ እውቀት';

  @override
  String get eduTopicRepairs => 'የጥገና መመሪያዎች';

  @override
  String get eduTopicTips => 'ምክሮች እና ዘዴዎች';

  @override
  String get eduTopicAll => 'መመሪያ';

  @override
  String get eduTopicManuals => 'መመሪያ መጽሐፍ';

  @override
  String get svcLocServicesDisabled =>
      'የቦታ አገልግሎቶች ተሰናክለዋል። በአቅራቢያ ጋራጆችን ለማየት ያብሩ።';

  @override
  String get svcLocPermissionDeniedForever =>
      'የቦታ ፍቃድ ለዘለዓለም ተከልክሏል። ከመተግበሪያ ቅንብሮች ይፍቀዱ።';

  @override
  String get svcLocPermissionDenied =>
      'የቦታ ፍቃድ ተከልክሏል። በአቅራቢያ ጋራጆችን ለማግኘት ፍቃድ ይፍቀዱ።';

  @override
  String get svcLocFetchFailed => 'ቦታዎን ማምጣት አልተቻለም። የተለዋዋጭ ውጤቶች ይታያሉ።';

  @override
  String get svcServiceCentersTitle => 'የአገልግሎት ማዕከሎች';

  @override
  String get svcServiceCentersSubtitle => 'በአቅራቢያ ጋራጆች ያግኙ እና አገልግሎት ያስይዙ';

  @override
  String get svcUpcomingAppointments => 'የሚመጡ ቀጠሮዎች';

  @override
  String get svcNoUpcomingAppointments => 'የሚመጡ ቀጠሮዎች የሉም';

  @override
  String get svcNearbyCentersTitle => 'በአቅራቢያ የአገልግሎት ማዕከሎች';

  @override
  String get svcNoNearbyGarages => 'በአቅራቢያ ጋራጅ አልተገኘም።';

  @override
  String get svcOpen => 'ክፍት';

  @override
  String get svcBookAhead => 'ቀደም ብለው ይያዙ';

  @override
  String get svcClosed => 'ዝግ';

  @override
  String get svcOnsiteAvailable => 'በቦታ ላይ አገልግሎት ይገኛል';

  @override
  String get svcViewReviews => 'ግምገማዎችን አሳይ';

  @override
  String get svcReviewsRatingTitle => 'ግምገማ እና ደረጃ';

  @override
  String svcReviewCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ግምገማዎች',
      one: '1 ግምገማ',
    );
    return '$_temp0';
  }

  @override
  String get svcReviewsLoadError => 'ግምገማዎችን አሁን መጫን አልተቻለም።';

  @override
  String get svcReviewsEmpty => 'ለዚህ ጋራጅ እስካሁን ግምገማ የለም።';

  @override
  String get svcReviewNoComment => 'አስተያየት የለም';

  @override
  String get svcReviewAnonymousDriver => 'አሽከርካሪ';

  @override
  String get svcUnknownDate => 'ያልታወቀ ቀን';

  @override
  String get svcMapView => 'የካርታ እይታ';

  @override
  String get svcApptsPageTitle => 'ቀጠሮዎች';

  @override
  String get svcApptsListTitle => 'ቀጠሮዎች';

  @override
  String get svcApptsListSubtitle => 'የእርስዎን ቦታያዘት ይመልከቱ እና ያቀናብሩ';

  @override
  String get svcNoAppointmentsFound => 'ቀጠሮ አልተገኘም';

  @override
  String get svcNoAppointmentsYet => 'እስካሁን ቀጠሮ የለም';

  @override
  String get svcUnableSubmitRating => 'ደረጃ ማስረከብ አልተቻለም';

  @override
  String get svcUnableLoadGarages => 'በአቅራቢያ ጋራጆችን መጫን አልተቻለም።';

  @override
  String get svcRateTapStar => 'ለመደረጃ ኮከብ ይንኩ';

  @override
  String svcRateStarsSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ኮከቦች ተመርጠዋል',
      one: '1 ኮከብ ተመርጧል',
    );
    return '$_temp0';
  }

  @override
  String get svcRateFeedbackHint => 'አማራጭ አስተያየት ይጻፉ';

  @override
  String get apptStatusPending => 'በመጠባበቅ ላይ';

  @override
  String get apptStatusConfirmed => 'ተረጋግጧል';

  @override
  String get apptStatusRejected => 'ተቀባይነት አላገኘም';

  @override
  String get apptStatusInService => 'በአገልግሎት ውስጥ';

  @override
  String get apptStatusCompleted => 'ተጠናቋል';

  @override
  String get apptStatusCancelled => 'ተሰርዟል';
}
