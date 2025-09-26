import 'package:app_praca_ciencia/core/services/email_service.dart';
import 'package:app_praca_ciencia/core/styles/styles.dart';
import 'package:app_praca_ciencia/core/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mailer/mailer.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:table_calendar/table_calendar.dart';

class CadastroEscolasScreen extends StatefulWidget {
  const CadastroEscolasScreen({super.key});

  @override
  State<CadastroEscolasScreen> createState() => _CadastroEscolasScreenState();
}

class _CadastroEscolasScreenState extends State<CadastroEscolasScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cepController = TextEditingController();
  final _telefoneController = TextEditingController();
  bool _isSendingEmail = false;

  // Mascara para cep
  final _cepFormatter = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // Mascara para telefone
  final _telefoneFomatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  String? municipioSelecionado = 'Cariacica';
  String? qtdEstudantes = 'Até 10 estudantes';
  String? qtdAcompanhantes = '1 a 2';
  String? grupoSelecionado = 'Educação Infantil';
  String? roteiroSelecionado;
  DateTime? dataSelecionada = DateTime.now();
  String? horarioSelecionado;

  final List<String> municipios = [
    'Cariacica',
    'Guarapari',
    'Serra',
    'Viana',
    'Vila Velha',
    'Vitória',
  ];
  final List<String> opcoesEstudantes = [
    'Até 10 estudantes',
    '11 a 20 estudantes',
    '21 a 30 estudantes',
    '31 a 40 estudantes',
    '41 a 60 estudantes',
  ];
  final List<String> opcoesAcompanhantes = ['1 a 2', '3 a 4', '5 a 6', '7 a 8'];

  final List<String> roteirosInfantil = [
    'Equilibrista torto',
    'Quero ser um astronauta',
    'Alice no país das maravilhas',
    'Movimento maluco',
  ];

  final List<String> roteirosFundMedio = [
    'Astronomia e Astronáutica',
    'Diversidade de Fontes de Energia',
    'Torque e Equilíbrio no dia a dia',
    'Roteiro Ondas: comunicação e mapeamento',
    'Leis Newtonianas como marco do pensamento científico',
  ];

  // Carregando os dados do usuario nos inputs
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
    initializeDateFormatting('pt_BR', null);
    _loadUserData();
  }

  bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,4}$');
    return regex.hasMatch(email);
  }

  // Efetuar o agendamento e envio por email
  void _confirmarAgendamento() async {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final cep = _cepController.text.trim();
    final contato = _telefoneController.text.trim();

    if (nome.isEmpty ||
        email.isEmpty ||
        cep.isEmpty ||
        contato.isEmpty ||
        roteiroSelecionado == null ||
        horarioSelecionado == null ||
        dataSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente')),
      );
      return;
    }

    if (!isValidEmail(email)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('E-mail inválido')));
      return;
    }

    if (dataSelecionada!.isBefore(DateTime.now())) {
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
              .collection('agendamentos_escolas')
              .where('data', isEqualTo: dataSelecionada!.toIso8601String())
              .where('horario', isEqualTo: horarioSelecionado)
              .get();

      if (agendamentoExistente.docs.isNotEmpty) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Horário indisponível para esta data.')),
        );
        return;
      }

      // Salva os dados no Firestore
      await FirebaseFirestore.instance.collection('agendamentos_escolas').add({
        'nome': nome,
        'email': email,
        'cep': cep,
        'contato': contato,
        'municipio': municipioSelecionado,
        'qtdEstudantes': qtdEstudantes,
        'qtdAcompanhantes': qtdAcompanhantes,
        'grupo': grupoSelecionado,
        'roteiro': roteiroSelecionado,
        'data': dataSelecionada!.toIso8601String(),
        'horario': horarioSelecionado,
        'criado_em': FieldValue.serverTimestamp(),
        'id_usuario': FirebaseAuth.instance.currentUser!.uid,
      });

      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text('Agendamento confirmado!')));

      await _sendEmail();

      Future.delayed(const Duration(seconds: 2), () {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
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
  }

  Future<void> _sendEmail() async {
    setState(() {
      _isSendingEmail = true;
    });

    try {
      // Envia e-mail para a escola
      await EmailService.sendConfirmationToEscola(
        escolaEmail: _emailController.text,
        escolaName: _nomeController.text,
        selectedDate: dataSelecionada!,
        selectedTime: horarioSelecionado!,
        quantityTeachers: qtdAcompanhantes!,
        quantityStudants: qtdEstudantes!,
        roteiro: roteiroSelecionado!,
      );

      // Envia e-mail para a Praça da Ciência
      await EmailService.sendNotificationToPracaEscolas(
        visitorName: _nomeController.text,
        visitorEmail: _emailController.text,
        visitorPhone: _telefoneController.text,
        selectedDate: dataSelecionada!,
        selectedTime: horarioSelecionado!,
        quantityTeachers: qtdAcompanhantes!,
        quantityStudants: qtdEstudantes!,
        roteiro: roteiroSelecionado!,
        municipio: municipioSelecionado!,
        cep: _cepController.text,
      );

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E-mail de Confirmação enviado com sucesso!'),
        ),
      );
    // ignore: unused_catch_clause
    } on MailerException catch (e) {
      // print('Erro ao enviar e-mails: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao enviar e-mail'),
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao enviar e-mail de confirmação')),
        );
      }
      rethrow;
    } finally {
      setState(() {
        _isSendingEmail = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior
      appBar: Header(title: 'Agendamento'),
      // Tela toda
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        decoration: BoxDecoration(color: Styles.backgroundColor),
        // Conteudo da tela
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Styles.backgroundContentColor,
            borderRadius: BorderRadius.circular(30),
          ),
          // Scroll
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titulo principal
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Styles.lineBorderColor),
                    ),
                  ),
                  child: Text(
                    'Cadastro de\nescolas',
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
                    // Lista de protocolos
                    children: [
                      _bulletList([
                        'Caso tenha interesse em compor um roteiro personalizado, entre em contato com a Praça da Ciência de Vitória, por e-mail ou telefone, e realize um planejamento pedagógico integrado.',
                        'Sugerimos uso de boné, filtro solar e garrafinhas de água.',
                        'Recomendamos uso de repelente para os alérgicos.',
                        'Os estudantes estão autorizados a lancharem no espaço. É preciso trazer o lanche, pois não há cantina ou estabelecimentos comerciais vizinhos.',
                        'Em caso de atrasos, a visita poderá sofrer alterações.',
                        'Solicitamos que os educadores acompanhem os estudantes durante a mediação das visitas. Lembremos que promovemos uma visita de estudos, assim precisamos da colaboração dos profissionais da unidade de ensino para melhor aproveitamento das atividades.',
                      ]),
                    ],
                  ),
                ),

                // Titulo Dados Pessoais
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
                  formatter: _telefoneFomatter,
                  validator: _validateContato,
                ),

                // Titulo para municipios
                _buildTitle('Município da Instituição de Ensino'),
                // Lista de Municipios
                ...municipios.map(
                  (m) => RadioListTile(
                    activeColor: Styles.fontColor,
                    title: Text(
                      m,
                      style: TextStyle(
                        color: Styles.fontColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: m,
                    groupValue: municipioSelecionado,
                    onChanged:
                        (value) => setState(
                          () => municipioSelecionado = value.toString(),
                        ),
                  ),
                ),

                // Titulo quantidade de estudantes
                _buildTitle('Quantidade de estudantes'),
                // Lista de quantidade de alunos
                ...opcoesEstudantes.map(
                  (e) => RadioListTile(
                    activeColor: Styles.fontColor,
                    title: Text(
                      e,
                      style: TextStyle(
                        color: Styles.fontColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: e,
                    groupValue: qtdEstudantes,
                    onChanged:
                        (value) =>
                            setState(() => qtdEstudantes = value.toString()),
                  ),
                ),

                // Titulo Acompanhantes
                _buildTitle('Quantidade de acompanhantes'),
                // Lista de Quantidade de alunos
                ...opcoesAcompanhantes.map(
                  (e) => RadioListTile(
                    activeColor: Styles.fontColor,
                    title: Text(
                      e,
                      style: TextStyle(
                        color: Styles.fontColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: e,
                    groupValue: qtdAcompanhantes,
                    onChanged:
                        (value) =>
                            setState(() => qtdAcompanhantes = value.toString()),
                  ),
                ),

                // Titulo Tipo de Grupo
                _buildTitle('Tipo de Grupo'),
                // Lista de Tipo de grupo
                RadioListTile(
                  activeColor: Styles.fontColor,
                  title: Text(
                    'Educação Infantil',
                    style: TextStyle(
                      color: Styles.fontColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  value: 'Educação Infantil',
                  groupValue: grupoSelecionado,
                  onChanged:
                      (value) => setState(() {
                        grupoSelecionado = value.toString();
                        roteiroSelecionado = null;
                      }),
                ),
                RadioListTile(
                  activeColor: Styles.fontColor,
                  title: Text(
                    'Ensino Fundamental / Médio / Profissionais',
                    style: TextStyle(
                      color: Styles.fontColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  value: 'FundMedio',
                  groupValue: grupoSelecionado,
                  onChanged:
                      (value) => setState(() {
                        grupoSelecionado = value.toString();
                        roteiroSelecionado = null;
                      }),
                ),

                // Titulo Roteiro
                _buildTitle('Roteiro'),
                // Lista de Roteiros
                ...((grupoSelecionado == 'Educação Infantil')
                        ? roteirosInfantil
                        : roteirosFundMedio)
                    .map(
                      (r) => RadioListTile(
                        activeColor: Styles.fontColor,
                        title: Text(
                          r,
                          style: TextStyle(
                            color: Styles.fontColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: r,
                        groupValue: roteiroSelecionado,
                        onChanged:
                            (value) => setState(
                              () => roteiroSelecionado = value.toString(),
                            ),
                      ),
                    ),

                // Titulo Escolha uma data
                _buildTitle('Escolha uma data'),
                TableCalendar(
                  locale: 'pt_BR',
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                  ),
                  focusedDay: dataSelecionada!,
                  selectedDayPredicate:
                      (day) => isSameDay(dataSelecionada, day),
                  onDaySelected:
                      (selectedDay, focusedDay) =>
                          setState(() => dataSelecionada = selectedDay),
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

                // Titulo Escolha um horario
                _buildTitle('Escolha um horário'),
                // lista de horarios
                Text('Manhã'),
                RadioListTile(
                  activeColor: Styles.fontColor,
                  title: Text(
                    '8 horas (Terça-Domingo)',
                    style: TextStyle(
                      color: Styles.fontColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  value: '8h',
                  groupValue: horarioSelecionado,
                  onChanged:
                      (v) => setState(() => horarioSelecionado = v.toString()),
                ),
                RadioListTile(
                  activeColor: Styles.fontColor,
                  title: Text(
                    '9h30min (Terça-Domingo)',
                    style: TextStyle(
                      color: Styles.fontColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  value: '9h30',
                  groupValue: horarioSelecionado,
                  onChanged:
                      (v) => setState(() => horarioSelecionado = v.toString()),
                ),
                Text('Tarde'),
                RadioListTile(
                  activeColor: Styles.fontColor,
                  title: Text(
                    '13h30min (Terça-Sexta)',
                    style: TextStyle(
                      color: Styles.fontColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  value: '13h30',
                  groupValue: horarioSelecionado,
                  onChanged:
                      (v) => setState(() => horarioSelecionado = v.toString()),
                ),
                RadioListTile(
                  activeColor: Styles.fontColor,
                  title: Text(
                    '15 horas (Terça-Sexta)',
                    style: TextStyle(
                      color: Styles.fontColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  value: '15h',
                  groupValue: horarioSelecionado,
                  onChanged:
                      (v) => setState(() => horarioSelecionado = v.toString()),
                ),

                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _isSendingEmail ? null : _confirmarAgendamento,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isSendingEmail ? Colors.grey : Styles.buttonSecond,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// build de listas com seus estilos padrao
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

// build para os titulos com seus estilos padrao
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

// build para os inputs com seus estilos padrao
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
