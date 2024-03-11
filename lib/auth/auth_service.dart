import 'package:afrikalyrics_mobile/api/al_api.dart';
import 'package:afrikalyrics_mobile/api/token_manager.dart';
import 'package:afrikalyrics_mobile/service_locator.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'models/user_model.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  ALApi? _alApi;
  AuthService() {
    this._alApi = locator.get<ALApi>();
  }

  Stream<UserModel>? onAuthChanged() {
    // return _firebaseAuth.onAuthStateChanged;
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    var token = await TokenManager()
        .getToken(refresh: true, username: email, password: password);
    print(token);
    return this.getUser(token: token);
  }

  // Future<String> signInWithGoogle() async {
  //   await _googleSignIn.signOut();
  //   final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser.authentication;
  // }

  Future<void> signInWithGoogle() async {
    await _googleSignIn.signOut();
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication; 
    }
  }

  Future<bool> isSignedIn() async {
    final currentUser = await this.getCurrentUser();
    return currentUser != null;
  }

  // Future<String> signUp(
  //   String email,
  //   String password, {
  //   required String username,
  // }) async {
  //   var resp = await this._alApi?.postRequest("/");
  // }
  Future<void> signUp(
    String email,
    String password, {
    String? username,
  }) async {
    var resp = await this._alApi?.postRequest("/");
  }

  getUser({token}) async {
    Response resp = await this._alApi!.getRequest("/me", auth: true);
    print(resp);
    return UserModel.fromJson(resp.data);
  }

  Future<UserModel> getCurrentUser() async {
    Response resp = await this._alApi!.getRequest("/me");
    return UserModel.fromJson(resp.data);
  }

  Future<String> getAccessToken() async {
    return TokenManager().getToken();
  }

  Future<String> getRefreshToken() async {
    return TokenManager().getToken(refresh: true);
  }

  // Future<void> signOut() async {
  //   return Future.wait([
  //     _googleSignIn.signOut(),
  //   ]);
  // }
  Future<List<GoogleSignInAccount?>> signOut() async {
    return Future.wait([
      _googleSignIn.signOut(),
    ]);
  }
}
