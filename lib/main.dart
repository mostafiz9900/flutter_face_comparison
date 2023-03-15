import 'dart:convert';

import 'package:face_login/app/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_face_api_beta/face_api.dart' as Regula;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initPlatformState();
  runApp(const MyApp());
}

Future<void> initPlatformState() async {
  await Regula.FaceSDK.init().then((json) {
    var response = jsonDecode(json);
    if (!response["success"]) {
      print("Init failed: ");
      print(json);
    }
  });
}
