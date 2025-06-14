import 'package:app_praca_ciencia/core/styles/styles.dart';
import 'package:app_praca_ciencia/core/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPointInformationScreen extends StatelessWidget {
  final String title;
  final String text;
  final String img;
  final String link;

  const MapPointInformationScreen({
    super.key,
    required this.title,
    required this.text,
    required this.img,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: title),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 35),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Styles.backgroundColor),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Image(
                  height: 250,
                  image: AssetImage(img),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                decoration: BoxDecoration(
                  color: Styles.backgroundContentColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 20, color: Styles.fontColor),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Styles.lineBorderColor),
                  ),
                ),
                child: Text(
                  'Quer entender melhor? Assista ao vídeo explicativo clicando no ícone abaixo!',
                  style: TextStyle(fontSize: 20, color: Styles.fontColor),
                ),
              ),
              GestureDetector(
                // Url
                onTap: () => launch(link),
                child: Container(
                  padding: EdgeInsets.only(top: 20, bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image(
                        image: AssetImage('assets/images/linkIcon.png'),
                        fit: BoxFit.cover,
                      ),
                      Text(
                        '$title\nPraça da Ciência',
                        style: TextStyle(
                          color: Styles.linkColor,
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
