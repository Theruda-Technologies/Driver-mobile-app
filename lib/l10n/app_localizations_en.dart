// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Driver Assistance';

  @override
  String get loginPhoneInvalidSnackbar =>
      'Enter a valid phone: 09…, 251…, or +251… (9-digit mobile).';

  @override
  String get loginWelcomeTitle => 'Welcome Back';

  @override
  String get loginWelcomeSubtitle => 'Sign in to continue to your account';

  @override
  String get loginPhoneLabel => 'Phone Number';

  @override
  String get loginPhoneHint => '09…, 251…, or +251…';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHint => 'Enter your password';

  @override
  String get loginButton => 'Log in';

  @override
  String get loginNoAccountPrompt => 'Don\'t have an account? ';

  @override
  String get loginCreateAccount => 'Create account';

  @override
  String get signupEnterValidPhoneOtp =>
      'Enter a valid phone before requesting OTP.';

  @override
  String get signupPhoneVerifiedAutomatic =>
      'Phone number verified automatically.';

  @override
  String get signupFailedSendOtp => 'Failed to send OTP.';

  @override
  String get signupOtpSentCheckSms => 'OTP sent. Check your SMS.';

  @override
  String signupOtpSetupFailed(String error) {
    return 'OTP setup failed: $error';
  }

  @override
  String get signupRequestOtpFirst => 'Request OTP first.';

  @override
  String get signupEnterValidPhone => 'Enter a valid phone number.';

  @override
  String get signupEnterSixDigitOtp => 'Enter the 6-digit OTP code.';

  @override
  String get signupPasswordsMismatch => 'Passwords do not match';

  @override
  String get signupPasswordMin8 => 'Password must be at least 8 characters';

  @override
  String get signupPhoneInvalidSnackbar =>
      'Enter a valid phone: 09…, 251…, or +251… (9-digit mobile).';

  @override
  String get signupVerifyPhoneBeforeSignup =>
      'Verify your phone with OTP before signup.';

  @override
  String get signupFirebaseTokenMissing =>
      'Phone verified, but Firebase token is missing. Verify OTP again.';

  @override
  String get signupTitle => 'Create Account';

  @override
  String get signupSubtitle => 'Sign up to get started with CarCare';

  @override
  String get signupFirstName => 'First Name';

  @override
  String get signupLastName => 'Last Name';

  @override
  String get signupHintFirstName => 'John';

  @override
  String get signupHintLastName => 'Doe';

  @override
  String get signupEmail => 'Email';

  @override
  String get signupEmailHint => 'you@example.com';

  @override
  String get signupPhoneLabel => 'Phone Number';

  @override
  String get signupPhoneHint => '09…, 251…, or +251…';

  @override
  String get signupSendOtp => 'Send OTP';

  @override
  String get signupResendOtp => 'Resend OTP';

  @override
  String get signupOtpCodeLabel => 'OTP Code';

  @override
  String get signupOtpHint => 'Enter 6-digit code';

  @override
  String get signupVerify => 'Verify';

  @override
  String get signupVerified => 'Verified';

  @override
  String get signupPasswordLabel => 'Password';

  @override
  String get signupPasswordHint => 'At least 8 characters';

  @override
  String get signupConfirmPasswordLabel => 'Confirm Password';

  @override
  String get signupConfirmPasswordHint => 'Re-enter your password';

  @override
  String get signupCreateButton => 'Create Account';

  @override
  String get signupOtpVerifiedSuccess => 'OTP verified successfully.';

  @override
  String get signupInvalidOtp => 'Invalid OTP code.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageAmharic => 'አማርኛ (Amharic)';

  @override
  String get authLanguageChipEnglish => 'English';

  @override
  String get authLanguageChipAmharic => 'አማርኛ';

  @override
  String get settingsChangePasswordTitle => 'Change Password';

  @override
  String get settingsChangePasswordSubtitle =>
      'Use your current password to set a new one.';

  @override
  String get settingsCurrentPasswordLabel => 'Current password';

  @override
  String get settingsNewPasswordLabel => 'New password';

  @override
  String get settingsConfirmNewPasswordLabel => 'Confirm new password';

  @override
  String get settingsPasswordChanged => 'Password changed successfully';

  @override
  String get settingsRequestFailed => 'Request failed';

  @override
  String get settingsUnableChangePassword =>
      'Unable to change password right now.';

  @override
  String get settingsValidatorCurrentRequired => 'Current password is required';

  @override
  String get settingsValidatorNewRequired => 'New password is required';

  @override
  String get settingsValidatorNewMin6 =>
      'Password must be at least 6 characters';

  @override
  String get settingsValidatorNewDifferent => 'New password must be different';

  @override
  String get settingsValidatorConfirmRequired =>
      'Please confirm your new password';

  @override
  String get settingsValidatorPasswordsMismatch => 'Passwords do not match';

  @override
  String get settingsUpdatePasswordButton => 'Update password';

  @override
  String get brandCarCare => 'CarCare';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonBack => 'Back';

  @override
  String get commonSubmit => 'Submit';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonReport => 'Report';

  @override
  String get commonSave => 'Save';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonClear => 'Clear';

  @override
  String get commonViewAll => 'View All';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonBook => 'Book';

  @override
  String get commonCall => 'Call';

  @override
  String get commonRoute => 'Route';

  @override
  String get commonNavigate => 'Navigate';

  @override
  String get commonGuest => 'Guest';

  @override
  String get commonEmDash => '—';

  @override
  String get drawerNavSection => 'NAVIGATION';

  @override
  String get drawerAccountSection => 'ACCOUNT';

  @override
  String get drawerHome => 'Home';

  @override
  String get drawerMyVehicles => 'My Vehicles';

  @override
  String get drawerService => 'Service';

  @override
  String get drawerCommunity => 'Community';

  @override
  String get drawerEducation => 'Education';

  @override
  String get drawerProfile => 'Profile';

  @override
  String get drawerSettings => 'Settings';

  @override
  String get drawerHelpSupport => 'Help & Support';

  @override
  String get drawerLogout => 'Logout';

  @override
  String get onbTitle1 => 'Know Your Car\'s Health';

  @override
  String get onbBody1 =>
      'Track your vehicle details, maintenance status, and upcoming services all in one place — no more guesswork.';

  @override
  String get onbTitle2 => 'Never Miss Maintenance';

  @override
  String get onbBody2 =>
      'Get timely reminders for oil changes, tire checks, and services so your car stays reliable and safe.';

  @override
  String get onbTitle3 => 'Find Help When You Need It';

  @override
  String get onbBody3 =>
      'Locate nearby garages, book services, or request onsite assistance anytime, anywhere.';

  @override
  String get onbTitle4 => 'Ask Your AI Car Assistant';

  @override
  String get onbBody4 =>
      'Chat with an AI assistant for instant help, maintenance tips, and answers about your vehicle.';

  @override
  String get onbTitle5 => 'Learn. Share. Drive Better.';

  @override
  String get onbBody5 =>
      'Explore car care guides and connect with other drivers to share experiences and advice.';

  @override
  String get onbTitle6 => 'Ready to Drive Smarter?';

  @override
  String get onbBody6 =>
      'Join thousands of drivers who trust us to keep their vehicles in perfect condition.';

  @override
  String get onbSkip => 'Skip';

  @override
  String get onbGetStarted => 'Get Started';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get profileFirstName => 'First Name';

  @override
  String get profileLastName => 'Last Name';

  @override
  String get profileEmail => 'Email';

  @override
  String get profilePleaseSignIn => 'Please sign in.';

  @override
  String get commCreatePost => 'Create Post';

  @override
  String get commReportPost => 'Report Post';

  @override
  String get commReportSpam => 'Spam';

  @override
  String get commReportHarassment => 'Harassment';

  @override
  String get commReportHate => 'Hate speech';

  @override
  String get commReportFalseInfo => 'False information';

  @override
  String get commReportViolence => 'Violence';

  @override
  String get commReportNudity => 'Nudity or sexual content';

  @override
  String get commReportScam => 'Scam or fraud';

  @override
  String get commReportOther => 'Other';

  @override
  String get eduClear => 'Clear';

  @override
  String get eduViewAll => 'View All';

  @override
  String get eduRetry => 'Retry';

  @override
  String get eduGetManual => 'Get Manual';

  @override
  String get eduInvalidPdf => 'Invalid PDF link.';

  @override
  String get eduCouldNotOpenManual => 'Could not open this manual.';

  @override
  String get notifMarkAllRead => 'Mark all as read';

  @override
  String get vehScheduleMaintenance => 'Schedule Maintenance';

  @override
  String get maintSetReminder => 'Set Maintenance Reminder';

  @override
  String get maintDone => 'Done';

  @override
  String get maintDelete => 'Delete';

  @override
  String get logMaintNoVehicle => 'No vehicle';

  @override
  String get bookWizardGarageError => 'Unable to load garage availability';

  @override
  String get bookWizardAddVehicle => 'Add Vehicle';

  @override
  String get bookWizardSlotUnavailable =>
      'Selected time is not available. Please choose an available slot.';

  @override
  String get bookWizardBackHome => 'Back to Home';

  @override
  String get bookWizardViewAppointments => 'View All Appointments';

  @override
  String get svcApptUpdated => 'Appointment updated.';

  @override
  String get svcRetry => 'Retry';

  @override
  String get svcRateGarage => 'Rate Garage';

  @override
  String get svcReschedule => 'Reschedule';

  @override
  String get svcCancel => 'Cancel';

  @override
  String get svcRateExperienceTitle => 'How was your service experience?';

  @override
  String get svcRatingThanks => 'Thanks! Your rating was submitted.';

  @override
  String get svcCancelApptTitle => 'Cancel appointment?';

  @override
  String get svcCancelApptBody => 'This action cannot be undone.';

  @override
  String get svcBook => 'Book';

  @override
  String get svcCall => 'Call';

  @override
  String get svcRoute => 'Route';

  @override
  String get svcNoPhone => 'No phone number available for this garage.';

  @override
  String get svcCallNotSupported => 'Calling is not supported on this device.';

  @override
  String get apptCancelTitle => 'Cancel appointment?';

  @override
  String get apptCancelBody => 'This action cannot be undone.';

  @override
  String get mapLocationRequired => 'Location required to load nearby places';

  @override
  String get mapRoutingLocationRequired =>
      'Current location is required for routing';

  @override
  String get mapRouteUpdated => 'Route updated to tapped location';

  @override
  String get mapSetAsStart => 'Set as start';

  @override
  String get mapApptBooked => 'Appointment booked successfully';

  @override
  String get mapGettingLocation => 'Getting your location...';

  @override
  String get mapBookAppointment => 'Book Appointment';

  @override
  String get mapRequestOnsite => 'Request On-site Service';

  @override
  String get mapOnsiteLocationBody =>
      'Turn on location access so we can send the garage your position for on-site service.';

  @override
  String get mapGarageDetailsTitle => 'Garage details';

  @override
  String get mapCloseTooltip => 'Close';

  @override
  String get vehDetailRemoved => 'Vehicle removed.';

  @override
  String get vehDetailAskAi => 'Ask AI assistant';

  @override
  String get vehDetailEditVehicle => 'Edit Vehicle';

  @override
  String get vehDetailRemoveVehicle => 'Remove Vehicle';

  @override
  String get vehDetailRemoveTitle => 'Remove vehicle?';

  @override
  String get vehDetailInsurance => 'Insurance';

  @override
  String get vehDetailRegistration => 'Registration';

  @override
  String get vehDetailViewDocuments => 'View Documents';

  @override
  String get vehDetailInsuranceDoc => 'Insurance Document';

  @override
  String get vehDetailRegistrationDoc => 'Registration Document';

  @override
  String get vehDetailTitle => 'Vehicle Details';

  @override
  String vehDetailRemoveConfirmBody(String name) {
    return '$name will be removed. This action cannot be undone.';
  }

  @override
  String get vehDetailHealthUnavailable => 'Overall health unavailable';

  @override
  String get vehDetailHealthRetryHint => 'Pull to refresh or try again.';

  @override
  String get vehDetailDocumentsSection => 'Documents';

  @override
  String get vehDetailVehicleInformation => 'Vehicle Information';

  @override
  String get vehDetailMakeModel => 'Make & Model';

  @override
  String get vehDetailYear => 'Year';

  @override
  String get vehDetailVin => 'VIN';

  @override
  String get vehDetailMileage => 'Mileage';

  @override
  String get vehDetailFuelType => 'Fuel Type';

  @override
  String vehDetailInsuranceActiveExpires(String date) {
    return 'Active - Expires $date';
  }

  @override
  String vehDetailRegistrationValidExpires(String date) {
    return 'Valid - Expires $date';
  }

  @override
  String get vehDetailNoDocumentsAvailable => 'No documents available.';

  @override
  String get commonMilesUnit => 'miles';

  @override
  String get addVehSuccessAdded => 'Vehicle added successfully.';

  @override
  String get addVehSuccessUpdated => 'Vehicle updated.';

  @override
  String addVehFileSelected(String name) {
    return 'Selected: $name';
  }

  @override
  String addVehFilePickerError(String error) {
    return 'Could not open file picker: $error';
  }

  @override
  String get addVehFillRequired => 'Please fill Make, Model and License Plate.';

  @override
  String get addVehSaveChanges => 'Save Changes';

  @override
  String get addVehSelectFile => 'Select file';

  @override
  String get addVehVehicleSummary => 'Vehicle Summary';

  @override
  String get addVehAddVehicle => 'Add Vehicle';

  @override
  String get addVehEditDetails => 'Edit Details';

  @override
  String get addVehReadyConfirmBanner =>
      'Ready to add this vehicle in your garage. You can edit details anytime.';

  @override
  String get postImagesTooLarge => 'Selected images were too large.';

  @override
  String get postImagesExceedServer =>
      'Selected images exceed server size limit.';

  @override
  String get postImagesSomeSkipped =>
      'Some images were skipped to fit server upload size.';

  @override
  String get postImagesRemoveSome =>
      'Images are too large. Remove some images and try again.';

  @override
  String get postAddPhotos => 'Add photos';

  @override
  String get aiAssistantTitle => 'AI Assistant';

  @override
  String get aiChatHistoryTitle => 'Chat History';

  @override
  String get aiStartNewChat => 'Start New Chat';

  @override
  String get aiDeleteSessionTitle => 'Delete chat session?';

  @override
  String get aiDeleteSessionBody =>
      'This will remove the conversation from history. This action cannot be undone.';

  @override
  String get timeJustNow => 'Just now';

  @override
  String timeMinAgo(int count) {
    return '$count min ago';
  }

  @override
  String timeHrAgo(int count) {
    return '$count hr ago';
  }

  @override
  String timeDaysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get routerPageNotFound => 'Error: Page not found';

  @override
  String mapRouteNumbered(int routeNumber) {
    return 'Route $routeNumber';
  }

  @override
  String get scheduleMaintRetry => 'Retry';

  @override
  String get scheduleMaintAdd => 'Add';

  @override
  String get profileSubtitle =>
      'Update your name and email. Changes appear in the drawer.';

  @override
  String get profileHintFirstName => 'First name';

  @override
  String get profileHintLastName => 'Last name';

  @override
  String get profileHintEmail => 'Email';

  @override
  String get profileSaveChanges => 'Save changes';

  @override
  String get commNoPostsFound => 'No posts found.';

  @override
  String get commReportDetailsHint => 'Tell us what is wrong';

  @override
  String get commCommunityTitle => 'Community';

  @override
  String get commCommunitySubtitle => 'Connect with car owners';

  @override
  String timeWeeksAgo(int count) {
    return '$count weeks ago';
  }

  @override
  String get commComments => 'Comments';

  @override
  String get commNoComments => 'No comments yet.';

  @override
  String get commWriteComment => 'Write a comment';

  @override
  String get commActionsTooltip => 'Actions';

  @override
  String get commShowMore => 'Show more';

  @override
  String get commShowLess => 'Show less';

  @override
  String get commSearchHint => 'Search posts...';

  @override
  String get commInvalidImage => 'Invalid image';

  @override
  String get commCannotLoadImage => 'Cannot load image';

  @override
  String get commInvalidImageUrl => 'Invalid image URL';

  @override
  String get tabAll => 'All';

  @override
  String get tabMyPosts => 'My posts';

  @override
  String get tabBookmarks => 'Bookmarks';

  @override
  String get navHome => 'Home';

  @override
  String get navVehicle => 'Vehicle';

  @override
  String get navService => 'Service';

  @override
  String get navCommunity => 'Community';

  @override
  String get navEducation => 'Education';

  @override
  String get notifTitle => 'Notifications';

  @override
  String get notifSubtitle => 'Maintenance reminders and app updates';

  @override
  String get commonGarage => 'Garage';

  @override
  String apptGarageLine(String name) {
    return 'Garage: $name';
  }

  @override
  String apptCarLine(String name) {
    return 'Car: $name';
  }

  @override
  String get apptServiceDefault => 'Service';

  @override
  String get navVehicles => 'Vehicles';

  @override
  String get navEduShort => 'Edu';

  @override
  String get dashNoVehicle => 'No vehicle';

  @override
  String get dashAddVehiclePlateHint => 'Add a vehicle';

  @override
  String get dashSelectVehicleForHealth =>
      'Add or select a vehicle to load car health from the server.';

  @override
  String get dashCouldNotLoadVehicleHealth => 'Could not load vehicle health.';

  @override
  String get dashVehicleHealthTitle => 'Vehicle Health';

  @override
  String get dashOverallCarHealthTitle => 'Overall car health';

  @override
  String get dashHealthScoresFallback =>
      'Scores come from your maintenance activity and garage data for this vehicle.';

  @override
  String get dashNoSubsystemData => 'No subsystem data yet.';

  @override
  String get dashMaintenanceRemindersTitle => 'Maintenance Reminders';

  @override
  String get dashViewAll => 'View all';

  @override
  String get dashNoRemindersYet =>
      'No reminders yet. Schedule maintenance to get started.';

  @override
  String dashOverdueByDays(int days) {
    return 'Overdue by $days days';
  }

  @override
  String get dashDueToday => 'Due today';

  @override
  String get dashDueTomorrow => 'Due tomorrow';

  @override
  String dashDueInDays(int days) {
    return 'Due in $days days';
  }

  @override
  String dashDueInWeeks(int weeks) {
    return 'Due in $weeks weeks';
  }

  @override
  String get dashStatusUrgent => 'Urgent';

  @override
  String get dashStatusSoon => 'Soon';

  @override
  String get dashStatusGood => 'Good';

  @override
  String get dashStatusDone => 'Done';

  @override
  String dashPlateLine(String plate) {
    return 'Plate $plate';
  }

  @override
  String get dashQuickActionsTitle => 'Quick Actions';

  @override
  String get dashBookService => 'Book Service';

  @override
  String get dashFindNearbyGarage => 'Find Nearby Garage';

  @override
  String get dashChatAiAssistant => 'Chat with AI Assistant';

  @override
  String get dashMaintenanceHistory => 'Maintenance History';

  @override
  String get dashRecentActivityTitle => 'Recent Activity';

  @override
  String get dashNoRecentActivity => 'No recent activity yet.';

  @override
  String dashActivityCompleted(String title) {
    return '$title completed';
  }

  @override
  String dashVehicleAdded(String name) {
    return 'Vehicle added: $name';
  }

  @override
  String timeMonthsAgo(int count) {
    return '$count months ago';
  }

  @override
  String get vehListTitleMyVehicles => 'My Vehicles';

  @override
  String get vehListTitleUpcoming => 'Upcoming Maintenance';

  @override
  String get vehListTitleHistory => 'Maintenance History';

  @override
  String get vehListSubtitleMyVehicles =>
      'Manage your vehicles and maintenance';

  @override
  String get vehListSubtitleUpcoming => 'Scheduled and recommended services';

  @override
  String get vehListSubtitleHistory =>
      'Scheduled reminders and completed services';

  @override
  String get vehSegmentMyVehicles => 'My Vehicles';

  @override
  String get vehSegmentUpcoming => 'Upcoming';

  @override
  String get vehSegmentHistory => 'History';

  @override
  String get vehRetry => 'Retry';

  @override
  String get vehFabAddNewVehicle => 'Add New Vehicle';

  @override
  String get vehFabRegisterAnother => 'Register another car';

  @override
  String get vehHistoryEmpty =>
      'Nothing here yet.\n\nScheduled reminders and completed services show here with status (Good, Soon, Overdue, Done). Use Upcoming to schedule maintenance or mark it done.';

  @override
  String get vehCardStatusGood => 'Good';

  @override
  String get vehCardStatusAttention => 'Attention';

  @override
  String get eduAllArticlesTitle => 'All articles';

  @override
  String eduArticlesInCategory(String category) {
    return '$category articles';
  }

  @override
  String get eduNoArticlesInCategory => 'No articles in this category.';

  @override
  String get eduArticleLabel => 'Article';

  @override
  String eduCategoryGuide(String category) {
    return '$category guide';
  }

  @override
  String get eduCouldNotLoadArticle => 'Could not load this article.';

  @override
  String eduReadMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get eduCenterTitle => 'Education Center';

  @override
  String get eduCenterSubtitle => 'Learn to maintain your vehicle';

  @override
  String get eduSearchHint => 'Search guides and articles...';

  @override
  String eduResultsFor(String query) {
    return 'Results for \"$query\"';
  }

  @override
  String get eduFeaturedArticles => 'Featured Articles';

  @override
  String get eduNoArticlesMatchSearch => 'No articles match your search.';

  @override
  String get eduNoArticlesYet => 'No articles yet. Check back soon.';

  @override
  String eduCategoryArticleCount(int count) {
    return '$count articles';
  }

  @override
  String get eduCatRepairs => 'Repair';

  @override
  String get eduCatSafety => 'Safety';

  @override
  String get eduCatMaintenance => 'Maintenance';

  @override
  String get eduCatTips => 'Tips';

  @override
  String get eduCatManuals => 'Manuals';

  @override
  String get eduReadMore => 'Read ›';

  @override
  String get eduDifficultyBeginner => 'Beginner';

  @override
  String get eduDifficultyIntermediate => 'Intermediate';

  @override
  String get eduTopicSafety => 'Safety tips';

  @override
  String get eduTopicMaintenance => 'Maintenance basics';

  @override
  String get eduTopicRepairs => 'Repair guides';

  @override
  String get eduTopicTips => 'Tips & tricks';

  @override
  String get eduTopicAll => 'Guide';

  @override
  String get eduTopicManuals => 'Manual';

  @override
  String get svcLocServicesDisabled =>
      'Location services are disabled. Enable location to see nearby garages.';

  @override
  String get svcLocPermissionDeniedForever =>
      'Location permission is permanently denied. Allow it from app settings.';

  @override
  String get svcLocPermissionDenied =>
      'Location permission denied. Allow location permission to find nearby garages.';

  @override
  String get svcLocFetchFailed =>
      'Unable to fetch your location. Showing fallback results.';

  @override
  String get svcServiceCentersTitle => 'Service Centers';

  @override
  String get svcServiceCentersSubtitle =>
      'Find nearby garages and book service';

  @override
  String get svcUpcomingAppointments => 'Upcoming Appointments';

  @override
  String get svcNoUpcomingAppointments => 'No upcoming appointments';

  @override
  String get svcNearbyCentersTitle => 'Nearby Service Centers';

  @override
  String get svcNoNearbyGarages => 'No nearby garages found.';

  @override
  String get svcOpen => 'Open';

  @override
  String get svcClosed => 'Closed';

  @override
  String get svcViewReviews => 'View reviews';

  @override
  String get svcReviewsRatingTitle => 'Reviews & Rating';

  @override
  String svcReviewCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
    );
    return '$_temp0';
  }

  @override
  String get svcReviewsLoadError => 'Could not load reviews right now.';

  @override
  String get svcReviewsEmpty => 'No reviews yet for this garage.';

  @override
  String get svcReviewNoComment => 'No comment';

  @override
  String get svcReviewAnonymousDriver => 'Driver';

  @override
  String get svcUnknownDate => 'Unknown date';

  @override
  String get svcMapView => 'Map View';

  @override
  String get svcApptsPageTitle => 'Appointments';

  @override
  String get svcApptsListTitle => 'Appointments';

  @override
  String get svcApptsListSubtitle => 'View and manage your bookings';

  @override
  String get svcNoAppointmentsFound => 'No appointments found';

  @override
  String get svcNoAppointmentsYet => 'No appointments yet';

  @override
  String get svcUnableSubmitRating => 'Unable to submit rating';

  @override
  String get svcUnableLoadGarages => 'Unable to load nearby garages.';

  @override
  String get svcRateTapStar => 'Tap a star to rate';

  @override
  String svcRateStarsSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stars selected',
      one: '1 star selected',
    );
    return '$_temp0';
  }

  @override
  String get svcRateFeedbackHint => 'Write optional feedback';

  @override
  String get apptStatusPending => 'Pending';

  @override
  String get apptStatusConfirmed => 'Confirmed';

  @override
  String get apptStatusRejected => 'Rejected';

  @override
  String get apptStatusInService => 'In Service';

  @override
  String get apptStatusCompleted => 'Completed';

  @override
  String get apptStatusCancelled => 'Cancelled';
}
