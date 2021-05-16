import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:feeling_cars_now/src/services/auth_service.dart';
import 'package:feeling_cars_now/src/user_preferences/user_preferences.dart';

class AuthBloc {
  final authService = AuthService();
  final googleSignin = GoogleSignIn(scopes: ['email']);
  final _prefs = new UserPreferences();

  /// Getter stream usuario actual.
  Stream<User> get currentUser => authService.currentUser;

  /// Hace login usando una cuenta de Google, almacena el userId, email y token
  /// en el storage del dispositivo.
  ///
  /// Devuelve true o false si hubo alguna excepción.
  Future<bool> loginWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await googleSignin.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      // Firebase Sign in
      final result = await authService.signInWithCredential(credential);

      // Almacenar datos en el storage
      _prefs.uid = result.user.uid;
      _prefs.email = result.user.email;
      _prefs.token = await result.user.getIdToken(true);

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  /// Desconecta el usuario y revoca la autenticación, llama a cerrar sesión del
  /// AuthService.
  void logout() async {
    if (googleSignin.currentUser != null) {
      await googleSignin.disconnect();
      await authService.logout();
    }
  }
}
