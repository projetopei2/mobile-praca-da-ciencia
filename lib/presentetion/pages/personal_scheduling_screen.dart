import 'package:app_praca_ciencia/core/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_praca_ciencia/core/styles/styles.dart';
import 'package:intl/intl.dart';

class PersonalSchedulingScreen extends StatelessWidget {
  const PersonalSchedulingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final argumento = ModalRoute.of(context)?.settings.arguments as Map;
    final String? id = argumento['id'] as String?;

    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      appBar: Header(title: 'Agendamento'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: StreamBuilder(
            stream:
                FirebaseFirestore.instance
                    .collection('agendamentos')
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
                      DateFormat('dd/MM/yyyy').format(
                        DateTime.parse(snapshot.data?['data'] as String),
                      ),
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
                    'Informações do seu agendamento:',
                    style: TextStyle(
                      color: Styles.fontColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

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
                              Icons.calendar_month,
                              size: 24,
                              color: Styles.fontColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              DateFormat('dd/MM/yyyy').format(
                                DateTime.parse(
                                  snapshot.data?['data'] as String,
                                ),
                              ),
                              style: TextStyle(
                                color: Styles.fontColor,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
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
                              '${snapshot.data!['horario']}',
                              style: TextStyle(
                                color: Styles.fontColor,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Descrição
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Agendamento feito dia: ',
                        style: TextStyle(color: Styles.fontColor, fontSize: 18),
                      ),
                      Text(
                        DateFormat(
                          'dd/MM/yyyy',
                        ).format(snapshot.data!['criado_em'].toDate()),
                        style: TextStyle(
                          color: Styles.fontColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Botão Agendar
                  // No lugar do botão comentado, adicione este código:
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Styles.buttonCancel,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: Styles.fontColor),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () async {
                          await _cancelarAgendamento(snapshot.data!.id).then((
                            _,
                          ) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Agendamento cancelado com sucesso.',
                                ),
                              ),
                            );
                            Navigator.pop(
                              context,
                            ); // Opcional: voltar para tela anterior
                          });
                        },
                        child: Text(
                          'CANCELAR AGENDAMENTO',
                          style: TextStyle(
                            color: Styles.backgroundColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
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

  // Cancelamento de agendamento
  Future<void> _cancelarAgendamento(String id) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  await FirebaseFirestore.instance.collection('agendamentos').doc(id).update({
    'id_usuario': FieldValue.delete(), // Remove o ID do usuário
    'status': 'cancelado', // Adiciona o status de cancelado
    'cancelado_por': user.uid, // Id de quem cancelou 
    'cancelado_em': FieldValue.serverTimestamp(), // Data/hora do cancelamento
  });
}
}
