import 'package:app_praca_ciencia/presentetion/pages/news_screen.dart';
import 'package:app_praca_ciencia/presentetion/pages/about_screen.dart';
import 'package:app_praca_ciencia/presentetion/pages/agenda_screen.dart';
import 'package:app_praca_ciencia/presentetion/pages/home_screen.dart';
import 'package:app_praca_ciencia/presentetion/pages/information_screen.dart';
import 'package:app_praca_ciencia/presentetion/pages/map_screen.dart';
import 'package:app_praca_ciencia/presentetion/pages/oficina_screen.dart';
import 'package:app_praca_ciencia/presentetion/pages/personal_scheduling_screen.dart';
import 'package:app_praca_ciencia/presentetion/pages/profile_screen.dart';
import 'package:app_praca_ciencia/presentetion/pages/register_screen.dart';
import 'package:app_praca_ciencia/presentetion/pages/regulation_screen.dart';
import 'package:app_praca_ciencia/presentetion/pages/splash_screen.dart';
import 'package:app_praca_ciencia/presentetion/pages/tour_screen.dart';
import 'package:app_praca_ciencia/presentetion/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('pt_BR', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],

      // Rotas
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/home': (_) => const HomeScreen(),
        '/mapa': (_) => const MapScreen(),
        '/information': (_) => const InformationScreen(),
        '/tour': (_) => const TuorScreen(),
        '/about': (_) => const AboutScreen(),
        '/regulation': (_) => const RegulationScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/register': (_) => const RegisterScreen(),
        '/login': (_) => const LoginScreen(),
        '/schedule': (_) => const AgendamentoScreen(),
        '/workshop': (_) => const OficinaScreen(),
        '/personalScheduling': (_) => const PersonalSchedulingScreen(),
        '/news': (_) => const NewsScreen(),
      },

      // Tela inicial com verificação do Firebase
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
