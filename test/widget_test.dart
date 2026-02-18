import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monk_mode_launcher/main.dart';
import 'package:monk_mode_launcher/presentation/screens/home_screen.dart';

void main() {
  testWidgets('App arranca y muestra HomeScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
