import 'package:app_praca_ciencia/core/styles/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Drawer(
      width: isLargeScreen ? 700 : 300,
      // ignore: deprecated_member_use
      backgroundColor: Theme.of(context).colorScheme.background,
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Image( height: 500, image: AssetImage('assets/images/LogoMenu.png')),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 15,
                  offset: const Offset(5, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildOptionsMenu('Início', '/home', 'homeIcon', context, isLargeScreen),
                _buildOptionsMenu('A Praça', '/about', 'pracaIcon', context, isLargeScreen),
                _buildOptionsMenu('Mapa', '/mapa', 'mapIcon', context, isLargeScreen),
                _buildOptionsMenu(
                  'Tour Virtual',
                  '/tour',
                  'cameraIcon',
                  context,
                   isLargeScreen
                ),
                // _buildOptionsMenu('Oficinas', '', 'oficinasIcon', context),
                _buildOptionsMenu('Agenda', '/schedule', 'agendaIcon', context, isLargeScreen),
                _buildOptionsMenu(
                  'Regras',
                  '/regulation',
                  'regrasIcon',
                  context,
                  isLargeScreen
                ),
                _buildOptionsMenu(
                  'Informações',
                  '/information',
                  'infoIcon',
                  context,
                  isLargeScreen
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Theme.of(context).colorScheme.tertiary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(
                      // ignore: use_build_context_synchronously
                      context,
                    ).pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                  child: Text(
                    'SAIR',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: isLargeScreen ? 30 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildOptionsMenu(
  String text,
  String rota,
  String pathImg,
  BuildContext context,
  isLargeScreen,
) {
  return Column(
    children: [
      ListTile(
        leading: Image(
          image: AssetImage('assets/images/$pathImg.png'),
          fit: BoxFit.cover,
        ),
        title: Text(
          text,
          style: TextStyle(fontSize:isLargeScreen ? 40 : 20, color: Theme.of(context).colorScheme.primary),
          textAlign: TextAlign.center,
        ),
        onTap: () {
          if (rota.isNotEmpty) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pushNamed(rota);
          }
        },
      ),
      Divider(color: Styles.lineBorderColor),
    ],
  );
}
