import 'package:app_praca_ciencia/core/styles/styles.dart';
import 'package:app_praca_ciencia/core/widgets/header.dart';
import 'package:app_praca_ciencia/core/widgets/menu.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

// A Praça
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar recebe a Widget Header que recebe a string referente ao título
      // drawer recebe a Widget Menu carregando as rotas
      appBar: Header(title: 'A Praça'),
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

          // Scroll da tela
          child: SingleChildScrollView(
            // Conteúdo
            child: Column(
              children: [
                // Título principal "Sobre nós"
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Styles.lineBorderColor),
                    ),
                  ),
                  child: Text(
                    'Sobre nós',
                    style: TextStyle(
                      fontSize: 32,
                      color: Styles.fontColor,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Campo de texto sobre a praça
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Styles.lineBorderColor),
                    ),
                  ),
                  child: _buildText(
                    'A Praça da Ciência oferece conhecimento e diversão em um local agradável, de frente para o mar, com segurança e amplo estacionamento, além da orientação de educadores durante a visita.',
                  ),
                ),
                // Título "Missão"
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: _buildTitle('Missão'),
                ),
                // Campo de texto sobre a missão da praça
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Styles.lineBorderColor),
                    ),
                  ),
                  child: _buildText(
                    'Divulgar e democratizar os conhecimentos científicos produzidos pela humanidade por meio de visitas mediadas, oficinas pedagógicas, palestras, atividades culturais e apoio aos profissionais da educação.',
                  ),
                ),
                // Título "Visão"
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: _buildTitle('Visão'),
                ),
                //Campo de texto sobre a visão
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Styles.lineBorderColor),
                    ),
                  ),
                  child: _buildText(
                    'Ser um Centro de Ciência Interativo de referência Nacional na popularização da ciência,  preservação do acervo, pesquisa, produção do conhecimento e promoção de programas educativos que fomentem a educação e a cidadania.',
                  ),
                ),
                // Campo de texto para conhecer mais sobre a praça
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: _buildText(
                    'Quer conhecer a nossa história detalhada? Clique no ícone abaixo e saiba mais!',
                  ),
                ),
                // Link para mais informações
                GestureDetector(
                  onTap:
                      () => launch(
                        "https://sites.google.com/edu.vitoria.es.gov.br/praca-da-ciencia/in%C3%ADcio?authuser=0",
                      ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image(
                        image: AssetImage('assets/images/infoIcon.png'),
                        fit: BoxFit.cover,
                      ),
                      Text(
                        'Mais informações',
                        style: TextStyle(
                          color: Styles.fontColor,
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
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
