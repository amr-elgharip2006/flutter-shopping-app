import 'package:go_router/go_router.dart';

import 'home_page.dart';
import 'login_page.dart';
import 'products_page.dart';
import 'signup_page.dart';
import 'test.dart';

// Part 5.1 - why /signup is a top-level route and not under /home
// The redirect sends every path that starts with "/home" back to "/login" while
// the user isn't logged in. People open Signup *before* they log in, so if it
// were "/home/signup" the redirect would catch it and you could never reach it.
// As "/signup" it doesn't match the check, so it opens normally.
//
// Part 5.3 - go vs push experiments (I typed something in the Login username
// field first, to see if Login keeps its state)
// Test 1: push("/signup") then pop()
//   Signup opens on top of Login. Console: "start Signup" only, so Login is NOT
//   disposed. pop() closes Signup ("finish Signup") and Login is back with the
//   text I typed still there.
// Test 2: go("/signup") then pop()
//   Console: "start Signup", "finish Login", so Login IS disposed. There's no
//   back arrow, and pressing "Back to Login" throws
//   "GoError: There is nothing to pop". The app stays on Signup.
// Test 3: go("/signup") then go("/login")
//   Works. Console: "start Login", "finish Signup". Login is created again from
//   scratch, so the text I typed is gone.
// Test 4: push("/signup") then the AppBar back arrow
//   The back arrow shows up because there's a page under Signup. It does the
//   same as pop(): "finish Signup", and Login comes back with its text.
// So: with push, Login stays alive under Signup. With go, Login is disposed.
//
// go vs push in my own words:
//   The navigator keeps the pages in a stack. push puts a new page on top of
//   the stack and keeps the old ones under it, so pop (or the back arrow) can
//   take the top page off and you're back where you were. go doesn't add to
//   the stack, it replaces the whole stack with the pages of the new path, so
//   the old pages are disposed and there's nothing left to pop back to.
//   Use push for "open this and come back" (Login -> Signup -> back), and go
//   for "move to a new place" (Login -> Home after logging in, Logout -> Login).

GoRouter createRouter() {
  return GoRouter(
    initialLocation: "/login",
    redirect: (context, state) {
      var path = state.matchedLocation;
      if (path.startsWith("/home") && !Database.isLoggedIn) {
        return "/login";
      }
      return null;
    },
    routes: [
      GoRoute(path: "/login", builder: (context, state) => const LoginPage()),
      GoRoute(path: "/signup", builder: (context, state) => const SignupPage()),
      GoRoute(
        path: "/home",
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'products',
            builder: (context, state) => const ProductsPage(),
          ),
        ],
      ),
    ],
  );
}

final router = createRouter();
