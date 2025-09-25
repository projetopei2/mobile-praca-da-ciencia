import 'package:app_praca_ciencia/core/theme/theme_provider.dart';
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
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Tela de splash
  runApp(const SplashScreen());
  // Inicalizar Dependencias do projeto
  await Future.wait([
    initializeDateFormatting('pt_BR', null),
  ]);

  // Inicia o app
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
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

      // Tela inicial sendo a de login
      home: const LoginScreen(),
      // Tema da tela referente a Dark e White mode
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
