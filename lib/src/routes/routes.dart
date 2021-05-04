import 'package:flutter/material.dart';

import 'package:feeling_cars_now/src/screens/home_screen.dart';
import 'package:feeling_cars_now/src/screens/login_screen.dart';
import 'package:feeling_cars_now/src/screens/edit_car_screen.dart';
import 'package:feeling_cars_now/src/screens/register_screen.dart';
import 'package:feeling_cars_now/src/screens/user_cars_screen.dart';
import 'package:feeling_cars_now/src/screens/car_details_screen.dart';
import 'package:feeling_cars_now/src/screens/preferences_screen.dart';
import 'package:feeling_cars_now/src/screens/error_report_screen.dart';
import 'package:feeling_cars_now/src/screens/find_screen.dart';
import 'package:feeling_cars_now/src/screens/faq_screen.dart';
import 'package:feeling_cars_now/src/screens/search_filters_screen.dart';

final routes = <String, WidgetBuilder>{
  'login': (_) => LoginScreen(),
  'home': (_) => HomeScreen(),
  'register': (_) => RegisterScreen(),
  'car': (_) => EditCarScreen(),
  'resume': (_) => UserCarsScreen(),
  'details': (_) => CarDetailsScreen(),
  'preferences': (_) => PreferencesScreen(),
  'error': (_) => ErrorReportScreen(),
  'search': (_) => SearchAndFiltersScreen(),
  'find': (_) => FindScreen(),
  'faq': (_) => FaqScreen()
};
