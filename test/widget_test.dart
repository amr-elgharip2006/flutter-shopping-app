import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_shopping_app_4/router.dart';
import 'package:full_shopping_app_4/test.dart';

void main() {
  setUp(() {
    Database.isLoggedIn = false;
    Database.username = "Atef";
    Database.password = "Atef12345";
  });

  Future<void> openSignup(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: createRouter()));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Don't have an account? Sign up"));
    await tester.pumpAndSettle();
  }

  Finder field(String label) => find.widgetWithText(TextFormField, label);

  testWidgets('signup shows all the error messages', (tester) async {
    await openSignup(tester);
    await tester.enterText(field("Username"), " ab ");
    await tester.enterText(field("Email"), "amr.com");
    await tester.enterText(field("Password"), "123");
    await tester.enterText(field("Confirm Password"), "1234");
    await tester.tap(find.widgetWithText(ElevatedButton, "Sign Up"));
    await tester.pump();

    expect(find.text("Username must be at least 3 characters"), findsOneWidget);
    expect(find.text("Please enter a valid email"), findsOneWidget);
    expect(find.text("Password must be at least 6 characters"), findsOneWidget);
    expect(find.text("Passwords do not match"), findsOneWidget);
    expect(Database.username, "Atef");
  });

  testWidgets('new account can log in', (tester) async {
    await openSignup(tester);
    await tester.enterText(field("Username"), "amr");
    await tester.enterText(field("Email"), "amr@mail.com");
    await tester.enterText(field("Password"), "secret1");
    await tester.enterText(field("Confirm Password"), "secret1");
    await tester.tap(find.widgetWithText(ElevatedButton, "Sign Up"));
    await tester.pumpAndSettle();

    expect(Database.username, "amr");
    expect(Database.password, "secret1");
    expect(find.text("Account created, please login"), findsOneWidget);
    expect(find.text("go to home "), findsOneWidget); // back on Login

    await tester.enterText(field("Username"), "amr");
    await tester.enterText(field("Password"), "secret1");
    await tester.tap(find.text("go to home "));
    await tester.pumpAndSettle();
    expect(find.text("welcome to Home Page"), findsOneWidget);
  });

  testWidgets('logout goes back to login', (tester) async {
    Database.isLoggedIn = true;
    final r = createRouter()..go("/home");
    await tester.pumpWidget(MaterialApp.router(routerConfig: r));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Logout"));
    await tester.pumpAndSettle();
    expect(Database.isLoggedIn, false);
    expect(find.text("go to home "), findsOneWidget);
  });

  testWidgets('home is protected by the redirect', (tester) async {
    final r = createRouter()..go("/home");
    await tester.pumpWidget(MaterialApp.router(routerConfig: r));
    await tester.pumpAndSettle();
    expect(find.text("welcome to Home Page"), findsNothing);
    expect(find.text("go to home "), findsOneWidget);
  });
}
