import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../services/signup_service.dart';
import '../../services/login_service.dart';
import '../../screens/home_screen.dart';
import 'input_fields.dart';
import '../../utils/validators.dart';
import '../../utils/snackbar_service.dart'; 

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _lastnameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _generateRandomProfilePicUrl() {
    final random = Random();
    final randomNumber = random.nextInt(70) + 1; 
    return 'https://i.pravatar.cc/150?img=$randomNumber';
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final client = GraphQLProvider.of(context).value;
      final signupService = SignupService(client: client);
      final apiService = ApiService(client: client);

      try {
        final profilePicUrl = _generateRandomProfilePicUrl();
        final signupResult = await signupService.registerUser(
          name: _nameController.text.trim(),
          lastname: _lastnameController.text.trim(),
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          profilePic: profilePicUrl,
        );

        if (signupResult.hasException) {
          if (mounted) {
            SnackbarService.showError(
              context: context,
              message: "Error al registrarse. Intente nuevamente.",
            );
          }
          setState(() {
            _isLoading = false;
          });
          return;
        }

        final loginResult = await apiService.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (loginResult.hasException) {
          if (mounted) {
            SnackbarService.showError(
              context: context,
              message: "Registro exitoso, pero no se pudo iniciar sesión automáticamente.",
            );
          }
          setState(() {
            _isLoading = false;
          });
          return;
        }

        final data = loginResult.data?['login'];
        if (data != null && data['access_token'] != null && mounted) {
          SnackbarService.showSuccess(
            context: context,
            message: "Registro y inicio de sesión exitoso",
          );
          Navigator.pushReplacement(
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
              context: context,
              message: "Registro exitoso, pero no se pudo iniciar sesión automáticamente.",
            );
          }
        }
      } catch (e) {
        if (mounted) {
          SnackbarService.showError(
            context: context,
            message: "Error durante el registro: ${e.toString()}",
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
          if (_errorMessage != null)
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  controller: _nameController,
                  labelText: 'Nombre',
                  hintText: 'Ingresa tu nombre',
                  prefixIcon: Icons.person_outline,
                  validator: AuthValidators.validateName,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomTextFormField(
                  controller: _lastnameController,
                  labelText: 'Apellido',
                  hintText: 'Ingresa tu apellido',
                  prefixIcon: Icons.person_outline,
                  validator: AuthValidators.validatelastName,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: _usernameController,
            labelText: 'Usuario',
            hintText: 'Ingresa tu nombre de usuario',
            prefixIcon: Icons.account_circle_outlined,
            validator: AuthValidators.validateUsername,
          ),
          const SizedBox(height: 16),
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
            onVisibilityToggle: () => setState(() => _obscurePassword = !_obscurePassword),
            validator: AuthValidators.validatePassword,
          ),
          const SizedBox(height: 24),
          AuthButton(
            text: 'Registrarse',
            isLoading: _isLoading,
            onPressed: _onSubmit,
          ),
        ],
      ),
    );
  }
}