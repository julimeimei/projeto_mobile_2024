import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:projeto_mobile/model/userModel.dart';
import 'package:projeto_mobile/services/authService.dart';
import 'package:projeto_mobile/view/authScreens/loginScreen.dart';
import 'package:sizer/sizer.dart';

class Register extends StatelessWidget {
  const Register({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Registro',
      home: RegisterScreen(),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool registerButtonPressed = false;
  // ignore: unused_field
  bool _isNameValid = true;
  bool _isEmailValid = true;
  // ignore: unused_field
  bool _isPasswordValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF885455),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              textAlign: TextAlign.start,
              'Crie sua conta',
              style: TextStyle(
                  fontFamily: 'Inter-SemiBold',
                  fontSize: 25,
                  color: Colors.white),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                prefixIcon: Icon(Icons.person),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (_) {
                setState(() {
                  _isNameValid = nameController.text.isNotEmpty;
                });
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira seu nome.';
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                filled: true,
                fillColor: Colors.white,
                errorText:
                    _isEmailValid ? null : 'Por favor, insira um email válido',
              ),
              onChanged: (_) {
                setState(() {
                  _isEmailValid = _isEmailValidCheck(emailController.text);
                });
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (!_isEmailValidCheck(value ?? "")) {
                  return 'Por favor, insira um email válido.';
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                prefixIcon: Icon(Icons.lock),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (_) {
                setState(() {
                  _isPasswordValid = passwordController.text.length >= 6;
                });
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira uma senha.';
                } else if (value.length < 6) {
                  return 'A senha deve ter pelo menos 6 caracteres.';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    (emailController.text.isNotEmpty &&
                        _isEmailValidCheck(emailController.text)) &&
                    (passwordController.text.isNotEmpty &&
                        passwordController.text.length >= 6)) {
                  setState(() {
                    registerButtonPressed = true;
                  });
                  try {
                    UserModel userData = UserModel(
                      userName: nameController.text.trim(),
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );

                    await AuthServices.registerUserData(
                      userData: userData,
                      context: context,
                    );
                  } catch (e) {
                    print("Error: $e");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF523232),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: Colors.black),
                ),
              ),
              child: registerButtonPressed
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      'Criar Conta',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Já tem uma conta?',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (route) => false);
                  },
                  child: const Text('Entrar',
                      style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _isEmailValidCheck(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
