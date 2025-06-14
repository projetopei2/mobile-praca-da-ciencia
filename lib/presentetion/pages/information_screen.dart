import 'package:app_praca_ciencia/core/styles/styles.dart';
import 'package:app_praca_ciencia/core/widgets/header.dart';
import 'package:app_praca_ciencia/core/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Informações
class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar recebe a Widget Header que recebe a string referente ao titulo
      // drawer recebe a Widget Menu carregando as rotas
      appBar: Header(title: 'Informações'),
      drawer: Menu(),

      // Toda a tela
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        decoration: BoxDecoration(color: Styles.backgroundColor),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          decoration: BoxDecoration(
            color: Styles.backgroundContentColor,
            borderRadius: BorderRadius.circular(30),
          ),

          // Scroll da Tela
          child: SingleChildScrollView(
            // Conteúdo
            child: Column(
              children: [
                // Titulo principal "Praça da Ciência"
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Styles.lineBorderColor),
                    ),
                  ),
                  child: Text(
                    'Praça da \nCiência',
                    style: TextStyle(
                      fontSize: 32,
                      color: Styles.fontColor,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Título "Venha nos visitar"
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: _buildTitle('Venha nos visitar'),
                ),
                // Link de localização da praça
                GestureDetector(
                  onTap:
                      () => launch("https://maps.app.goo.gl/STkJjj8dZKmTAAZV6"),
                  child: SizedBox(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Image(
                            image: AssetImage('assets/images/pointIcon.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: _buildText(
                            'Av. Américo Buaiz, s/n, Enseada do Suá, Vitória - ES',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Texto com os horários de atendimento
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Styles.lineBorderColor),
                    ),
                  ),
                  child: Expanded(
                    child: Text(
                      'Atendimento ao público de 8h às 12h e 13h às 17h (Terça a Sexta) e 8h às  12h (Sábado e Domingo)',
                      style: TextStyle(
                        fontSize: 17,
                        color: Styles.fontColor,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.justify,
                      softWrap:
                          true, // Isso permite a quebra de linha (é true por padrão)
                    ),
                  ),
                ),
                // Título "Links úteis"
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: _buildTitle('Links úteis'),
                ),
                // Links referentes as redes sociais da praça
                SizedBox(
                  child: Column(
                    children: [
                      // Link para o Facebook
                      GestureDetector(
                        onTap:
                            () => launch(
                              "https://www.facebook.com/people/Pra%C3%A7a-da-Ci%C3%AAncia/100063598627380/#",
                            ),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: 10),
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/facebookIcon.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              _buildText('Praça da Ciência'),
                            ],
                          ),
                        ),
                      ),
                      // Link para o Instagram
                      GestureDetector(
                        onTap:
                            () => launch(
                              "https://www.instagram.com/ciencia.vix/",
                            ),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/instagramIcon.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              _buildText('@ciencia_vix'),
                            ],
                          ),
                        ),
                      ),
                      // Link para o WebSite
                      GestureDetector(
                        onTap:
                            () => launch(
                              "https://sites.google.com/edu.vitoria.es.gov.br/praca-da-ciencia/in%C3%ADcio?authuser=0",
                            ),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/siteIcon.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              _buildText('@ciencia_vix'),
                            ],
                          ),
                        ),
                      ),
                      // Link para o canal do Youtube
                      GestureDetector(
                        onTap:
                            () =>
                                launch("https://www.youtube.com/@ciencia_vix"),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/youtubeIcon.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              _buildText('@ciencia_vix'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// build do Título com seu estilo padrão
Widget _buildTitle(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 24,
      color: Styles.fontColor,
      fontWeight: FontWeight.bold,
    ),
    textAlign: TextAlign.center,
  );
}

// build do texto com seu estilo padrão
Widget _buildText(String text) {
  return Text(text, style: TextStyle(fontSize: 20, color: Styles.fontColor));
}
