import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/user_preferences/user_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'package:feeling_cars_now/src/bloc/auth_bloc.dart';
import 'package:feeling_cars_now/src/routes/routes.dart';
import 'package:feeling_cars_now/src/bloc/provider.dart' as myProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPreferences();
  await prefs.initPrefs();
  await DotEnv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final prefs = new UserPreferences();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AuthBloc(),
      child: myProvider.Provider(
        child: MaterialApp(
            title: 'Material App',
            debugShowCheckedModeBanner: false,
            initialRoute: prefs.lastScreen,
            routes: routes,
            theme: ThemeData(
                primaryColor: (prefs.secondaryColor)
                    ? Colors.grey[800]
                    : Colors.deepPurple)),
      ),
    );
  }
}
