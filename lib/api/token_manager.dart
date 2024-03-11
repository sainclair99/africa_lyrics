import 'dart:async';
import 'package:dio/dio.dart';

class TokenManager {
  String clientId = "5"; //Mobile app
  String clientSecret = "RpMvsz4BCbxrkYD2S6hO2SZVQXhV6e11OYzJDg3M";
  late String _token;
  bool _isLoading = false;
  String get token => _token;

  static final TokenManager _singleton = TokenManager._internal();

  factory TokenManager() {
    return _singleton;
  }
  TokenManager._internal();
  Future<String> getToken({refresh = false, username, password}) async {
    Completer _tokenCompleter = Completer<String>();
    if (_token != null && refresh == false) {
      _tokenCompleter.complete(_token);
    } else {
      var data = {
        "grant_type": "client_credentials",
        "client_id": clientId,
        "client_secret": clientSecret,
        "scope": "*"
      };

      if (username != null) {
        data["username"] = username;
        data["password"] = password;
      }
      try {
        var resp = await Dio()
            .post("https://api.afrikalyrics.com/oauth/token", data: data);
        _token = resp.data["access_token"];
        print(_token);
        _tokenCompleter.complete(_token);
      } catch (e) {
        print(e);
        _tokenCompleter.completeError(e);
      }
    }
    return _tokenCompleter.future as Future<String>;
  }
}
