import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{}; // ! added <int, Color> to Map type
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

extractMessage(var e, {String defaultMessage = 'Failure'}) {
  String message = "failure";

  print(e.runtimeType);

  try {
    if (e is SocketException) {
      return "Check Your internet";
    } else if (e is DioError) {
      try {
        var details = e.response?.data['details']; // ! added "?" symbol safety before .data
        if (details is List) {
          message = "";
          for (var i = 0; i < details.length; i++) {}
          details.forEach((d) {
            message += d['message'] + "\n";
          });
          return message;
        } else {
          if (e.message != null) {
            return e.message;
          }
          message = e.response
                  ?.data['details'] ?? // ! added "?" symbol safety before .data
              e.response?.data['message'] ?? // ! added "?" symbol safety before .data
              e.response?.statusMessage ?? // ! added "?" symbol safety before .statusMessage
              defaultMessage;
        }
      } catch (error) {
        return e.response?.statusMessage ?? e.message;
      }
    } else if (e is PlatformException) {
      message = '${e.message}';
    } else {
      if (e?.message != null) {
        message = e.message;
      } else {
        message = e.toString();
      }
    }
  } catch (e) {
    print(e);
    return message;
  }
  return message;
}

formatSongDuration(var duration) {
  int dur = int.parse("$duration");
  var fin = Duration(milliseconds: dur);
  return "${twoDigits(fin.inMinutes)}:${fin.inSeconds % 60}";
}

String twoDigits(int n) {
  if (n >= 10) return "$n";
  return "0$n";
}
