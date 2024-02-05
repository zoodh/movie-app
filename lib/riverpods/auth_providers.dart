
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesapp/routes/routes.dart';
import 'firebase_providers.dart';



final AuthenticationProvider = NotifierProvider<AuthenticationNotifier, void>(
  AuthenticationNotifier.new,
);

class AuthenticationNotifier extends Notifier<void> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  build() {
    return;
  }

  Future<void> login(BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController) async {
    try {
      await ref.read(firebaseAuthProvider).signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      context.goNamed(RoutePaths.home.toString());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed. Please check your credentials.'),
        ),
      );
    }
  }

  Future<void> register(BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController,
      TextEditingController numberController,
      TextEditingController nameController) async {
    try {
      await ref.read(firebaseAuthProvider).createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User? user = ref.read(firebaseAuthProvider).currentUser;
      await ref.read(firestoreProvider).collection('users').doc(user?.uid).set({
        "email": emailController.text,
        "password": passwordController.text,
        "name": nameController.text,
        "phonenumber": numberController.text,


      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration successful!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed. Please try again.'),
        ),
      );
    }
  }
}