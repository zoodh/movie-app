
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../riverpods/auth_providers.dart';

class RegistirationPage extends ConsumerStatefulWidget {
  const RegistirationPage({super.key});
  @override
  _RegistirationPageState createState() => _RegistirationPageState();
}

class _RegistirationPageState extends ConsumerState<RegistirationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  // will use this data in the userobject later

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
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: numberController,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                  ),
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
                      final authNotifier = ref.read(AuthenticationProvider.notifier);
                      await authNotifier.register(
                        context,
                        emailController,
                        passwordController,
                      );
                      context.go("/");
                    },
                    child: const Text('Register'),
                  ),
                ]
            )
        )
    );
  }
}