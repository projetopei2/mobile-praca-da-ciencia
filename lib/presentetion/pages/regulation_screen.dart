import 'package:app_praca_ciencia/core/styles/styles.dart';
import 'package:app_praca_ciencia/core/widgets/header.dart';
import 'package:app_praca_ciencia/core/widgets/menu.dart';
import 'package:flutter/material.dart';

// Regulamentos
class RegulationScreen extends StatelessWidget {
  const RegulationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar recebe a Widget Header que recebe a string referente ao titulo
      // drawer recebe a Widget Menu carregando as rotas
      appBar: Header(title: 'Regulamentos'),
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
                // Título principal "Bem vindo(a) aos regulamentos da Praça da Ciência"
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Styles.lineBorderColor),
                    ),
                  ),
                  child: Text(
                    'Bem vindo (a) aos regulamentos da Praça da Ciência',
                    style: TextStyle(
                      fontSize: 32,
                      color: Styles.fontColor,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Texto com a apresentação das regras
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Styles.lineBorderColor),
                    ),
                  ),
                  child: _buildText(
                    'Assim como diversos espaços públicos, a Praça da Ciência conta com códigos de vestimentas e convivência, siga nosso regulamento para uma visita bastante proveitosa.',
                  ),
                ),
                // Título "Não é permitido"
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: _buildTitle('Não é permitido'),
                ),
                // Lista referente ao que não é permitido
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Styles.lineBorderColor),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Alinha à esquerda
                    children: [
                      _buildListItem("Pessoas sem camisa ou traje de banho;"),
                      _buildListItem("Bicicletas (use o bicicletário);"),
                      _buildListItem(
                        "Menores da 10 anos desacompanhados dos responsáveis;",
                      ),
                      _buildListItem("Animais domésticos;"),
                      _buildListItem(
                        "Usar patinetes, patins, skates, brinquedos motorizados ou similares;",
                      ),
                      _buildListItem(
                        "Festas de aniversário, piquiniques e consumo de bebidas alcoólicas;",
                      ),
                      _buildListItem("Fumar;"),
                    ],
                  ),
                ),
                // Título "Orientações para o uso dos equipamentos pedagógicos"
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: _buildTitle(
                    'Orientações para o uso dos equipamentos pedagógicos',
                  ),
                ),
                // Lista de orientações para uso dos equipamentos
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildListItem("Leitura das placas dos equipamentos;"),
                      _buildListItem(
                        "Observação quanto às restrições de uso incluindo peso, altura e calçado adequado;",
                      ),
                      _buildListItem("Seguir as orientações dos mediadores."),
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

// build da lista com seu estilo padrão
Widget _buildListItem(String text) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "• ",
          style: TextStyle(fontSize: 20, color: Styles.fontColor),
        ), // Marcador
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 20, color: Styles.fontColor),
          ),
        ),
      ],
    ),
  );
}
