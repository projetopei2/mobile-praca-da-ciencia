import 'package:app_praca_ciencia/core/services/email_service.dart';
import 'package:app_praca_ciencia/core/styles/styles.dart';
import 'package:app_praca_ciencia/core/widgets/header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroVisitanteScreen extends StatefulWidget {
  @override
  _CadastroVisitanteScreenState createState() =>
      _CadastroVisitanteScreenState();
}

class _CadastroVisitanteScreenState extends State<CadastroVisitanteScreen> {
  int? selectedQuantity;
  DateTime? selectedDate;
  String? selectedTime;
  bool _isSendingEmail = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();

  // Mascara para cpf
  final _cepFormatter = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // Mascara para telefone
  final _telefoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _nomeController.text = data['nome'] ?? '';
          _emailController.text = data['email'] ?? '';
          _telefoneController.text = data['telefone'] ?? '';
          _cepController.text = data['cep'] ?? '';
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: 'Agendamento'),
      body: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          backgroundColor: Styles.backgroundColor,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Styles.backgroundContentColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Styles.lineBorderColor),
                          ),
                        ),
                        child: Text(
                          'Cadastro de\nvisitantes',
                          style: TextStyle(
                            color: Styles.fontColor,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Theme para remover as bordas do ExpansionTile
                      Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          initiallyExpanded: true,
                          title: Text(
                            'Protocolo de visita',
                            style: TextStyle(
                              fontSize: 24,
                              color: Styles.fontColor,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          children: [
                            _bulletList([
                              'Caso venha de bicicleta, deixe-a presa ao bicicletário;',
                              'Informe ao porteiro que agendou uma visita mediada;',
                              'Faça sua visita com a companhia de um estudante de graduação das áreas da ciência;',
                              'Se houver menores de 10 anos no grupo, é preciso estar com adulto responsável;',
                              'Proibido bebidas alcoólicas e fumo na Praça da Ciência;',
                              'Proibida a entrada sem camisa ou com trajes de banho;',
                              'Animais domésticos não são permitidos;',
                              'Festas de aniversário e piqueniques são proibidos;',
                            ]),
                          ],
                        ),
                      ),
                      _buildTitle('Dados Pessoais'),
                      _buildLabel('Nome'),
                      _buildTextFiled('Nome', controller: _nomeController),
                      _buildLabel('E-mail'),
                      _buildTextFiled(
                        'E-mail',
                        controller: _emailController,
                        validator: _validateEmail,
                      ),
                      _buildLabel('CEP'),
                      _buildTextFiled(
                        'CEP',
                        controller: _cepController,
                        keyboardType: TextInputType.number,
                        formatter: _cepFormatter,
                        validator: _validateCep,
                      ),
                      _buildLabel('Contato'),
                      _buildTextFiled(
                        'Contato',
                        controller: _telefoneController,
                        keyboardType: TextInputType.number,
                        formatter: _telefoneFormatter,
                        validator: _validateContato,
                      ),
                      const SizedBox(height: 16),
                      _buildTitle('Quantidade de pessoas'),

                      // Botões de quantidade de pessoas
                      Wrap(
                        spacing: 8,
                        children: List.generate(10, (index) {
                          return ChoiceChip(
                            label: SizedBox(
                              width: 20,
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: Styles.fontColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            selected: selectedQuantity == index + 1,
                            onSelected: (selected) {
                              setState(() {
                                selectedQuantity = selected ? index + 1 : null;
                              });
                            },
                            selectedColor: Styles.textFieldColor,
                          );
                        }),
                      ),

                      const SizedBox(height: 24),
                      _buildTitle('Escolha uma data'),

                      // Calendario
                      TableCalendar(
                        locale: 'pt_BR',
                        firstDay: DateTime.now(),
                        lastDay: DateTime.now().add(const Duration(days: 365)),
                        focusedDay: selectedDate ?? DateTime.now(),
                        headerStyle: HeaderStyle(
                          titleCentered: true,
                          formatButtonVisible: false,
                        ),
                        selectedDayPredicate:
                            (day) => isSameDay(selectedDate, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            selectedDate = selectedDay;
                          });
                        },
                        calendarStyle: const CalendarStyle(
                          // Data Selecionada
                          selectedDecoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          // Data do dia atual
                          todayDecoration: BoxDecoration(
                            color: Colors.brown,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildTitle('Escolha um horário'),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            [
                              'Manhã - 9h',
                              'Manhã - 10h',
                              'Tarde - 14h',
                              'Tarde - 15h',
                            ].map((time) {
                              return ChoiceChip(
                                label: SizedBox(
                                  width: 100,
                                  child: Text(
                                    time,
                                    style: TextStyle(
                                      color: Styles.fontColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                selected: selectedTime == time,
                                onSelected: (selected) {
                                  setState(() {
                                    selectedTime = selected ? time : null;
                                  });
                                },
                                selectedColor: Styles.textFieldColor,
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'A Praça da Ciência é um dos Centros de Ciência, Educação e Cultura da cidade de Vitória/ES, você será muito bem-vindo!',
                          style: TextStyle(
                            color: Styles.fontColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed:
                              _isSendingEmail ? null : _confirmarAgendamento,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _isSendingEmail
                                    ? Colors.grey
                                    : Styles.buttonSecond,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 16,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_isSendingEmail)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Styles.fontColor,
                                      ),
                                    ),
                                  ),
                                ),
                              Text(
                                _isSendingEmail ? 'AGUARDE...' : 'FAZER AGENDA',
                                style: TextStyle(
                                  color: Styles.fontColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmarAgendamento() async {
    if (_formKey.currentState!.validate() &&
        selectedQuantity != null &&
        selectedDate != null &&
        selectedTime != null) {
      if (selectedDate!.isBefore(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecione uma data futura.')),
        );
        return;
      }

      setState(() {
        _isSendingEmail = true;
      });

      try {
        // Verifica se o horário já está agendado para a mesma data
        final agendamentoExistente =
            await FirebaseFirestore.instance
                .collection('agendamentos')
                .where('data', isEqualTo: selectedDate!.toIso8601String())
                .where('horario', isEqualTo: selectedTime)
                .get();

        if (agendamentoExistente.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Horário indisponível para esta data.'),
            ),
          );
          return;
        }

        // Salva os dados no Firestore
        await FirebaseFirestore.instance.collection('agendamentos').add({
          'nome': _nomeController.text,
          'email': _emailController.text,
          'cep': _cepController.text,
          'contato': _telefoneController.text,
          'quantidade': selectedQuantity,
          'data': selectedDate!.toIso8601String(),
          'horario': selectedTime,
          'criado_em': FieldValue.serverTimestamp(),
          'id_usuario': FirebaseAuth.instance.currentUser!.uid,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Agendamento confirmado!')),
        );

        await _sendEmail();

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao processar agendamento: $e')),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isSendingEmail = false;
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente')),
      );
    }
  }

  Future<void> _sendEmail() async {
    try {
      // Envia e-mail para o visitante
      await EmailService.sendConfirmationToVisitor(
        visitorEmail: _emailController.text,
        visitorName: _nomeController.text,
        selectedDate: selectedDate!,
        selectedTime: selectedTime!,
        quantity: selectedQuantity!,
      );

      // Envia e-mail para a Praça da Ciência
      await EmailService.sendNotificationToPracaVisitantes(
        visitorName: _nomeController.text,
        visitorEmail: _emailController.text,
        visitorPhone: _telefoneController.text,
        selectedDate: selectedDate!,
        selectedTime: selectedTime!,
        quantity: selectedQuantity!,
        cep: _cepController.text,
      );

      print('E-mails enviados com sucesso');
    } on MailerException catch (e) {
      print('Erro ao enviar e-mails: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao enviar e-mails de confirmação')),
        );
      }
      rethrow;
    }
  }

  String? _validateEmail(String? value) {
    final emailRegex = RegExp(r"^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}");
    if (value == null || value.isEmpty) return 'Campo obrigatório';
    if (!emailRegex.hasMatch(value)) return 'E-mail inválido';
    return null;
  }

  String? _validateCep(String? value) {
    if (value == null || value.length != 9) return 'CEP deve ter 8 dígitos';
    return null;
  }

  String? _validateContato(String? value) {
    if (value == null || (value.length != 14 && value.length != 15)) {
      return 'Contato deve ter DDD + número (10 ou 11 dígitos)';
    }
    return null;
  }

  Widget _buildTitle(String title) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Styles.lineBorderColor)),
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Styles.fontColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _bulletList(List<String> items) {
    return Column(
      children:
          items.map((text) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: TextStyle(fontSize: 20, color: Styles.fontColor),
                  ),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(fontSize: 18, color: Styles.fontColor),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  // build de label com style padrão
  Widget _buildLabel(String text) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: Styles.fontColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  Widget _buildTextFiled(
    String label, {
    TextEditingController? controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    // Validação se o input contém mascara
    TextInputFormatter? formatter,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PhysicalModel(
        borderRadius: BorderRadius.circular(50),
        color: Styles.textFieldColor,
        elevation: 2,
        shadowColor: Colors.black26,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Styles.textFieldColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: formatter != null ? [formatter] : null,
            validator: validator,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(color: Styles.fontColor),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ),
    );
  }
}
