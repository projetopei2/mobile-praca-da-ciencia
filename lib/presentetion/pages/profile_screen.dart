import 'package:app_praca_ciencia/core/styles/styles.dart';
import 'package:app_praca_ciencia/core/widgets/calendar.dart';
import 'package:app_praca_ciencia/core/widgets/header.dart';
import 'package:app_praca_ciencia/core/widgets/login_required_dialog.dart';
import 'package:app_praca_ciencia/core/widgets/oficina_section.dart';
import 'package:app_praca_ciencia/core/widgets/visitas_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showProfile = true;
  // Inputs Desabilitados
  bool isEditing = false;

  // Controllers para os campos
  final _nomeController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _cpfController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _enderecoController = TextEditingController();

  // Mascara para cpf
  final _cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // Mascara para telefone
  final _telefoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // Mascara para Data de nascimento
  final _dataNascimentoFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // Mascara para CAP
  final _cepFormatter = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // Carregando os dados do usuário
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
          _dataNascimentoController.text = data['dataNascimento'] ?? '';
          _cpfController.text = data['cpf'] ?? '';
          _emailController.text = data['email'] ?? '';
          _telefoneController.text = data['telefone'] ?? '';
          _enderecoController.text = data['cep'] ?? '';
        });
      }
    }
  }

  // Salvando as alterações feitas nos dados do usuário
  Future<void> _saveUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'nome': _nomeController.text,
        'dataNascimento': _dataNascimentoController.text,
        'cpf': _cpfController.text,
        'email': _emailController.text,
        'telefone': _telefoneController.text,
        'cep': _enderecoController.text,
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Dados atualizados com sucesso!')));
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _dataNascimentoController.dispose();
    _cpfController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _enderecoController.dispose();
    super.dispose();
  }

  // Função do botão de editar dados do perfil que habilita os inputs
  void _toggleEditing() async {
    if (isEditing) {
      // Já estando no estado de edição será salvo os dados
      await _saveUserData();
    }

    setState(() {
      isEditing = !isEditing; // Alterna o texto do botão de editar para salvar
    });
  }

  // Função para o calendário
  Future<void> _selectDate(BuildContext context) async {
    final selectedDate = await DatePicker.showCustomDatePicker(
      context: context,
    );

    if (selectedDate != null) {
      setState(() {
        _dataNascimentoController.text = selectedDate;
      });
    }
  }

  bool _isUserAuthenticated() {
    return _auth.currentUser != null;
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // Se o usuário não estiver autenticado mostra o popup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isUserAuthenticated()) {
        showLoginRequiredDialog(
          context,
          'Faça o Login para visualizar os dados do usuário.',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: 'Perfil'),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Styles.backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20),
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.account_circle,
                size: 130,
                color: Color(0xFFFFFFFF),
              ),
            ),
            // Navegação das abas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTabButton('Dados Pessoais', showProfile, () {
                  setState(() {
                    showProfile = true;
                  });
                }),
                SizedBox(width: 10),
                _buildTabButton('Agendamentos', !showProfile, () {
                  setState(() {
                    showProfile = false;
                  });
                }),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child:
                    showProfile
                        ? _buildProfileSection()
                        : _buildAgendamentoSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, bool isSelected, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Styles.button : Colors.grey[400],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Styles.fontColor : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        _buildTextField(
          'Nome do Usuário',
          'cadProfileIcon',
          controller: _nomeController,
          readOnly: !isEditing,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          'Data de Nascimento',
          'cadDateIcon',
          controller: _dataNascimentoController,
          isDateField: true,
          readOnly: !isEditing,
          formatter: _dataNascimentoFormatter,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          'CPF',
          'cadDocIcon',
          controller: _cpfController,
          readOnly: !isEditing,
          formatter: _cpfFormatter,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          'Email',
          'cadEmailIcon',
          controller: _emailController,
          readOnly: !isEditing,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          'Telefone',
          'cadPhoneIcon',
          controller: _telefoneController,
          readOnly: !isEditing,
          formatter: _telefoneFormatter,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          'Endereço',
          'cadLocalIcon',
          controller: _enderecoController,
          readOnly: !isEditing,
          formatter: _cepFormatter,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Styles.button),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Styles.fontColor),
              ),
            ),
          ),
          onPressed: _toggleEditing,
          child: Text(
            isEditing ? 'SALVAR' : 'EDITAR',
            style: TextStyle(
              color: Styles.fontColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // build de agendamentos
  Widget _buildAgendamentoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Oficinas',
          style: TextStyle(
            color: Styles.fontColor,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 10),
        // Carrossel de Oficinas
        StreamBuilder(
          stream:
              FirebaseFirestore.instance
                  .collection('oficinas')
                  .where(
                    'lista_participantes',
                    arrayContains: FirebaseAuth.instance.currentUser!.uid,
                  )
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            if (snapshot.data!.docs.isEmpty) {
              return Text(
                'Você não está participando de nenhuma oficina!',
                style: TextStyle(color: Styles.lineBorderColor, fontSize: 16),
              );
            }
            return OficinasSection(snapshot: snapshot);
          },
        ),
        SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          child: Text(
            'Visitas',
            style: TextStyle(
              color: Styles.fontColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(height: 10),
        // Carrossel de Agendamentos
        StreamBuilder(
          stream:
              FirebaseFirestore.instance
                  .collection('agendamentos')
                  .where(
                    'id_usuario',
                    isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '',
                  )
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            if (snapshot.data!.docs.isEmpty) {
              return Text(
                'Você não está participando de nenhuma oficina!',
                style: TextStyle(color: Styles.lineBorderColor, fontSize: 16),
              );
            }
            return VisitasSection(snapshot: snapshot);
          },
        ),
      ],
    );
  }

  Widget _buildTextField(
    String hintText,
    String iconPath, {
    TextEditingController? controller,
    // Validação se o input é referente a data
    bool isDateField = false,
    // Desabilitacao e habilitacao do modo Editar
    bool readOnly = true,
    // Validação se o input contém mascara
    TextInputFormatter? formatter,
    // Tipo do Input
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
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
          child: Row(
            children: [
              Image(
                height: 30,
                image: AssetImage('assets/images/$iconPath.png'),
                fit: BoxFit.cover,
              ),
              SizedBox(width: 12),
              Container(width: 1, height: 30, color: Styles.lineBorderColor),
              SizedBox(width: 12),
              Expanded(
                child: TextField(
                  readOnly: readOnly,
                  inputFormatters: formatter != null ? [formatter] : null,
                  controller: controller,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onTap:
                      isDateField
                          ? () async =>
                              await !readOnly ? _selectDate(context) : ''
                          : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
