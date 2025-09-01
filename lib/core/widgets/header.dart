import 'package:app_praca_ciencia/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const Header({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      iconTheme: IconThemeData(size: 40, color: Theme.of(context).colorScheme.primary),
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
          fontFamily: GoogleFonts.lato().fontFamily,
        ),
      ),
      // ignore: deprecated_member_use
      backgroundColor: Theme.of(context).colorScheme.background,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(height: 1.0, color: Color(0xFFc5c5b9)),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon( isDarkMode ? Icons.nightlight : Icons.sunny, size: 30, color: Theme.of(context).colorScheme.primary,),
          onPressed: () {
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          },
        ),
        IconButton(
          icon: Icon(Icons.account_circle, color: Theme.of(context).colorScheme.primary,),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pushNamed('/profile');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
