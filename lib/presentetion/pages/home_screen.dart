import 'package:app_praca_ciencia/core/widgets/carrossel.dart';
import 'package:app_praca_ciencia/core/widgets/header.dart';
import 'package:app_praca_ciencia/core/widgets/menu.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Responsividade
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      // Header da pagina
      appBar: Header(title: 'Bem Vindo(a)'),
      // Menu lateral
      drawer: Menu(),
      // Scroll da pagina
      body: SingleChildScrollView(
        // corpo da pagina
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          // Altura do app ocupando toda a tela
          height: MediaQuery.of(context).size.height,
          // Configurações de tema
          // ignore: deprecated_member_use
          color: Theme.of(context).colorScheme.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Carrossel para testes
              Container(
                padding: EdgeInsets.all(isLargeScreen ? 30 : 0),
                child: Carrossel()),
              SizedBox(height: 20),

              // Titulo Oficinas
              Text(
                'Oficinas',
                style: TextStyle(
                  // Configurações de tema
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: isLargeScreen ? 40 : 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 10),

              // Stream que carrega os dados vindo da tebela oficinas e mostra em um carrossel
              // StreamBuilder(
              //   stream:
              //       FirebaseFirestore.instance
              //           .collection('oficinas')
              //           .snapshots(),
              //   builder: (context, snapshot) {
              //     // Carrossel de Oficinas
              //     return OficinasSection(snapshot: snapshot);
              //   },
              // ),
              SizedBox(height: 20),

              // Titulo Noticias
              Text(
                'Noticias',
                style: TextStyle(
                  // Configurações de tema
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: isLargeScreen ? 40 : 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 10),

              // Stream que carrega os dados vindo da tebela noticias e mostra em um carrossel
              // StreamBuilder(
              //   stream:
              //       FirebaseFirestore.instance
              //           .collection('noticias')
              //           .snapshots(),
              //   builder: (context, snapshot) {
              //     // Carrossel de Noticias
              //     return NewsSection(snapshot: snapshot);
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
