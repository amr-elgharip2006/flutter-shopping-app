// Part 1 - super.key
// What does super.key do? Where does the key go?
//   super.key passes the optional `key` from LoginPage's constructor up to the
//   parent class (StatefulWidget -> Widget), so it's saved in the widget's `key`
//   field. Flutter checks it when it rebuilds: same type + same key -> it keeps
//   the old Element and State; a different key -> the old State is thrown away
//   and a new one is created.
//
// Key? key (super.key) vs GlobalKey<FormState> _keyForm:
//   - the key from super.key belongs to the widget itself. It's optional and is
//     mostly used to keep or reset a widget's state (for example items in a list).
//   - _keyForm is a GlobalKey we create ourselves and give to the Form. It's
//     unique in the whole app and lets us reach the Form's State from outside
//     the Form, like _keyForm.currentState!.validate().
//
// Part 2 - why does const make Flutter faster?
//   A const widget is created once (at compile time) and the same object is
//   reused. When the parent rebuilds, Flutter sees it's the exact same widget
//   as last time and skips rebuilding it and everything under it. It also means
//   fewer objects to create and clean up on every build.
//   We can't use const for things that are only known at runtime, like
//   Text(username) or a TextFormField that uses a controller.
//
// Part 3 - what does _ do in Dart?
//   A name that starts with _ is private to its file. Nothing outside
//   login_page.dart can use _LoginPageState or _usernameController.
//   The State is an internal detail of the page: other files should only use
//   LoginPage, and Flutter creates the State itself through createState(), so
//   there's no reason for anyone else to create it or touch its fields.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'test.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _keyForm = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _inputCheck() {
    if (_keyForm.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;
      if (username == Database.username && password == Database.password) {
        Database.isLoggedIn = true;
        context.go("/home");
      } else {
        _usernameController.clear();
        _passwordController.clear();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Wrong info")));
      }
    }
  }

  @override
  void initState() {
    debugPrint(" start Login");
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    debugPrint(" finish Login");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _keyForm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: "Username"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "please enter valid username ";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  validator: (value) {
                    if (((value?.length) ?? 0) < 6) {
                      return "please enter valid password";
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _inputCheck,
                  child: const Text("go to home "),
                ),
                TextButton(
                  onPressed: () {
                    context.push("/signup");
                  },
                  child: const Text("Don't have an account? Sign up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
