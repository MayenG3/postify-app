import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../services/login_service.dart';
import '../../screens/home_screen.dart';
import '../../screens/signup_screen.dart';
import 'input_fields.dart';
import '../../utils/validators.dart';
import '../../utils/snackbar_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final client = GraphQLProvider.of(context).value;
      final api = ApiService(client: client);

      setState(() {
        _isLoading = true;
      });

      try {
        final result = await api.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (result.hasException) {
          if (mounted) {
            SnackbarService.showError(
              // ignore: use_build_context_synchronously
              context: context,
              message: "Correo o contraseña incorrectos.",
            );
          }
          setState(() => _isLoading = false);
          return;
        }

        final data = result.data?['login'];
        if (data != null && data['access_token'] != null && mounted) {
          SnackbarService.showSuccess(
            // ignore: use_build_context_synchronously
            context: context,
            message: "Inicio de sesión exitoso",
          );
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreen(
                user: data['user'],
                token: data['access_token'],
              ),
            ),
          );
        } else {
          if (mounted) {
            SnackbarService.showError(
              // ignore: use_build_context_synchronously
              context: context,
              message: "Correo o contraseña incorrectos.",
            );
          }
        }
      } catch (e) {
        if (mounted) {
          SnackbarService.showError(
            // ignore: use_build_context_synchronously
            context: context,
            message: "Error al iniciar sesión: ${e.toString()}",
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextFormField(
            controller: _emailController,
            labelText: 'Correo',
            hintText: 'Ingresa tu correo',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: AuthValidators.validateEmail,
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: _passwordController,
            labelText: 'Contraseña',
            hintText: 'Ingresa tu contraseña',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscurePassword,
            showVisibilityToggle: true,
            onVisibilityToggle:
                () => setState(() => _obscurePassword = !_obscurePassword),
            validator: AuthValidators.validatePassword,
          ),
          const SizedBox(height: 16),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          AuthButton(
            text: 'Ingresar',
            isLoading: _isLoading,
            onPressed: () => _login(context),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("No tienes una cuenta? "),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
                child: const Text('Crear cuenta'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}