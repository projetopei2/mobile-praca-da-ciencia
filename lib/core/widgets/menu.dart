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
    return Drawer(
      backgroundColor: Styles.backgroundColor,
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Image(image: AssetImage('assets/images/LogoMenu.png')),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Styles.backgroundContentColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 15,
                  offset: const Offset(5, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildOptionsMenu('Início', '/home', 'homeIcon', context),
                _buildOptionsMenu('A Praça', '/about', 'pracaIcon', context),
                _buildOptionsMenu('Mapa', '/mapa', 'mapIcon', context),
                _buildOptionsMenu('Tour Virtual','/tour','cameraIcon',context,),
                // _buildOptionsMenu('Oficinas', '', 'oficinasIcon', context),
                _buildOptionsMenu('Agenda', '/schedule', 'agendaIcon', context),
                _buildOptionsMenu('Regras','/regulation','regrasIcon',context,),
                _buildOptionsMenu('Informações','/information','infoIcon',context,),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.textFieldColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                  child: Text(
                    'SAIR',
                    style: TextStyle(
                      color: Styles.fontColor,
                      fontSize: 20,
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
          style: TextStyle(fontSize: 20, color: Styles.fontColor),
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
