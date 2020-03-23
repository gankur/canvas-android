// Copyright (C) 2020 - present Instructure, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, version 3 of the License.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_student_embed/models/login.dart';
import 'package:flutter_student_embed/models/serializers.dart';
import 'package:flutter_student_embed/network/utils/api_prefs.dart';

class NativeComm {
  static const channelName = 'com.instructure.student/flutterComm';
  static const methodRequestLoginData = 'requestLoginData';
  static const methodUpdateLoginData = 'updateLoginData';

  static const channel = const MethodChannel(channelName);

  static void init() {
    channel.setMethodCallHandler((methodCall) async {
      switch (methodCall.method) {
        case methodUpdateLoginData:
          _updateLogin(methodCall.arguments);
          break;
        default:
          throw 'Channel method not implemented: ${methodCall.method}';
      }
    });
  }

  static Future<void> requestLoginDataSync() async {
    await channel.invokeMethod(methodRequestLoginData);
  }

  static void _updateLogin(dynamic loginData) {
    if (loginData == null) {
      ApiPrefs.setLogin(null);
      return;
    }
    try {
      Login login = deserialize<Login>(json.decode(loginData));
      ApiPrefs.setLogin(login);
    } catch (e) {
      print(e.runtimeType);
      print('Error updating login: $e');
      if (e is Error) print(e.stackTrace);
    }
  }
}
