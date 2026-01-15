import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presupresto/blocs/Login/login_bloc.dart';
import 'package:presupresto/blocs/Login/login_event.dart';
import 'package:presupresto/blocs/Login/login_state.dart';
import 'package:presupresto/utils/colors.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            }
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: AppColors.warning,
                content: Text(
                  state.message.replaceAll('Exception:', ''),
                  style: const TextStyle(color: AppColors.warningText),
                ),
              ));
            }
          },
          builder: (context, state) {
            final loading = state is AuthLoading;
            return LoginViewWidget(
              loading: loading,
            );
          },
        ),
      ),
    );
  }
}

class LoginViewWidget extends StatefulWidget {
  final bool loading;
  const LoginViewWidget({Key? key, required this.loading}) : super(key: key);

  @override
  State<LoginViewWidget> createState() => _LoginViewWidgetState();
}

class _LoginViewWidgetState extends State<LoginViewWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.loading
                    ? null
                    : () => context.read<AuthBloc>().add(LoginRequested(
                        _emailController.text.trim(),
                        _passwordController.text)),
                child: widget.loading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
