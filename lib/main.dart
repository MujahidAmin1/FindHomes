import 'package:find_homes/core/locator.dart';
import 'package:find_homes/core/services/onesignal_service.dart';
import 'package:find_homes/core/splash_screen.dart';
import 'package:find_homes/core/theme/app_theme.dart';
import 'package:find_homes/core/widgets/onesignal_verification_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await setupServiceLocator();

  // Initialize OneSignal SDK with provided App ID via central wrapper service
  serviceLocator<OneSignalService>()
      .initialize('1cb6f1a1-0c65-4766-92c8-612d4b346b65');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Find Homes',
      theme: AppTheme.light,
      home: const OneSignalVerificationListener(
        child: SplashScreen(),
      ),
    );
  }
}
