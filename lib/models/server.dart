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

import 'package:bluecherry_client/models/device.dart';

/// A [Server] added by a user.
///
class Server {
  final String name;
  final String ip;
  final int port;
  final int rtspPort;

  final String login;
  final String password;
  final bool savePassword;
  final bool connectAutomaticallyAtStartup;

  List<Device> devices = [];
  final String? serverUUID;
  final String? cookie;
  var headerList;

  Server(
    this.name,
    this.ip,
    this.port,
    this.login,
    this.password,
    this.devices, {
    this.rtspPort = 554,
    this.serverUUID,
    this.cookie,
    this.savePassword = false,
    this.connectAutomaticallyAtStartup = true,
    this.headerList,
  });

  @override
  String toString() => 'Server($name, $ip, $port, $rtspPort, $login, $password, $devices, $serverUUID, $cookie)';

  @override
  bool operator ==(dynamic other) {
    return other is Server &&
        ip == other.ip &&
        port == other.port &&
        login == other.login &&
        password == other.password &&
        rtspPort == other.rtspPort;
  }

  @override
  int get hashCode => ip.hashCode ^ port.hashCode ^ login.hashCode ^ password.hashCode ^ rtspPort.hashCode;

  Server copyWith({
    String? name,
    String? ip,
    int? port,
    int? rtspPort,
    String? login,
    String? password,
    List<Device>? devices,
    String? serverUUID,
    String? cookie,
    var headerList,
  }) {
    return Server(
      name ?? this.name,
      ip ?? this.ip,
      port ?? this.port,
      login ?? this.login,
      password ?? this.password,
      devices ?? this.devices,
      rtspPort: rtspPort ?? this.rtspPort,
      serverUUID: serverUUID ?? this.serverUUID,
      cookie: cookie ?? this.cookie,
      headerList: headerList ?? this.headerList,
    );
  }

  Map<String, dynamic> toJson({
    bool devices = true,
  }) =>
      {
        'name': name,
        'ip': ip,
        'port': port,
        'rtspPort': rtspPort,
        'login': login,
        'password': password,
        'devices': !devices ? [] : this.devices.map((e) => e.toJson()).toList(),
        'serverUUID': serverUUID,
        'cookie': cookie,
        "headerList": headerList,
      };

  factory Server.fromJson(Map<String, dynamic> json) => Server(
        json['name'],
        json['ip'],
        json['port'],
        json['login'],
        json['password'],
        json['devices'].map((e) => Device.fromJson(e)).toList().cast<Device>(),
        rtspPort: json['rtspPort'],
        serverUUID: json['serverUUID'],
        cookie: json['cookie'],
        headerList: json['headerList'],
      );
}
