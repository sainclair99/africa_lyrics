import 'package:afrikalyrics_mobile/api/al_api.dart';
import 'package:afrikalyrics_mobile/service_locator.dart';

class AuthService {
  String clientId = "";
  String clientSecret = "";
  final ALApi _alApi = locator.get<ALApi>(); // ! init here and add final
  AuthService() {
    // ! _alApi = locator.get<ALApi>();
  }

  loginClient() {
    return this._alApi.postRequest("/oauth/token", auth: false);
  }
}
