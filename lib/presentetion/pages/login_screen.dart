import 'package:app_praca_ciencia/core/services/auth_service.dart';
import 'package:app_praca_ciencia/core/styles/styles.dart';
import 'package:app_praca_ciencia/presentetion/pages/forgot_password.dart';
import 'package:app_praca_ciencia/presentetion/pages/register_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final AuthService authService = AuthService();

  // Visualizar senha
  bool _obscurePassword = true;

  Future<void> _handleLoginWithEmailPassword(BuildContext context) async {
    if (emailController.text.isEmpty || senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos.')),
      );
      return;
    }

    try {
      await authService.loginWithEmailPassword(
        emailController.text,
        senhaController.text,
      );
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      await authService.signInWithGoogle();
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        decoration: BoxDecoration(color: Styles.backgroundColor),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Bem-Vindo(a),',
                  style: TextStyle(
                    fontSize: 36,
                    color: Styles.fontColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Image(
                  height: 160,
                  image: AssetImage('assets/images/logoLogin.png'),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Styles.backgroundContentColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 15,
                      offset: const Offset(5, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'ENTRAR',
                      style: TextStyle(
                        fontSize: 24,
                        color: Styles.fontColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildLabel('E-MAIL'),
                    _buildTextField(
                      controller: emailController,
                      hint: 'Digite seu e-mail',
                    ),
                    _buildLabel('SENHA'),
                    _buildTextField(
                      controller: senhaController,
                      hint: 'Digite sua senha',
                      isPassword: true,
                      obscurePassword: _obscurePassword,
                      toggleObscurePassword: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),

                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Esqueci minha senha',
                          style: TextStyle(
                            fontSize: 15,
                            color: Styles.fontColor,
                          ),
                        ),
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.textFieldColor,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                      ),
                      onPressed: () => _handleLoginWithEmailPassword(context),
                      child: Text(
                        'ENTRAR',
                        style: TextStyle(
                          color: Styles.fontColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 100,
                          height: 3,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Styles.lineBorderColor),
                            ),
                          ),
                        ),
                        Text('OU'),
                        Container(
                          width: 100,
                          height: 3,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Styles.lineBorderColor),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),
                    Text(
                      'Entre com sua conta Google',
                      style: TextStyle(fontSize: 15, color: Styles.fontColor),
                    ),

                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.textFieldColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () => _handleGoogleSignIn(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image(
                            image: AssetImage('assets/images/iconGmail.png'),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'GMAIL',
                            style: TextStyle(
                              fontSize: 14,
                              color: Styles.fontColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => RegisterScreen()),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Não possui conta?',
                              style: TextStyle(
                                fontSize: 15,
                                color: Styles.fontColor,
                              ),
                            ),
                            Text(
                              'Cadastre-se aqui',
                              style: TextStyle(
                                fontSize: 15,
                                color: Styles.fontColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 5),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/home');
                      },
                      child: Text(
                        'ACESSAR COMO VISITANTE',
                        style: TextStyle(
                          fontSize: 15,
                          color: Styles.fontColor,
                          fontWeight: FontWeight.bold,
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
    );
  }
}

// build de label com style padrão
Widget _buildLabel(String text) {
  return SizedBox(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 15, color: Styles.fontColor),
        textAlign: TextAlign.start,
      ),
    ),
  );
}

// build de input com style padrão
Widget _buildTextField({
  required TextEditingController controller,
  required String hint,
  bool isPassword = false,
  bool? obscurePassword, // Novo parâmetro
  VoidCallback? toggleObscurePassword, // Novo parâmetro
}) {
  return PhysicalModel(
    borderRadius: BorderRadius.circular(50),
    color: Styles.textFieldColor,
    child: TextField(
      controller: controller,
      obscureText: isPassword ? (obscurePassword ?? true) : false,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Styles.textFieldColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    (obscurePassword ?? true)
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Styles.fontColor,
                  ),
                  onPressed: toggleObscurePassword,
                )
                : null,
      ),
    ),
  );
}
