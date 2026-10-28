import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'test.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    debugPrint(" start Home");
    super.initState();
  }

  @override
  void dispose() {
    debugPrint(" finish Home");
    super.dispose();
  }

  // Part 5.4 - the hidden bug
  // Login opens Home with context.go("/home"). go replaces the whole stack, so
  // Home is the only page in it and there is nothing under it to go back to.
  // The old "go back" button called context.pop(), which throws
  // "GoError: There is nothing to pop" in the console and the page just stays
  // on Home.
  // Going "back" from Home to Login only makes sense as a logout, so the button
  // now logs out and uses go to replace the stack with /login.
  void _logout() {
    Database.isLoggedIn = false;
    context.go("/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("welcome to Home Page"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.push("/home/products");
              },
              child: const Text("Products"),
            ),
            ElevatedButton(onPressed: _logout, child: const Text("Logout")),
          ],
        ),
      ),
    );
  }
}
