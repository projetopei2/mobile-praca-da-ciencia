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
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      await authService.signInWithGoogle();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Responsividade
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: Theme.of(context).colorScheme.background,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Bem-Vindo(a),',
                  style: TextStyle(
                    fontSize: isLargeScreen ? 50 : 36,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              isLargeScreen ? SizedBox(height: 100) : Container(),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Image(
                  height: isLargeScreen ? 300 : 160,
                  image: AssetImage('assets/images/logoLogin.png'),
                  fit: BoxFit.cover,
                ),
              ),
              isLargeScreen ? SizedBox(height: 100) : Container(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
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
                        fontSize: isLargeScreen ? 40 : 24,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildLabel('E-MAIL', context, isLargeScreen),
                    _buildTextField(
                      controller: emailController,
                      hint: 'Digite seu e-mail',
                      context: context,
                      isLargeScreen: isLargeScreen,
                    ),
                    _buildLabel('SENHA', context, isLargeScreen),
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
                      context: context,
                      isLargeScreen: isLargeScreen,
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
                            fontSize: isLargeScreen ? 24 : 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        padding:
                            isLargeScreen
                                ? EdgeInsets.symmetric(
                                  horizontal: 60,
                                  vertical: 12,
                                )
                                : EdgeInsets.symmetric(horizontal: 30),
                      ),
                      onPressed: () => _handleLoginWithEmailPassword(context),
                      child: Text(
                        'ENTRAR',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: isLargeScreen ? 30 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Divider(
                            color: Styles.lineBorderColor,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            'OU',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: isLargeScreen ? 24 : 16,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Styles.lineBorderColor,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),
                    Text(
                      'Entre com sua conta Google',
                      style: TextStyle(
                        fontSize: isLargeScreen ? 24 : 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        padding: EdgeInsets.symmetric(
                          horizontal: isLargeScreen ? 60 : 20,
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
                              fontSize: isLargeScreen ? 24 : 14,
                              color: Theme.of(context).colorScheme.primary,
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
                        child: Text(
                          'Não possui conta? Cadastre-se aqui!',
                          style: TextStyle(
                            fontSize: isLargeScreen ? 24 : 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
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
                          fontSize: isLargeScreen ? 24 : 16,
                          color: Theme.of(context).colorScheme.primary,
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
Widget _buildLabel(String text, context, isLargeScreen) {
  return SizedBox(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isLargeScreen ? 24 : 15,
          color: Theme.of(context).colorScheme.primary,
        ),
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
  context,
  isLargeScreen,
}) {
  return PhysicalModel(
    borderRadius: BorderRadius.circular(50),
    color: Theme.of(context).colorScheme.tertiary,
    child: TextField(
      controller: controller,
      obscureText: isPassword ? (obscurePassword ?? true) : false,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: isLargeScreen ? 24 : 16,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.tertiary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: isLargeScreen ? 30 : 16,
          vertical: isLargeScreen ? 35 : 14,
        ),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    (obscurePassword ?? true)
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Theme.of(context).colorScheme.primary,
                    size: isLargeScreen ? 40 : 24,
                  ),
                  onPressed: toggleObscurePassword,
                )
                : null,
      ),
    ),
  );
}
