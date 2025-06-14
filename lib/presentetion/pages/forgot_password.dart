import 'package:app_praca_ciencia/core/services/auth_service.dart';
import 'package:app_praca_ciencia/core/styles/styles.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final AuthService authService = AuthService();

  // Função para resetar a senha do usuário
  Future<void> _handleResetPassword(BuildContext context) async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite seu e-mail para recuperar a senha.'),
        ),
      );
      return;
    }

    try {
      await authService.resetPassword(emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link para redefinir senha enviado para seu e-mail.'),
        ),
      );
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
        decoration: BoxDecoration(color: Styles.backgroundColor),
        child: Container(
          margin: EdgeInsetsDirectional.symmetric(
            vertical: 300,
            horizontal: 20,
          ),
          padding: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Styles.backgroundContentColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 15,
                offset: const Offset(5, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Faça a redefinição da sua senha!',
                style: TextStyle(
                  color: Styles.fontColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              PhysicalModel(
                borderRadius: BorderRadius.circular(50),
                color: Styles.textFieldColor,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Digite o seu emal!',
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
                  ),
                ),
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Styles.textFieldColor,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Styles.fontColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Styles.textFieldColor,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                    ),
                    onPressed: () => _handleResetPassword(context),
                    child: Text(
                      'Redefinir',
                      style: TextStyle(
                        color: Styles.fontColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
