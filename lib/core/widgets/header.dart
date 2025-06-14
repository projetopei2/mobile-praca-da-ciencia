import 'package:app_praca_ciencia/core/styles/styles.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const Header({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(size: 40),
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 36,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          color: Styles.fontColor
        ),
      ),
      backgroundColor: Color(0xffffffdd),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(height: 1.0, color: Color(0xFFc5c5b9)),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.account_circle, color: Color(0xff854C01),),
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
