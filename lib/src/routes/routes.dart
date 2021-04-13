import 'package:flutter/material.dart';

import 'package:form_validation/src/pages/home_page.dart';
import 'package:form_validation/src/pages/login_page.dart';
import 'package:form_validation/src/pages/product_page.dart';
import 'package:form_validation/src/pages/register_page.dart';
import 'package:form_validation/src/pages/resume_page.dart';

final routes = <String, WidgetBuilder>{
  'login': (_) => LoginPage(),
  'home': (_) => HomePage(),
  'register': (_) => RegisterPage(),
  'product': (_) => ProductPage(),
  'resume': (_) => ResumePage()
};
