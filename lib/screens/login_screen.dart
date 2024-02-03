
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesapp/riverpods/auth_providers.dart';
import 'package:moviesapp/routes/routes.dart';


class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Movie App')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                ref.read(AuthenticationProvider.notifier).login(
                  context,
                  emailController,
                  passwordController,
                );
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                context.goNamed(RoutePaths.registration.toString());
              },
              child: const Text('Dont have an account? tap here!'),
            ),
          ],
        ),
      ),
    );
  }
}