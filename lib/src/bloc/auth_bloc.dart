import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:feeling_cars_now/src/services/auth_service.dart';
import 'package:feeling_cars_now/src/user_preferences/user_preferences.dart';

class AuthBloc {
  final authService = AuthService();
  final googleSignin = GoogleSignIn(scopes: ['email']);
  final _prefs = new UserPreferences();

  Stream<User> get currentUser => authService.currentUser;

  Future<bool> loginWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await googleSignin.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      // Firebase Sign in
      final result = await authService.signInWithCredential(credential);

      _prefs.uid = result.user.uid;
      _prefs.token = googleAuth.idToken;

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  void logout() {
    authService.logout();
  }
}
