
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
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
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Bluecherry Surveillance DVR!\nLet\'s connect to your DVR server in a few quick steps.'**
  String get welcomeDescription;

  /// No description provided for @configure.
  ///
  /// In en, this message translates to:
  /// **'Configure a DVR Server'**
  String get configure;

  /// No description provided for @configureDescription.
  ///
  /// In en, this message translates to:
  /// **'Setup a connection to your remote DVR server'**
  String get configureDescription;

  /// No description provided for @hostname.
  ///
  /// In en, this message translates to:
  /// **'Hostname'**
  String get hostname;

  /// No description provided for @port.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @savePassword.
  ///
  /// In en, this message translates to:
  /// **'Save password'**
  String get savePassword;

  /// No description provided for @useDefault.
  ///
  /// In en, this message translates to:
  /// **'Use Default'**
  String get useDefault;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @connectAutomaticallyAtStartup.
  ///
  /// In en, this message translates to:
  /// **'Connect automatically at startup'**
  String get connectAutomaticallyAtStartup;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @letsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Go!'**
  String get letsGo;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @letsGoDescription.
  ///
  /// In en, this message translates to:
  /// **'Here\'s some tips on how to get started'**
  String get letsGoDescription;

  /// No description provided for @projectName.
  ///
  /// In en, this message translates to:
  /// **'Bluecherry'**
  String get projectName;

  /// No description provided for @projectDescription.
  ///
  /// In en, this message translates to:
  /// **'Powerful Video Surveillance Software'**
  String get projectDescription;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @purchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchase;

  /// No description provided for @tip0.
  ///
  /// In en, this message translates to:
  /// **'Cameras are shown on left. You can double-click or drag the camera into the live area to view it.'**
  String get tip0;

  /// No description provided for @tip1.
  ///
  /// In en, this message translates to:
  /// **'Use the buttons above the live view to create, save and switch layouts - even with cameras from multiple servers.'**
  String get tip1;

  /// No description provided for @tip2.
  ///
  /// In en, this message translates to:
  /// **'Double-click on a server to open its configuration page in a new window, where you can configure cameras and recordings.'**
  String get tip2;

  /// No description provided for @tip3.
  ///
  /// In en, this message translates to:
  /// **'Click the events icon to open the history and watch or save recordings.'**
  String get tip3;

  /// No description provided for @errorTextField.
  ///
  /// In en, this message translates to:
  /// **'{field} is not entered.'**
  String errorTextField(Object field);

  /// No description provided for @serverAdded.
  ///
  /// In en, this message translates to:
  /// **'Server has been added'**
  String get serverAdded;

  /// No description provided for @serverNotAddedError.
  ///
  /// In en, this message translates to:
  /// **'{serverName} could not be added. Please check the entered details.'**
  String serverNotAddedError(Object serverName);

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @removeCamera.
  ///
  /// In en, this message translates to:
  /// **'Remove Camera'**
  String get removeCamera;

  /// No description provided for @replaceCamera.
  ///
  /// In en, this message translates to:
  /// **'Replace Camera'**
  String get replaceCamera;

  /// No description provided for @reloadCamera.
  ///
  /// In en, this message translates to:
  /// **'Reload Camera'**
  String get reloadCamera;

  /// No description provided for @selectACamera.
  ///
  /// In en, this message translates to:
  /// **'Select Camera'**
  String get selectACamera;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @eventBrowser.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get eventBrowser;

  /// No description provided for @lastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last Update'**
  String get lastUpdate;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @screens.
  ///
  /// In en, this message translates to:
  /// **'Screens'**
  String get screens;

  /// No description provided for @directCamera.
  ///
  /// In en, this message translates to:
  /// **'Direct Camera'**
  String get directCamera;

  /// No description provided for @addServer.
  ///
  /// In en, this message translates to:
  /// **'Add Server'**
  String get addServer;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @noServersAdded.
  ///
  /// In en, this message translates to:
  /// **'No servers added'**
  String get noServersAdded;

  /// No description provided for @pressBackAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Press back button again to exit'**
  String get pressBackAgainToExit;

  /// No description provided for @servers.
  ///
  /// In en, this message translates to:
  /// **'Servers'**
  String get servers;

  /// No description provided for @dateFormat.
  ///
  /// In en, this message translates to:
  /// **'Date Format'**
  String get dateFormat;

  /// No description provided for @timeFormat.
  ///
  /// In en, this message translates to:
  /// **'Time Format'**
  String get timeFormat;

  /// No description provided for @nDevices.
  ///
  /// In en, this message translates to:
  /// **'{n} devices'**
  String nDevices(Object n);

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove ?'**
  String get remove;

  /// No description provided for @removeServerDescription.
  ///
  /// In en, this message translates to:
  /// **'{serverName} will be removed from the application. You\'ll not be able to view cameras from this server & will no longer receive notifications.'**
  String removeServerDescription(Object serverName);

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @versionText.
  ///
  /// In en, this message translates to:
  /// **'Copyright © 2022, Bluecherry LLC.\nAll rights reserved.'**
  String get versionText;

  /// No description provided for @snooze15.
  ///
  /// In en, this message translates to:
  /// **'15 minutes'**
  String get snooze15;

  /// No description provided for @snooze30.
  ///
  /// In en, this message translates to:
  /// **'30 minutes'**
  String get snooze30;

  /// No description provided for @snooze60.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get snooze60;

  /// No description provided for @miscellaneous.
  ///
  /// In en, this message translates to:
  /// **'Miscellaneous'**
  String get miscellaneous;

  /// No description provided for @snoozeNotifications.
  ///
  /// In en, this message translates to:
  /// **'Snooze Notifications'**
  String get snoozeNotifications;

  /// No description provided for @notSnoozed.
  ///
  /// In en, this message translates to:
  /// **'Not snoozing'**
  String get notSnoozed;

  /// No description provided for @snoozeNotificationsUntil.
  ///
  /// In en, this message translates to:
  /// **'Snooze notifications until'**
  String get snoozeNotificationsUntil;

  /// No description provided for @snoozedUntil.
  ///
  /// In en, this message translates to:
  /// **'Snoozed until {time}'**
  String snoozedUntil(Object time);

  /// No description provided for @gettingDevices.
  ///
  /// In en, this message translates to:
  /// **'Getting devices...'**
  String get gettingDevices;

  /// No description provided for @noDevices.
  ///
  /// In en, this message translates to:
  /// **'No devices'**
  String get noDevices;

  /// No description provided for @noEventsFound.
  ///
  /// In en, this message translates to:
  /// **'No events found'**
  String get noEventsFound;

  /// No description provided for @invalidResponse.
  ///
  /// In en, this message translates to:
  /// **'Invalid response received from the server'**
  String get invalidResponse;

  /// No description provided for @notificationClickAction.
  ///
  /// In en, this message translates to:
  /// **'Notification Click Action'**
  String get notificationClickAction;

  /// No description provided for @showFullscreenCamera.
  ///
  /// In en, this message translates to:
  /// **'Show fullscreen camera'**
  String get showFullscreenCamera;

  /// No description provided for @showEventsScreen.
  ///
  /// In en, this message translates to:
  /// **'Show events history'**
  String get showEventsScreen;

  /// No description provided for @addNewServer.
  ///
  /// In en, this message translates to:
  /// **'Add new server'**
  String get addNewServer;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
