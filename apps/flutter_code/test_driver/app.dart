import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_code/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  enableFlutterDriverExtension();

  //app.main();
  runApp(app.OptionsPageStateful()); // Alternative
}