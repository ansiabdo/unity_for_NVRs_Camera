


import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome => 'Welcome';

  @override
  String get welcomeDescription => 'Welcome to the Bluecherry Surveillance DVR!\nLet\'s connect to your DVR server in a few quick steps.';

  @override
  String get configure => 'Configure a DVR Server';

  @override
  String get configureDescription => 'Setup a connection to your remote DVR server';

  @override
  String get hostname => 'Hostname';

  @override
  String get port => 'Port';

  @override
  String get name => 'Name';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get savePassword => 'Save password';

  @override
  String get useDefault => 'Use Default';

  @override
  String get connect => 'Connect';

  @override
  String get connectAutomaticallyAtStartup => 'Connect automatically at startup';

  @override
  String get skip => 'Skip';

  @override
  String get cancel => 'Cancel';

  @override
  String get letsGo => 'Let\'s Go!';

  @override
  String get finish => 'Finish';

  @override
  String get letsGoDescription => 'Here\'s some tips on how to get started';

  @override
  String get projectName => 'Bluecherry';

  @override
  String get projectDescription => 'Powerful Video Surveillance Software';

  @override
  String get website => 'Website';

  @override
  String get purchase => 'Purchase';

  @override
  String get tip0 => 'Cameras are shown on left. You can double-click or drag the camera into the live area to view it.';

  @override
  String get tip1 => 'Use the buttons above the live view to create, save and switch layouts - even with cameras from multiple servers.';

  @override
  String get tip2 => 'Double-click on a server to open its configuration page in a new window, where you can configure cameras and recordings.';

  @override
  String get tip3 => 'Click the events icon to open the history and watch or save recordings.';

  @override
  String errorTextField(Object field) {
    return '$field is not entered.';
  }

  @override
  String get serverAdded => 'Server has been added';

  @override
  String serverNotAddedError(Object serverName) {
    return '$serverName could not be added. Please check the entered details.';
  }

  @override
  String get error => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get removeCamera => 'Remove Camera';

  @override
  String get replaceCamera => 'Replace Camera';

  @override
  String get reloadCamera => 'Reload Camera';

  @override
  String get selectACamera => 'Select Camera';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get eventBrowser => 'History';

  @override
  String get lastUpdate => 'Last Update';

  @override
  String get theme => 'Theme';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get screens => 'Screens';

  @override
  String get directCamera => 'Direct Camera';

  @override
  String get addServer => 'Add Server';

  @override
  String get settings => 'Settings';

  @override
  String get noServersAdded => 'No servers added';

  @override
  String get pressBackAgainToExit => 'Press back button again to exit';

  @override
  String get servers => 'Servers';

  @override
  String get dateFormat => 'Date Format';

  @override
  String get timeFormat => 'Time Format';

  @override
  String nDevices(Object n) {
    return '$n devices';
  }

  @override
  String get remove => 'Remove ?';

  @override
  String removeServerDescription(Object serverName) {
    return '$serverName will be removed from the application. You\'ll not be able to view cameras from this server & will no longer receive notifications.';
  }

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get version => 'Version';

  @override
  String get versionText => 'Copyright © 2022, Bluecherry LLC.\nAll rights reserved.';

  @override
  String get snooze15 => '15 minutes';

  @override
  String get snooze30 => '30 minutes';

  @override
  String get snooze60 => '1 hour';

  @override
  String get miscellaneous => 'Miscellaneous';

  @override
  String get snoozeNotifications => 'Snooze Notifications';

  @override
  String get notSnoozed => 'Not snoozing';

  @override
  String get snoozeNotificationsUntil => 'Snooze notifications until';

  @override
  String snoozedUntil(Object time) {
    return 'Snoozed until $time';
  }

  @override
  String get gettingDevices => 'Getting devices...';

  @override
  String get noDevices => 'No devices';

  @override
  String get noEventsFound => 'No events found';

  @override
  String get invalidResponse => 'Invalid response received from the server';

  @override
  String get notificationClickAction => 'Notification Click Action';

  @override
  String get showFullscreenCamera => 'Show fullscreen camera';

  @override
  String get showEventsScreen => 'Show events history';

  @override
  String get addNewServer => 'Add new server';
}
