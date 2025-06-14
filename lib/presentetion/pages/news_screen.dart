import 'package:app_praca_ciencia/core/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_praca_ciencia/core/styles/styles.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final argumento = ModalRoute.of(context)?.settings.arguments as Map;
    final String? id = argumento['id'] as String?;

    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      appBar: Header(title: 'Noticias'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: StreamBuilder(
            stream:
                FirebaseFirestore.instance
                    .collection('noticias')
                    .doc(id)
                    .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
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
                  SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/${snapshot.data!['image']}',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              size: 24,
                              color: Styles.fontColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Publicada em ${snapshot.data!['data_publicacao']}',
                              style: TextStyle(
                                color: Styles.fontColor,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 24,
                              color: Styles.fontColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${snapshot.data!['autor']}',
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
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      '${snapshot.data!['nome']}',
                      style: TextStyle(
                        color: Styles.fontColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${snapshot.data!['descricao']}',
                    style: TextStyle(color: Styles.fontColor, fontSize: 18),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
