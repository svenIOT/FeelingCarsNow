import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = new UserPreferences._internal();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET tipo de cuenta
  get accountType => _prefs.getInt('genre') ?? 1;

  set accountType(int value) => _prefs.setInt('genre', value);

  // GET y SET color secundario
  get secondaryColor => _prefs.getBool('secondaryColor') ?? false;

  set secondaryColor(bool value) => _prefs.setBool('secondaryColor', value);

  // GET y SET del uid
  get uid => _prefs.getString('uid') ?? '';

  set uid(String value) => _prefs.setString('uid', value);

  // GET y SET del email
  get email => _prefs.getString('email') ?? '';

  set email(String value) => _prefs.setString('email', value);

  // GET y SET del username
  get username => _prefs.getString('name') ?? '';

  set username(String value) => _prefs.setString('name', value);

  // GET y SET del token
  get token => _prefs.getString('token') ?? '';

  set token(String value) => _prefs.setString('token', value);

  // GET y SET de la última página
  get lastPage => _prefs.getString('lastPage') ?? 'login';

  set lastPage(String value) => _prefs.setString('lastPage', value);

  /// Elimina del storage el userId, email y token del usuario actual.
  void clearUserPreferences() {
    uid = "";
    email = "";
    token = "";
  }
}
