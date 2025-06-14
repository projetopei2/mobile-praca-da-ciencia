import 'package:app_praca_ciencia/core/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_praca_ciencia/core/styles/styles.dart';

class OficinaScreen extends StatelessWidget {
  const OficinaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final argumento = ModalRoute.of(context)?.settings.arguments as Map;
    final String? id = argumento['id'] as String?;

    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      appBar: Header(title: 'Oficina'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: StreamBuilder(
            stream:
                FirebaseFirestore.instance
                    .collection('oficinas')
                    .doc(id)
                    .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Center(
                    child: Text(
                      '${snapshot.data!['nome']}',
                      style: TextStyle(
                        color: Styles.fontColor,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Imagem
                  SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/img-carousel-2.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Localização
                  Text(
                    '${snapshot.data!['local']}',
                    style: TextStyle(
                      color: Styles.fontColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Conteúdo informativo
                  Container(
                    decoration: BoxDecoration(
                      color: Styles.backgroundContentColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Local
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 24,
                              color: Styles.fontColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${snapshot.data!['local']}',
                              style: TextStyle(
                                color: Styles.fontColor,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Horário
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 24,
                              color: Styles.fontColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${snapshot.data!['inicio_evento']}h às ${snapshot.data!['fim_evento']}h',
                              style: TextStyle(
                                color: Styles.fontColor,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Dia do evento
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 24,
                              color: Styles.fontColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${snapshot.data!['dia_evento']}',
                              style: TextStyle(
                                color: Styles.fontColor,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Limite de participantes (apenas informação)
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              size: 24,
                              color: Styles.fontColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Vagas: ${snapshot.data!['limite_participantes']}',
                              style: TextStyle(
                                color: Styles.fontColor,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Descrição
                  Text(
                    'Descrição:',
                    style: TextStyle(
                      color: Styles.fontColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.data!['descrição']}',
                    style: TextStyle(color: Styles.fontColor, fontSize: 16),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
