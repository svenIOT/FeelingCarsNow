import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'src/user_preferences/user_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:feeling_cars_now/src/bloc/auth_bloc.dart';
import 'package:feeling_cars_now/src/bloc/provider.dart' as myProvider;
import 'package:feeling_cars_now/src/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPreferences();
  await prefs.initPrefs();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AuthBloc(),
      child: myProvider.Provider(
        child: MaterialApp(
          title: 'Material App',
          debugShowCheckedModeBanner: false,
          initialRoute: 'login',
          routes: routes,
          theme: ThemeData(primaryColor: Colors.deepPurple),
        ),
      ),
    );
  }
}
