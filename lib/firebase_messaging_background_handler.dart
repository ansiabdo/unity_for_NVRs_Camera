/*
 * This file is a part of Bluecherry Client (https://github.com/bluecherrydvr/unity).
 *
 * Copyright 2022 Bluecherry, LLC
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 3 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:bluecherry_client/api/api.dart';
import 'package:bluecherry_client/api/api_helpers.dart';
import 'package:bluecherry_client/firebase_options.dart';
import 'package:bluecherry_client/providers/mobile_view_provider.dart';
import 'package:bluecherry_client/providers/server_provider.dart';
import 'package:bluecherry_client/providers/settings_provider.dart';
import 'package:bluecherry_client/widgets/events_screen.dart';
import 'package:bluecherry_client/widgets/device_tile.dart';
import 'package:bluecherry_client/utils/constants.dart';
import 'package:bluecherry_client/models/device.dart';

import 'package:bluecherry_client/main.dart';

/// Notification buttons are not translated.
final snooze15ButtonLabel =
    Platform.isIOS ? 'Snooze for 15 minutes' : '15 minutes';
final snooze30ButtonLabel =
    Platform.isIOS ? 'Snooze for 30 minutes' : '30 minutes';
final snooze60ButtonLabel = Platform.isIOS ? 'Snooze for 1 hour' : '1 hour';

/// Callbacks received from the [FirebaseMessaging] instance.
@pragma("vm:entry-point")
Future<void> _firebaseMessagingHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  HttpOverrides.global = DevHttpOverrides();
  await Hive.initFlutter();
  await ServersProvider.ensureInitialized();
  await SettingsProvider.ensureInitialized();
  if (SettingsProvider.instance.snoozedUntil.isAfter(DateTime.now())) {
    debugPrint(
      'SettingsProvider.instance.snoozedUntil.isAfter(DateTime.now())',
    );
    return;
  }
  debugPrint(message.toMap().toString());
  try {
    await AwesomeNotifications().initialize(
      'resource://drawable/ic_stat_linked_camera',
      [
        NotificationChannel(
          channelKey: 'com.bluecherrydvr',
          channelName: 'Bluecherry DVR',
          channelDescription: 'Bluecherry DVR Notifications',
          ledColor: Colors.white,
        )
      ],
      debug: true,
    );
    final eventType = message.data['eventType'];
    final name = message.data['deviceName'];
    final serverUUID = message.data['serverId'];
    final id = message.data['deviceId'];
    final state = message.data['state'];
    if (!APIHelpers.isValidEventType(eventType)) {
      return;
    }
    final key = Random().nextInt(pow(2, 8) ~/ 1 - 1);
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: key,
        channelKey: 'com.bluecherrydvr',
        title: APIHelpers.getEventNameFromID(eventType),
        body: [
          name,
          if (state != null) state,
        ].join(' • '),
        displayOnBackground: true,
        displayOnForeground: true,
        payload: message.data
            .map<String, String>(
              (key, value) => MapEntry(
                key,
                value.toString(),
              ),
            )
            .cast(),
      ),
      actionButtons: [
        NotificationActionButton(
          showInCompactView: true,
          label: snooze15ButtonLabel,
          key: 'snooze_15',
          actionType: ActionType.SilentBackgroundAction,
        ),
        NotificationActionButton(
          showInCompactView: true,
          label: snooze30ButtonLabel,
          key: 'snooze_30',
          actionType: ActionType.SilentBackgroundAction,
        ),
        NotificationActionButton(
          showInCompactView: true,
          label: snooze60ButtonLabel,
          key: 'snooze_60',
          actionType: ActionType.SilentBackgroundAction,
        ),
      ],
    );
    try {
      final server = ServersProvider.instance.servers
          .firstWhere((server) => server.serverUUID == serverUUID);
      final thumbnail =
          await APIHelpers.getLatestThumbnailForDeviceID(server, id);
      debugPrint(thumbnail);
      if (thumbnail != null) {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: key,
            channelKey: 'com.bluecherrydvr',
            bigPicture: thumbnail,
            title: APIHelpers.getEventNameFromID(eventType),
            body: [
              name,
              if (state != null) state,
            ].join(' • '),
            displayOnBackground: true,
            displayOnForeground: true,
            payload: message.data
                .map<String, String>(
                  (key, value) => MapEntry(
                    key,
                    value.toString(),
                  ),
                )
                .cast(),
            notificationLayout: NotificationLayout.BigPicture,
          ),
          actionButtons: [
            NotificationActionButton(
              showInCompactView: true,
              label: snooze15ButtonLabel,
              key: 'snooze_15',
              actionType: ActionType.SilentBackgroundAction,
            ),
            NotificationActionButton(
              showInCompactView: true,
              label: snooze30ButtonLabel,
              key: 'snooze_30',
              actionType: ActionType.SilentBackgroundAction,
            ),
            NotificationActionButton(
              showInCompactView: true,
              label: snooze60ButtonLabel,
              key: 'snooze_60',
              actionType: ActionType.SilentBackgroundAction,
            ),
          ],
        );
      }
    } catch (exception, stacktrace) {
      debugPrint(exception.toString());
      debugPrint(stacktrace.toString());
    }
  } catch (exception, stacktrace) {
    debugPrint(exception.toString());
    debugPrint(stacktrace.toString());
  }
}

@pragma("vm:entry-point")
Future<void> _backgroundClickAction(ReceivedAction action) async {
  await Future.delayed(const Duration(seconds: 1));
  await Firebase.initializeApp();
  HttpOverrides.global = DevHttpOverrides();
  await Hive.initFlutter();
  await ServersProvider.ensureInitialized();
  await SettingsProvider.ensureInitialized();
  debugPrint(action.toString());
  // Notification action buttons were not pressed.
  if (action.buttonKeyPressed.isEmpty) {
    debugPrint('action.buttonKeyPressed.isEmpty');
    // Fetch device & server details to show the [DeviceFullscreenViewer].
    if (SettingsProvider.instance.notificationClickAction ==
        NotificationClickAction.showFullscreenCamera) {
      final eventType = action.payload!['eventType'];
      final serverUUID = action.payload!['serverId'];
      final id = action.payload!['deviceId'];
      final name = action.payload!['deviceName'];
      // Return if same device is already playing or unknown event type is detected.
      if (_mutex == id || !APIHelpers.isValidEventType(eventType)) {
        return;
      }
      final server = ServersProvider.instance.servers
          .firstWhere((server) => server.serverUUID == serverUUID);
      final device = Device(name!, 'live/$id', true, 0, 0, server);
      final player =
          MobileViewProvider.instance.getVideoPlayerController(device);
      // No [DeviceFullscreenViewer] route is ever pushed due to notification click into the navigator.
      // Thus, push a new route.
      if (_mutex == null) {
        _mutex = id;
        await navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => DeviceFullscreenViewer(
              device: device,
              ijkPlayer: player,
              restoreStatusBarStyleOnDispose: true,
            ),
          ),
        );
        _mutex = null;
      }
      // A [DeviceFullscreenViewer] route is likely pushed before due to notification click into the navigator.
      // Thus, replace the existing route.
      else {
        navigatorKey.currentState?.pop();
        await Future.delayed(const Duration(seconds: 1));
        _mutex = id;
        await navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => DeviceFullscreenViewer(
              device: device,
              ijkPlayer: player,
              restoreStatusBarStyleOnDispose: true,
            ),
          ),
        );
        _mutex = null;
      }
      await player.release();
      await player.release();
    } else {
      if (_mutex == null) {
        _mutex = 'events_screen';
        await navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => const EventsScreen(),
          ),
        );
        _mutex = null;
      }
    }
  }
  // Any of the snooze buttons were pressed.
  else {
    debugPrint('action.buttonKeyPressed.isNotEmpty');
    final duration = Duration(
      minutes: {
        'snooze_15': 15,
        'snooze_30': 30,
        'snooze_60': 60,
      }[action.buttonKeyPressed]!,
    );
    debugPrint(DateTime.now().add(duration).toString());
    SettingsProvider.instance.snoozedUntil = DateTime.now().add(duration);
    if (action.id != null) {
      AwesomeNotifications().dismiss(action.id!);
    }
  }
}

/// Initialize & handle Firebase core & messaging plugins.
///
/// Saves entry point of application from getting unnecessarily cluttered.
///
abstract class FirebaseConfiguration {
  static Future<void> ensureInitialized() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (SettingsProvider.instance.snoozedUntil.isAfter(DateTime.now())) {
        debugPrint(
          'SettingsProvider.instance.snoozedUntil.isAfter(DateTime.now())',
        );
        return;
      }
      debugPrint(message.toMap().toString());
      try {
        final eventType = message.data['eventType'];
        final name = message.data['deviceName'];
        final serverUUID = message.data['serverId'];
        final id = message.data['deviceId'];
        final state = message.data['state'];
        if (!APIHelpers.isValidEventType(eventType)) {
          return;
        }
        final key = Random().nextInt(pow(2, 8) ~/ 1 - 1);
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: key,
            channelKey: 'com.bluecherrydvr',
            title: APIHelpers.getEventNameFromID(eventType),
            body: [
              name,
              if (state != null) state,
            ].join(' • '),
            displayOnBackground: true,
            displayOnForeground: true,
            payload: message.data
                .map<String, String>(
                  (key, value) => MapEntry(
                    key,
                    value.toString(),
                  ),
                )
                .cast(),
          ),
          actionButtons: [
            NotificationActionButton(
              showInCompactView: true,
              label: snooze15ButtonLabel,
              key: 'snooze_15',
              actionType: ActionType.SilentBackgroundAction,
            ),
            NotificationActionButton(
              showInCompactView: true,
              label: snooze30ButtonLabel,
              key: 'snooze_30',
              actionType: ActionType.SilentBackgroundAction,
            ),
            NotificationActionButton(
              showInCompactView: true,
              label: snooze60ButtonLabel,
              key: 'snooze_60',
              actionType: ActionType.SilentBackgroundAction,
            ),
          ],
        );
        try {
          final server = ServersProvider.instance.servers
              .firstWhere((server) => server.serverUUID == serverUUID);
          final thumbnail =
              await APIHelpers.getLatestThumbnailForDeviceID(server, id);
          debugPrint(thumbnail);
          if (thumbnail != null) {
            await AwesomeNotifications().createNotification(
              content: NotificationContent(
                id: key,
                channelKey: 'com.bluecherrydvr',
                bigPicture: thumbnail,
                title: APIHelpers.getEventNameFromID(eventType),
                body: [
                  name,
                  if (state != null) state,
                ].join(' • '),
                displayOnBackground: true,
                displayOnForeground: true,
                payload: message.data
                    .map<String, String>(
                      (key, value) => MapEntry(
                        key,
                        value.toString(),
                      ),
                    )
                    .cast(),
                notificationLayout: NotificationLayout.BigPicture,
              ),
              actionButtons: [
                NotificationActionButton(
                  showInCompactView: true,
                  label: snooze15ButtonLabel,
                  key: 'snooze_15',
                  actionType: ActionType.SilentBackgroundAction,
                ),
                NotificationActionButton(
                  showInCompactView: true,
                  label: snooze30ButtonLabel,
                  key: 'snooze_30',
                  actionType: ActionType.SilentBackgroundAction,
                ),
                NotificationActionButton(
                  showInCompactView: true,
                  label: snooze60ButtonLabel,
                  key: 'snooze_60',
                  actionType: ActionType.SilentBackgroundAction,
                ),
              ],
            );
          }
        } catch (exception, stacktrace) {
          debugPrint(exception.toString());
          debugPrint(stacktrace.toString());
        }
      } catch (exception, stacktrace) {
        debugPrint(exception.toString());
        debugPrint(stacktrace.toString());
      }
    });
    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (exception, stacktrace) {
      debugPrint(exception.toString());
      debugPrint(stacktrace.toString());
    }
    await AwesomeNotifications().initialize(
      'resource://drawable/ic_stat_linked_camera',
      [
        NotificationChannel(
          channelKey: 'com.bluecherrydvr',
          channelName: 'Bluecherry DVR',
          channelDescription: 'Bluecherry DVR Notifications',
          ledColor: Colors.white,
        )
      ],
      debug: true,
    );
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: _backgroundClickAction,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.onTokenRefresh.listen(
      (token) async {
        debugPrint('[FirebaseMessaging.instance.onTokenRefresh]: $token');
        final hive = await Hive.openBox('hive');
        await hive.put(
          kHiveNotificationToken,
          token,
        );
        for (final server in ServersProvider.instance.servers) {
          API.instance.registerNotificationToken(
            await API.instance.checkServerCredentials(server),
            token,
          );
        }
      },
    );
    // Sometimes [FirebaseMessaging.instance.onTokenRefresh] is not getting invoked.
    // Having this as a fallback.
    FirebaseMessaging.instance.getToken().then((token) async {
      debugPrint('[FirebaseMessaging.instance.getToken]: $token');
      if (token != null) {
        final hive = await Hive.openBox('hive');
        // Do not proceed, if token is already saved.
        if (hive.get(kHiveNotificationToken) == token) {
          return;
        }
        await hive.put(
          kHiveNotificationToken,
          token,
        );
        for (final server in ServersProvider.instance.servers) {
          API.instance.registerNotificationToken(
            await API.instance.checkServerCredentials(server),
            token,
          );
        }
      }
    });
  }
}

String? _mutex;
