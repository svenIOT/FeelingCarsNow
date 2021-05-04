import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:feeling_cars_now/src/providers/auth_provider.dart';
import 'package:feeling_cars_now/src/user_preferences/user_preferences.dart';

class AuthBloc {
  final authProvider = AuthProvider();
  final googleSignin = GoogleSignIn(scopes: ['email']);
  final _prefs = new UserPreferences();

  Stream<User> get currentUser => authProvider.currentUser;

  Future<bool> loginWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await googleSignin.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      // Firebase Sign in
      final result = await authProvider.signInWithCredential(credential);
      print('${result.user.displayName}');

      _prefs.token = googleAuth.idToken;
      print('${googleAuth.idToken}');
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  void logout() {
    authProvider.logout();
  }
}
