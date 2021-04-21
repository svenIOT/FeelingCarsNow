import 'package:flutter/material.dart';

import 'package:feeling_cars_now/src/pages/home_page.dart';
import 'package:feeling_cars_now/src/pages/login_page.dart';
import 'package:feeling_cars_now/src/pages/edit_car_page.dart';
import 'package:feeling_cars_now/src/pages/register_page.dart';
import 'package:feeling_cars_now/src/pages/user_cars_page.dart';
import 'package:feeling_cars_now/src/pages/car_details_page.dart';
import 'package:feeling_cars_now/src/pages/preferences_page.dart';
import 'package:feeling_cars_now/src/pages/error_report_page.dart';
import 'package:feeling_cars_now/src/pages/find_page.dart';
import 'package:feeling_cars_now/src/pages/faq_page.dart';
import 'package:feeling_cars_now/src/pages/search_filters_page.dart';

final routes = <String, WidgetBuilder>{
  'login': (_) => LoginPage(),
  'home': (_) => HomePage(),
  'register': (_) => RegisterPage(),
  'car': (_) => EditCarPage(),
  'resume': (_) => UserCarsPage(),
  'details': (_) => CarDetailsPage(),
  'preferences': (_) => PreferencesPage(),
  'error': (_) => ErrorReportPage(),
  'search': (_) => SearchAndFiltersPage(),
  'find': (_) => FindPage(),
  'faq': (_) => FaqPage()
};
