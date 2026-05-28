import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('am'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Driver Assistance'**
  String get appTitle;

  /// No description provided for @loginPhoneInvalidSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone: 09…, 251…, or +251… (9-digit mobile).'**
  String get loginPhoneInvalidSnackbar;

  /// No description provided for @loginWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginWelcomeTitle;

  /// No description provided for @loginWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue to your account'**
  String get loginWelcomeSubtitle;

  /// No description provided for @loginPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get loginPhoneLabel;

  /// No description provided for @loginPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'09…, 251…, or +251…'**
  String get loginPhoneHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordHint;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginButton;

  /// No description provided for @loginNoAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get loginNoAccountPrompt;

  /// No description provided for @loginCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get loginCreateAccount;

  /// No description provided for @signupEnterValidPhoneOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone before requesting OTP.'**
  String get signupEnterValidPhoneOtp;

  /// No description provided for @signupPhoneVerifiedAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Phone number verified automatically.'**
  String get signupPhoneVerifiedAutomatic;

  /// No description provided for @signupFailedSendOtp.
  ///
  /// In en, this message translates to:
  /// **'Failed to send OTP.'**
  String get signupFailedSendOtp;

  /// No description provided for @signupOtpSentCheckSms.
  ///
  /// In en, this message translates to:
  /// **'OTP sent. Check your SMS.'**
  String get signupOtpSentCheckSms;

  /// No description provided for @signupOtpSetupFailed.
  ///
  /// In en, this message translates to:
  /// **'OTP setup failed: {error}'**
  String signupOtpSetupFailed(String error);

  /// No description provided for @signupRequestOtpFirst.
  ///
  /// In en, this message translates to:
  /// **'Request OTP first.'**
  String get signupRequestOtpFirst;

  /// No description provided for @signupEnterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number.'**
  String get signupEnterValidPhone;

  /// No description provided for @signupEnterSixDigitOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit OTP code.'**
  String get signupEnterSixDigitOtp;

  /// No description provided for @signupPasswordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get signupPasswordsMismatch;

  /// No description provided for @signupPasswordMin8.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get signupPasswordMin8;

  /// No description provided for @signupPhoneInvalidSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone: 09…, 251…, or +251… (9-digit mobile).'**
  String get signupPhoneInvalidSnackbar;

  /// No description provided for @signupVerifyPhoneBeforeSignup.
  ///
  /// In en, this message translates to:
  /// **'Verify your phone with OTP before signup.'**
  String get signupVerifyPhoneBeforeSignup;

  /// No description provided for @signupFirebaseTokenMissing.
  ///
  /// In en, this message translates to:
  /// **'Phone verified, but Firebase token is missing. Verify OTP again.'**
  String get signupFirebaseTokenMissing;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signupTitle;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started with CarCare'**
  String get signupSubtitle;

  /// No description provided for @signupFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get signupFirstName;

  /// No description provided for @signupLastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get signupLastName;

  /// No description provided for @signupHintFirstName.
  ///
  /// In en, this message translates to:
  /// **'John'**
  String get signupHintFirstName;

  /// No description provided for @signupHintLastName.
  ///
  /// In en, this message translates to:
  /// **'Doe'**
  String get signupHintLastName;

  /// No description provided for @signupEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get signupEmail;

  /// No description provided for @signupEmailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get signupEmailHint;

  /// No description provided for @signupPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get signupPhoneLabel;

  /// No description provided for @signupPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'09…, 251…, or +251…'**
  String get signupPhoneHint;

  /// No description provided for @signupSendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get signupSendOtp;

  /// No description provided for @signupResendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get signupResendOtp;

  /// No description provided for @signupOtpCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'OTP Code'**
  String get signupOtpCodeLabel;

  /// No description provided for @signupOtpHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit code'**
  String get signupOtpHint;

  /// No description provided for @signupVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get signupVerify;

  /// No description provided for @signupVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get signupVerified;

  /// No description provided for @signupPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signupPasswordLabel;

  /// No description provided for @signupPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get signupPasswordHint;

  /// No description provided for @signupConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get signupConfirmPasswordLabel;

  /// No description provided for @signupConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get signupConfirmPasswordHint;

  /// No description provided for @signupCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signupCreateButton;

  /// No description provided for @signupOtpVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP verified successfully.'**
  String get signupOtpVerifiedSuccess;

  /// No description provided for @signupInvalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP code.'**
  String get signupInvalidOtp;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageSection;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageAmharic.
  ///
  /// In en, this message translates to:
  /// **'አማርኛ (Amharic)'**
  String get settingsLanguageAmharic;

  /// No description provided for @authLanguageChipEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get authLanguageChipEnglish;

  /// No description provided for @authLanguageChipAmharic.
  ///
  /// In en, this message translates to:
  /// **'አማርኛ'**
  String get authLanguageChipAmharic;

  /// No description provided for @settingsChangePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get settingsChangePasswordTitle;

  /// No description provided for @settingsChangePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use your current password to set a new one.'**
  String get settingsChangePasswordSubtitle;

  /// No description provided for @settingsCurrentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get settingsCurrentPasswordLabel;

  /// No description provided for @settingsNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get settingsNewPasswordLabel;

  /// No description provided for @settingsConfirmNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get settingsConfirmNewPasswordLabel;

  /// No description provided for @settingsPasswordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get settingsPasswordChanged;

  /// No description provided for @settingsRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Request failed'**
  String get settingsRequestFailed;

  /// No description provided for @settingsUnableChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Unable to change password right now.'**
  String get settingsUnableChangePassword;

  /// No description provided for @settingsValidatorCurrentRequired.
  ///
  /// In en, this message translates to:
  /// **'Current password is required'**
  String get settingsValidatorCurrentRequired;

  /// No description provided for @settingsValidatorNewRequired.
  ///
  /// In en, this message translates to:
  /// **'New password is required'**
  String get settingsValidatorNewRequired;

  /// No description provided for @settingsValidatorNewMin6.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get settingsValidatorNewMin6;

  /// No description provided for @settingsValidatorNewDifferent.
  ///
  /// In en, this message translates to:
  /// **'New password must be different'**
  String get settingsValidatorNewDifferent;

  /// No description provided for @settingsValidatorConfirmRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your new password'**
  String get settingsValidatorConfirmRequired;

  /// No description provided for @settingsValidatorPasswordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get settingsValidatorPasswordsMismatch;

  /// No description provided for @settingsUpdatePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get settingsUpdatePasswordButton;

  /// No description provided for @brandCarCare.
  ///
  /// In en, this message translates to:
  /// **'CarCare'**
  String get brandCarCare;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get commonSubmit;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get commonReport;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonClear;

  /// No description provided for @commonViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get commonViewAll;

  /// No description provided for @commonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// No description provided for @commonBook.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get commonBook;

  /// No description provided for @commonCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get commonCall;

  /// No description provided for @commonRoute.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get commonRoute;

  /// No description provided for @commonNavigate.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get commonNavigate;

  /// No description provided for @commonGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get commonGuest;

  /// No description provided for @commonEmDash.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get commonEmDash;

  /// No description provided for @drawerNavSection.
  ///
  /// In en, this message translates to:
  /// **'NAVIGATION'**
  String get drawerNavSection;

  /// No description provided for @drawerAccountSection.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get drawerAccountSection;

  /// No description provided for @drawerHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get drawerHome;

  /// No description provided for @drawerMyVehicles.
  ///
  /// In en, this message translates to:
  /// **'My Vehicles'**
  String get drawerMyVehicles;

  /// No description provided for @drawerService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get drawerService;

  /// No description provided for @drawerCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get drawerCommunity;

  /// No description provided for @drawerEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get drawerEducation;

  /// No description provided for @drawerProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get drawerProfile;

  /// No description provided for @drawerSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawerSettings;

  /// No description provided for @drawerHelpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get drawerHelpSupport;

  /// No description provided for @drawerLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get drawerLogout;

  /// No description provided for @onbTitle1.
  ///
  /// In en, this message translates to:
  /// **'Know Your Car\'s Health'**
  String get onbTitle1;

  /// No description provided for @onbBody1.
  ///
  /// In en, this message translates to:
  /// **'Track your vehicle details, maintenance status, and upcoming services all in one place — no more guesswork.'**
  String get onbBody1;

  /// No description provided for @onbTitle2.
  ///
  /// In en, this message translates to:
  /// **'Never Miss Maintenance'**
  String get onbTitle2;

  /// No description provided for @onbBody2.
  ///
  /// In en, this message translates to:
  /// **'Get timely reminders for oil changes, tire checks, and services so your car stays reliable and safe.'**
  String get onbBody2;

  /// No description provided for @onbTitle3.
  ///
  /// In en, this message translates to:
  /// **'Find Help When You Need It'**
  String get onbTitle3;

  /// No description provided for @onbBody3.
  ///
  /// In en, this message translates to:
  /// **'Locate nearby garages, book services, or request onsite assistance anytime, anywhere.'**
  String get onbBody3;

  /// No description provided for @onbTitle4.
  ///
  /// In en, this message translates to:
  /// **'Ask Your AI Car Assistant'**
  String get onbTitle4;

  /// No description provided for @onbBody4.
  ///
  /// In en, this message translates to:
  /// **'Chat with an AI assistant for instant help, maintenance tips, and answers about your vehicle.'**
  String get onbBody4;

  /// No description provided for @onbTitle5.
  ///
  /// In en, this message translates to:
  /// **'Learn. Share. Drive Better.'**
  String get onbTitle5;

  /// No description provided for @onbBody5.
  ///
  /// In en, this message translates to:
  /// **'Explore car care guides and connect with other drivers to share experiences and advice.'**
  String get onbBody5;

  /// No description provided for @onbTitle6.
  ///
  /// In en, this message translates to:
  /// **'Ready to Drive Smarter?'**
  String get onbTitle6;

  /// No description provided for @onbBody6.
  ///
  /// In en, this message translates to:
  /// **'Join thousands of drivers who trust us to keep their vehicles in perfect condition.'**
  String get onbBody6;

  /// No description provided for @onbSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onbSkip;

  /// No description provided for @onbGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onbGetStarted;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @profileFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get profileFirstName;

  /// No description provided for @profileLastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get profileLastName;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profilePleaseSignIn.
  ///
  /// In en, this message translates to:
  /// **'Please sign in.'**
  String get profilePleaseSignIn;

  /// No description provided for @commCreatePost.
  ///
  /// In en, this message translates to:
  /// **'Create Post'**
  String get commCreatePost;

  /// No description provided for @commReportPost.
  ///
  /// In en, this message translates to:
  /// **'Report Post'**
  String get commReportPost;

  /// No description provided for @commReportSpam.
  ///
  /// In en, this message translates to:
  /// **'Spam'**
  String get commReportSpam;

  /// No description provided for @commReportHarassment.
  ///
  /// In en, this message translates to:
  /// **'Harassment'**
  String get commReportHarassment;

  /// No description provided for @commReportHate.
  ///
  /// In en, this message translates to:
  /// **'Hate speech'**
  String get commReportHate;

  /// No description provided for @commReportFalseInfo.
  ///
  /// In en, this message translates to:
  /// **'False information'**
  String get commReportFalseInfo;

  /// No description provided for @commReportViolence.
  ///
  /// In en, this message translates to:
  /// **'Violence'**
  String get commReportViolence;

  /// No description provided for @commReportNudity.
  ///
  /// In en, this message translates to:
  /// **'Nudity or sexual content'**
  String get commReportNudity;

  /// No description provided for @commReportScam.
  ///
  /// In en, this message translates to:
  /// **'Scam or fraud'**
  String get commReportScam;

  /// No description provided for @commReportOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get commReportOther;

  /// No description provided for @eduClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get eduClear;

  /// No description provided for @eduViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get eduViewAll;

  /// No description provided for @eduRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get eduRetry;

  /// No description provided for @eduGetManual.
  ///
  /// In en, this message translates to:
  /// **'Get Manual'**
  String get eduGetManual;

  /// No description provided for @eduInvalidPdf.
  ///
  /// In en, this message translates to:
  /// **'Invalid PDF link.'**
  String get eduInvalidPdf;

  /// No description provided for @eduCouldNotOpenManual.
  ///
  /// In en, this message translates to:
  /// **'Could not open this manual.'**
  String get eduCouldNotOpenManual;

  /// No description provided for @notifMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get notifMarkAllRead;

  /// No description provided for @vehScheduleMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Schedule Maintenance'**
  String get vehScheduleMaintenance;

  /// No description provided for @maintSetReminder.
  ///
  /// In en, this message translates to:
  /// **'Set Maintenance Reminder'**
  String get maintSetReminder;

  /// No description provided for @maintDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get maintDone;

  /// No description provided for @maintDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get maintDelete;

  /// No description provided for @logMaintNoVehicle.
  ///
  /// In en, this message translates to:
  /// **'No vehicle'**
  String get logMaintNoVehicle;

  /// No description provided for @bookWizardGarageError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load garage availability'**
  String get bookWizardGarageError;

  /// No description provided for @bookWizardAddVehicle.
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle'**
  String get bookWizardAddVehicle;

  /// No description provided for @bookWizardSlotUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Selected time is not available. Please choose an available slot.'**
  String get bookWizardSlotUnavailable;

  /// No description provided for @bookWizardBackHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get bookWizardBackHome;

  /// No description provided for @bookWizardViewAppointments.
  ///
  /// In en, this message translates to:
  /// **'View All Appointments'**
  String get bookWizardViewAppointments;

  /// No description provided for @svcApptUpdated.
  ///
  /// In en, this message translates to:
  /// **'Appointment updated.'**
  String get svcApptUpdated;

  /// No description provided for @svcRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get svcRetry;

  /// No description provided for @svcRateGarage.
  ///
  /// In en, this message translates to:
  /// **'Rate Garage'**
  String get svcRateGarage;

  /// No description provided for @svcReschedule.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get svcReschedule;

  /// No description provided for @svcCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get svcCancel;

  /// No description provided for @svcRateExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'How was your service experience?'**
  String get svcRateExperienceTitle;

  /// No description provided for @svcRatingThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks! Your rating was submitted.'**
  String get svcRatingThanks;

  /// No description provided for @svcCancelApptTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel appointment?'**
  String get svcCancelApptTitle;

  /// No description provided for @svcCancelApptBody.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get svcCancelApptBody;

  /// No description provided for @svcBook.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get svcBook;

  /// No description provided for @svcCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get svcCall;

  /// No description provided for @svcRoute.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get svcRoute;

  /// No description provided for @svcNoPhone.
  ///
  /// In en, this message translates to:
  /// **'No phone number available for this garage.'**
  String get svcNoPhone;

  /// No description provided for @svcCallNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Calling is not supported on this device.'**
  String get svcCallNotSupported;

  /// No description provided for @apptCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel appointment?'**
  String get apptCancelTitle;

  /// No description provided for @apptCancelBody.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get apptCancelBody;

  /// No description provided for @mapLocationRequired.
  ///
  /// In en, this message translates to:
  /// **'Location required to load nearby places'**
  String get mapLocationRequired;

  /// No description provided for @mapRoutingLocationRequired.
  ///
  /// In en, this message translates to:
  /// **'Current location is required for routing'**
  String get mapRoutingLocationRequired;

  /// No description provided for @mapRouteUpdated.
  ///
  /// In en, this message translates to:
  /// **'Route updated to tapped location'**
  String get mapRouteUpdated;

  /// No description provided for @mapSetAsStart.
  ///
  /// In en, this message translates to:
  /// **'Set as start'**
  String get mapSetAsStart;

  /// No description provided for @mapApptBooked.
  ///
  /// In en, this message translates to:
  /// **'Appointment booked successfully'**
  String get mapApptBooked;

  /// No description provided for @mapGettingLocation.
  ///
  /// In en, this message translates to:
  /// **'Getting your location...'**
  String get mapGettingLocation;

  /// No description provided for @mapBookAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get mapBookAppointment;

  /// No description provided for @mapRequestOnsite.
  ///
  /// In en, this message translates to:
  /// **'Request On-site Service'**
  String get mapRequestOnsite;

  /// No description provided for @mapOnsiteLocationBody.
  ///
  /// In en, this message translates to:
  /// **'Turn on location access so we can send the garage your position for on-site service.'**
  String get mapOnsiteLocationBody;

  /// No description provided for @mapGarageDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Garage details'**
  String get mapGarageDetailsTitle;

  /// No description provided for @mapCloseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get mapCloseTooltip;

  /// No description provided for @vehDetailRemoved.
  ///
  /// In en, this message translates to:
  /// **'Vehicle removed.'**
  String get vehDetailRemoved;

  /// No description provided for @vehDetailAskAi.
  ///
  /// In en, this message translates to:
  /// **'Ask AI assistant'**
  String get vehDetailAskAi;

  /// No description provided for @vehDetailEditVehicle.
  ///
  /// In en, this message translates to:
  /// **'Edit Vehicle'**
  String get vehDetailEditVehicle;

  /// No description provided for @vehDetailRemoveVehicle.
  ///
  /// In en, this message translates to:
  /// **'Remove Vehicle'**
  String get vehDetailRemoveVehicle;

  /// No description provided for @vehDetailRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove vehicle?'**
  String get vehDetailRemoveTitle;

  /// No description provided for @vehDetailInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get vehDetailInsurance;

  /// No description provided for @vehDetailRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get vehDetailRegistration;

  /// No description provided for @vehDetailViewDocuments.
  ///
  /// In en, this message translates to:
  /// **'View Documents'**
  String get vehDetailViewDocuments;

  /// No description provided for @vehDetailInsuranceDoc.
  ///
  /// In en, this message translates to:
  /// **'Insurance Document'**
  String get vehDetailInsuranceDoc;

  /// No description provided for @vehDetailRegistrationDoc.
  ///
  /// In en, this message translates to:
  /// **'Registration Document'**
  String get vehDetailRegistrationDoc;

  /// No description provided for @vehDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get vehDetailTitle;

  /// No description provided for @vehDetailRemoveConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'{name} will be removed. This action cannot be undone.'**
  String vehDetailRemoveConfirmBody(String name);

  /// No description provided for @vehDetailHealthUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Overall health unavailable'**
  String get vehDetailHealthUnavailable;

  /// No description provided for @vehDetailHealthRetryHint.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh or try again.'**
  String get vehDetailHealthRetryHint;

  /// No description provided for @vehDetailDocumentsSection.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get vehDetailDocumentsSection;

  /// No description provided for @vehDetailVehicleInformation.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Information'**
  String get vehDetailVehicleInformation;

  /// No description provided for @vehDetailMakeModel.
  ///
  /// In en, this message translates to:
  /// **'Make & Model'**
  String get vehDetailMakeModel;

  /// No description provided for @vehDetailYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get vehDetailYear;

  /// No description provided for @vehDetailVin.
  ///
  /// In en, this message translates to:
  /// **'VIN'**
  String get vehDetailVin;

  /// No description provided for @vehDetailMileage.
  ///
  /// In en, this message translates to:
  /// **'Mileage'**
  String get vehDetailMileage;

  /// No description provided for @vehDetailFuelType.
  ///
  /// In en, this message translates to:
  /// **'Fuel Type'**
  String get vehDetailFuelType;

  /// No description provided for @vehDetailInsuranceActiveExpires.
  ///
  /// In en, this message translates to:
  /// **'Active - Expires {date}'**
  String vehDetailInsuranceActiveExpires(String date);

  /// No description provided for @vehDetailRegistrationValidExpires.
  ///
  /// In en, this message translates to:
  /// **'Valid - Expires {date}'**
  String vehDetailRegistrationValidExpires(String date);

  /// No description provided for @vehDetailNoDocumentsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No documents available.'**
  String get vehDetailNoDocumentsAvailable;

  /// No description provided for @commonMilesUnit.
  ///
  /// In en, this message translates to:
  /// **'miles'**
  String get commonMilesUnit;

  /// No description provided for @addVehSuccessAdded.
  ///
  /// In en, this message translates to:
  /// **'Vehicle added successfully.'**
  String get addVehSuccessAdded;

  /// No description provided for @addVehSuccessUpdated.
  ///
  /// In en, this message translates to:
  /// **'Vehicle updated.'**
  String get addVehSuccessUpdated;

  /// No description provided for @addVehFileSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected: {name}'**
  String addVehFileSelected(String name);

  /// No description provided for @addVehFilePickerError.
  ///
  /// In en, this message translates to:
  /// **'Could not open file picker: {error}'**
  String addVehFilePickerError(String error);

  /// No description provided for @addVehFillRequired.
  ///
  /// In en, this message translates to:
  /// **'Please fill Make, Model and License Plate.'**
  String get addVehFillRequired;

  /// No description provided for @addVehSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get addVehSaveChanges;

  /// No description provided for @addVehSelectFile.
  ///
  /// In en, this message translates to:
  /// **'Select file'**
  String get addVehSelectFile;

  /// No description provided for @addVehVehicleSummary.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Summary'**
  String get addVehVehicleSummary;

  /// No description provided for @addVehAddVehicle.
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle'**
  String get addVehAddVehicle;

  /// No description provided for @addVehEditDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit Details'**
  String get addVehEditDetails;

  /// No description provided for @addVehReadyConfirmBanner.
  ///
  /// In en, this message translates to:
  /// **'Ready to add this vehicle in your garage. You can edit details anytime.'**
  String get addVehReadyConfirmBanner;

  /// No description provided for @postImagesTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Selected images were too large.'**
  String get postImagesTooLarge;

  /// No description provided for @postImagesExceedServer.
  ///
  /// In en, this message translates to:
  /// **'Selected images exceed server size limit.'**
  String get postImagesExceedServer;

  /// No description provided for @postImagesSomeSkipped.
  ///
  /// In en, this message translates to:
  /// **'Some images were skipped to fit server upload size.'**
  String get postImagesSomeSkipped;

  /// No description provided for @postImagesRemoveSome.
  ///
  /// In en, this message translates to:
  /// **'Images are too large. Remove some images and try again.'**
  String get postImagesRemoveSome;

  /// No description provided for @postAddPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add photos'**
  String get postAddPhotos;

  /// No description provided for @aiAssistantTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistantTitle;

  /// No description provided for @aiChatHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat History'**
  String get aiChatHistoryTitle;

  /// No description provided for @aiStartNewChat.
  ///
  /// In en, this message translates to:
  /// **'Start New Chat'**
  String get aiStartNewChat;

  /// No description provided for @aiDeleteSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete chat session?'**
  String get aiDeleteSessionTitle;

  /// No description provided for @aiDeleteSessionBody.
  ///
  /// In en, this message translates to:
  /// **'This will remove the conversation from history. This action cannot be undone.'**
  String get aiDeleteSessionBody;

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get timeJustNow;

  /// No description provided for @timeMinAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String timeMinAgo(int count);

  /// No description provided for @timeHrAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hr ago'**
  String timeHrAgo(int count);

  /// No description provided for @timeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String timeDaysAgo(int count);

  /// No description provided for @routerPageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Error: Page not found'**
  String get routerPageNotFound;

  /// No description provided for @mapRouteNumbered.
  ///
  /// In en, this message translates to:
  /// **'Route {routeNumber}'**
  String mapRouteNumbered(int routeNumber);

  /// No description provided for @scheduleMaintRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get scheduleMaintRetry;

  /// No description provided for @scheduleMaintAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get scheduleMaintAdd;

  /// No description provided for @profileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your name and email. Changes appear in the drawer.'**
  String get profileSubtitle;

  /// No description provided for @profileHintFirstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get profileHintFirstName;

  /// No description provided for @profileHintLastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get profileHintLastName;

  /// No description provided for @profileHintEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileHintEmail;

  /// No description provided for @profileSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get profileSaveChanges;

  /// No description provided for @commNoPostsFound.
  ///
  /// In en, this message translates to:
  /// **'No posts found.'**
  String get commNoPostsFound;

  /// No description provided for @commReportDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us what is wrong'**
  String get commReportDetailsHint;

  /// No description provided for @commCommunityTitle.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get commCommunityTitle;

  /// No description provided for @commCommunitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect with car owners'**
  String get commCommunitySubtitle;

  /// No description provided for @timeWeeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} weeks ago'**
  String timeWeeksAgo(int count);

  /// No description provided for @commComments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commComments;

  /// No description provided for @commNoComments.
  ///
  /// In en, this message translates to:
  /// **'No comments yet.'**
  String get commNoComments;

  /// No description provided for @commWriteComment.
  ///
  /// In en, this message translates to:
  /// **'Write a comment'**
  String get commWriteComment;

  /// No description provided for @commActionsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get commActionsTooltip;

  /// No description provided for @commShowMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get commShowMore;

  /// No description provided for @commShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get commShowLess;

  /// No description provided for @commSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search posts...'**
  String get commSearchHint;

  /// No description provided for @commInvalidImage.
  ///
  /// In en, this message translates to:
  /// **'Invalid image'**
  String get commInvalidImage;

  /// No description provided for @commCannotLoadImage.
  ///
  /// In en, this message translates to:
  /// **'Cannot load image'**
  String get commCannotLoadImage;

  /// No description provided for @commInvalidImageUrl.
  ///
  /// In en, this message translates to:
  /// **'Invalid image URL'**
  String get commInvalidImageUrl;

  /// No description provided for @tabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get tabAll;

  /// No description provided for @tabMyPosts.
  ///
  /// In en, this message translates to:
  /// **'My posts'**
  String get tabMyPosts;

  /// No description provided for @tabBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get tabBookmarks;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navVehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get navVehicle;

  /// No description provided for @navService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get navService;

  /// No description provided for @navCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get navCommunity;

  /// No description provided for @navEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get navEducation;

  /// No description provided for @notifTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifTitle;

  /// No description provided for @notifSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance reminders and app updates'**
  String get notifSubtitle;

  /// No description provided for @commonGarage.
  ///
  /// In en, this message translates to:
  /// **'Garage'**
  String get commonGarage;

  /// No description provided for @apptGarageLine.
  ///
  /// In en, this message translates to:
  /// **'Garage: {name}'**
  String apptGarageLine(String name);

  /// No description provided for @apptCarLine.
  ///
  /// In en, this message translates to:
  /// **'Car: {name}'**
  String apptCarLine(String name);

  /// No description provided for @apptServiceDefault.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get apptServiceDefault;

  /// No description provided for @navVehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get navVehicles;

  /// No description provided for @navEduShort.
  ///
  /// In en, this message translates to:
  /// **'Edu'**
  String get navEduShort;

  /// No description provided for @dashNoVehicle.
  ///
  /// In en, this message translates to:
  /// **'No vehicle'**
  String get dashNoVehicle;

  /// No description provided for @dashAddVehiclePlateHint.
  ///
  /// In en, this message translates to:
  /// **'Add a vehicle'**
  String get dashAddVehiclePlateHint;

  /// No description provided for @dashSelectVehicleForHealth.
  ///
  /// In en, this message translates to:
  /// **'Add or select a vehicle to load car health from the server.'**
  String get dashSelectVehicleForHealth;

  /// No description provided for @dashCouldNotLoadVehicleHealth.
  ///
  /// In en, this message translates to:
  /// **'Could not load vehicle health.'**
  String get dashCouldNotLoadVehicleHealth;

  /// No description provided for @dashVehicleHealthTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Health'**
  String get dashVehicleHealthTitle;

  /// No description provided for @dashOverallCarHealthTitle.
  ///
  /// In en, this message translates to:
  /// **'Overall car health'**
  String get dashOverallCarHealthTitle;

  /// No description provided for @dashHealthScoresFallback.
  ///
  /// In en, this message translates to:
  /// **'Scores come from your maintenance activity and garage data for this vehicle.'**
  String get dashHealthScoresFallback;

  /// No description provided for @dashNoSubsystemData.
  ///
  /// In en, this message translates to:
  /// **'No subsystem data yet.'**
  String get dashNoSubsystemData;

  /// No description provided for @dashMaintenanceRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Reminders'**
  String get dashMaintenanceRemindersTitle;

  /// No description provided for @dashViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get dashViewAll;

  /// No description provided for @dashNoRemindersYet.
  ///
  /// In en, this message translates to:
  /// **'No reminders yet. Schedule maintenance to get started.'**
  String get dashNoRemindersYet;

  /// No description provided for @dashOverdueByDays.
  ///
  /// In en, this message translates to:
  /// **'Overdue by {days} days'**
  String dashOverdueByDays(int days);

  /// No description provided for @dashDueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get dashDueToday;

  /// No description provided for @dashDueTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Due tomorrow'**
  String get dashDueTomorrow;

  /// No description provided for @dashDueInDays.
  ///
  /// In en, this message translates to:
  /// **'Due in {days} days'**
  String dashDueInDays(int days);

  /// No description provided for @dashDueInWeeks.
  ///
  /// In en, this message translates to:
  /// **'Due in {weeks} weeks'**
  String dashDueInWeeks(int weeks);

  /// No description provided for @dashStatusUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get dashStatusUrgent;

  /// No description provided for @dashStatusSoon.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get dashStatusSoon;

  /// No description provided for @dashStatusGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get dashStatusGood;

  /// No description provided for @dashStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get dashStatusDone;

  /// No description provided for @dashPlateLine.
  ///
  /// In en, this message translates to:
  /// **'Plate {plate}'**
  String dashPlateLine(String plate);

  /// No description provided for @dashQuickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get dashQuickActionsTitle;

  /// No description provided for @dashBookService.
  ///
  /// In en, this message translates to:
  /// **'Book Service'**
  String get dashBookService;

  /// No description provided for @dashFindNearbyGarage.
  ///
  /// In en, this message translates to:
  /// **'Find Nearby Garage'**
  String get dashFindNearbyGarage;

  /// No description provided for @dashChatAiAssistant.
  ///
  /// In en, this message translates to:
  /// **'Chat with AI Assistant'**
  String get dashChatAiAssistant;

  /// No description provided for @dashMaintenanceHistory.
  ///
  /// In en, this message translates to:
  /// **'Maintenance History'**
  String get dashMaintenanceHistory;

  /// No description provided for @dashRecentActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get dashRecentActivityTitle;

  /// No description provided for @dashNoRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity yet.'**
  String get dashNoRecentActivity;

  /// No description provided for @dashActivityCompleted.
  ///
  /// In en, this message translates to:
  /// **'{title} completed'**
  String dashActivityCompleted(String title);

  /// No description provided for @dashVehicleAdded.
  ///
  /// In en, this message translates to:
  /// **'Vehicle added: {name}'**
  String dashVehicleAdded(String name);

  /// No description provided for @timeMonthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} months ago'**
  String timeMonthsAgo(int count);

  /// No description provided for @vehListTitleMyVehicles.
  ///
  /// In en, this message translates to:
  /// **'My Vehicles'**
  String get vehListTitleMyVehicles;

  /// No description provided for @vehListTitleUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Maintenance'**
  String get vehListTitleUpcoming;

  /// No description provided for @vehListTitleHistory.
  ///
  /// In en, this message translates to:
  /// **'Maintenance History'**
  String get vehListTitleHistory;

  /// No description provided for @vehListSubtitleMyVehicles.
  ///
  /// In en, this message translates to:
  /// **'Manage your vehicles and maintenance'**
  String get vehListSubtitleMyVehicles;

  /// No description provided for @vehListSubtitleUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Scheduled and recommended services'**
  String get vehListSubtitleUpcoming;

  /// No description provided for @vehListSubtitleHistory.
  ///
  /// In en, this message translates to:
  /// **'Scheduled reminders and completed services'**
  String get vehListSubtitleHistory;

  /// No description provided for @vehSegmentMyVehicles.
  ///
  /// In en, this message translates to:
  /// **'My Vehicles'**
  String get vehSegmentMyVehicles;

  /// No description provided for @vehSegmentUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get vehSegmentUpcoming;

  /// No description provided for @vehSegmentHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get vehSegmentHistory;

  /// No description provided for @vehRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get vehRetry;

  /// No description provided for @vehFabAddNewVehicle.
  ///
  /// In en, this message translates to:
  /// **'Add New Vehicle'**
  String get vehFabAddNewVehicle;

  /// No description provided for @vehFabRegisterAnother.
  ///
  /// In en, this message translates to:
  /// **'Register another car'**
  String get vehFabRegisterAnother;

  /// No description provided for @vehHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet.\n\nScheduled reminders and completed services show here with status (Good, Soon, Overdue, Done). Use Upcoming to schedule maintenance or mark it done.'**
  String get vehHistoryEmpty;

  /// No description provided for @vehCardStatusGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get vehCardStatusGood;

  /// No description provided for @vehCardStatusAttention.
  ///
  /// In en, this message translates to:
  /// **'Attention'**
  String get vehCardStatusAttention;

  /// No description provided for @eduAllArticlesTitle.
  ///
  /// In en, this message translates to:
  /// **'All articles'**
  String get eduAllArticlesTitle;

  /// No description provided for @eduArticlesInCategory.
  ///
  /// In en, this message translates to:
  /// **'{category} articles'**
  String eduArticlesInCategory(String category);

  /// No description provided for @eduNoArticlesInCategory.
  ///
  /// In en, this message translates to:
  /// **'No articles in this category.'**
  String get eduNoArticlesInCategory;

  /// No description provided for @eduArticleLabel.
  ///
  /// In en, this message translates to:
  /// **'Article'**
  String get eduArticleLabel;

  /// No description provided for @eduCategoryGuide.
  ///
  /// In en, this message translates to:
  /// **'{category} guide'**
  String eduCategoryGuide(String category);

  /// No description provided for @eduCouldNotLoadArticle.
  ///
  /// In en, this message translates to:
  /// **'Could not load this article.'**
  String get eduCouldNotLoadArticle;

  /// No description provided for @eduReadMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String eduReadMinutes(int minutes);

  /// No description provided for @eduCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Education Center'**
  String get eduCenterTitle;

  /// No description provided for @eduCenterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn to maintain your vehicle'**
  String get eduCenterSubtitle;

  /// No description provided for @eduSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search guides and articles...'**
  String get eduSearchHint;

  /// No description provided for @eduResultsFor.
  ///
  /// In en, this message translates to:
  /// **'Results for \"{query}\"'**
  String eduResultsFor(String query);

  /// No description provided for @eduFeaturedArticles.
  ///
  /// In en, this message translates to:
  /// **'Featured Articles'**
  String get eduFeaturedArticles;

  /// No description provided for @eduNoArticlesMatchSearch.
  ///
  /// In en, this message translates to:
  /// **'No articles match your search.'**
  String get eduNoArticlesMatchSearch;

  /// No description provided for @eduNoArticlesYet.
  ///
  /// In en, this message translates to:
  /// **'No articles yet. Check back soon.'**
  String get eduNoArticlesYet;

  /// No description provided for @eduCategoryArticleCount.
  ///
  /// In en, this message translates to:
  /// **'{count} articles'**
  String eduCategoryArticleCount(int count);

  /// No description provided for @eduCatRepairs.
  ///
  /// In en, this message translates to:
  /// **'Repair'**
  String get eduCatRepairs;

  /// No description provided for @eduCatSafety.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get eduCatSafety;

  /// No description provided for @eduCatMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get eduCatMaintenance;

  /// No description provided for @eduCatTips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get eduCatTips;

  /// No description provided for @eduCatManuals.
  ///
  /// In en, this message translates to:
  /// **'Manuals'**
  String get eduCatManuals;

  /// No description provided for @eduReadMore.
  ///
  /// In en, this message translates to:
  /// **'Read ›'**
  String get eduReadMore;

  /// No description provided for @eduDifficultyBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get eduDifficultyBeginner;

  /// No description provided for @eduDifficultyIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get eduDifficultyIntermediate;

  /// No description provided for @eduTopicSafety.
  ///
  /// In en, this message translates to:
  /// **'Safety tips'**
  String get eduTopicSafety;

  /// No description provided for @eduTopicMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance basics'**
  String get eduTopicMaintenance;

  /// No description provided for @eduTopicRepairs.
  ///
  /// In en, this message translates to:
  /// **'Repair guides'**
  String get eduTopicRepairs;

  /// No description provided for @eduTopicTips.
  ///
  /// In en, this message translates to:
  /// **'Tips & tricks'**
  String get eduTopicTips;

  /// No description provided for @eduTopicAll.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get eduTopicAll;

  /// No description provided for @eduTopicManuals.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get eduTopicManuals;

  /// No description provided for @svcLocServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled. Enable location to see nearby garages.'**
  String get svcLocServicesDisabled;

  /// No description provided for @svcLocPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission is permanently denied. Allow it from app settings.'**
  String get svcLocPermissionDeniedForever;

  /// No description provided for @svcLocPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied. Allow location permission to find nearby garages.'**
  String get svcLocPermissionDenied;

  /// No description provided for @svcLocFetchFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to fetch your location. Showing fallback results.'**
  String get svcLocFetchFailed;

  /// No description provided for @svcServiceCentersTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Centers'**
  String get svcServiceCentersTitle;

  /// No description provided for @svcServiceCentersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find nearby garages and book service'**
  String get svcServiceCentersSubtitle;

  /// No description provided for @svcUpcomingAppointments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointments'**
  String get svcUpcomingAppointments;

  /// No description provided for @svcNoUpcomingAppointments.
  ///
  /// In en, this message translates to:
  /// **'No upcoming appointments'**
  String get svcNoUpcomingAppointments;

  /// No description provided for @svcNearbyCentersTitle.
  ///
  /// In en, this message translates to:
  /// **'Nearby Service Centers'**
  String get svcNearbyCentersTitle;

  /// No description provided for @svcNoNearbyGarages.
  ///
  /// In en, this message translates to:
  /// **'No nearby garages found.'**
  String get svcNoNearbyGarages;

  /// No description provided for @svcOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get svcOpen;

  /// No description provided for @svcBookAhead.
  ///
  /// In en, this message translates to:
  /// **'Book ahead'**
  String get svcBookAhead;

  /// No description provided for @svcClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get svcClosed;

  /// No description provided for @svcOnsiteAvailable.
  ///
  /// In en, this message translates to:
  /// **'On-site service available'**
  String get svcOnsiteAvailable;

  /// No description provided for @svcViewReviews.
  ///
  /// In en, this message translates to:
  /// **'View reviews'**
  String get svcViewReviews;

  /// No description provided for @svcReviewsRatingTitle.
  ///
  /// In en, this message translates to:
  /// **'Reviews & Rating'**
  String get svcReviewsRatingTitle;

  /// No description provided for @svcReviewCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 review} other{{count} reviews}}'**
  String svcReviewCount(int count);

  /// No description provided for @svcReviewsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load reviews right now.'**
  String get svcReviewsLoadError;

  /// No description provided for @svcReviewsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet for this garage.'**
  String get svcReviewsEmpty;

  /// No description provided for @svcReviewNoComment.
  ///
  /// In en, this message translates to:
  /// **'No comment'**
  String get svcReviewNoComment;

  /// No description provided for @svcReviewAnonymousDriver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get svcReviewAnonymousDriver;

  /// No description provided for @svcUnknownDate.
  ///
  /// In en, this message translates to:
  /// **'Unknown date'**
  String get svcUnknownDate;

  /// No description provided for @svcMapView.
  ///
  /// In en, this message translates to:
  /// **'Map View'**
  String get svcMapView;

  /// No description provided for @svcApptsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get svcApptsPageTitle;

  /// No description provided for @svcApptsListTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get svcApptsListTitle;

  /// No description provided for @svcApptsListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage your bookings'**
  String get svcApptsListSubtitle;

  /// No description provided for @svcNoAppointmentsFound.
  ///
  /// In en, this message translates to:
  /// **'No appointments found'**
  String get svcNoAppointmentsFound;

  /// No description provided for @svcNoAppointmentsYet.
  ///
  /// In en, this message translates to:
  /// **'No appointments yet'**
  String get svcNoAppointmentsYet;

  /// No description provided for @svcUnableSubmitRating.
  ///
  /// In en, this message translates to:
  /// **'Unable to submit rating'**
  String get svcUnableSubmitRating;

  /// No description provided for @svcUnableLoadGarages.
  ///
  /// In en, this message translates to:
  /// **'Unable to load nearby garages.'**
  String get svcUnableLoadGarages;

  /// No description provided for @svcRateTapStar.
  ///
  /// In en, this message translates to:
  /// **'Tap a star to rate'**
  String get svcRateTapStar;

  /// No description provided for @svcRateStarsSelected.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 star selected} other{{count} stars selected}}'**
  String svcRateStarsSelected(int count);

  /// No description provided for @svcRateFeedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Write optional feedback'**
  String get svcRateFeedbackHint;

  /// No description provided for @apptStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get apptStatusPending;

  /// No description provided for @apptStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get apptStatusConfirmed;

  /// No description provided for @apptStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get apptStatusRejected;

  /// No description provided for @apptStatusInService.
  ///
  /// In en, this message translates to:
  /// **'In Service'**
  String get apptStatusInService;

  /// No description provided for @apptStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get apptStatusCompleted;

  /// No description provided for @apptStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get apptStatusCancelled;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['am', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am':
      return AppLocalizationsAm();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
