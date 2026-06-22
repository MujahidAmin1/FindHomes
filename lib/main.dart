import 'package:find_homes/core/locator.dart';
import 'package:find_homes/core/splash_screen.dart';
import 'package:find_homes/core/theme/app_theme.dart';
import 'package:find_homes/features/auth/view/auth_screen.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.light,
       home: SplashScreen(),
    );
  }
}
