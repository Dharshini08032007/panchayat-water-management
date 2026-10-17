import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:water/src/neerwatch_app.dart';

void main() {
  testWidgets('renders NeerWatch login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const NeerWatchApp());

    expect(find.text('NeerWatch'), findsOneWidget);
    expect(find.text('Select Your Role'), findsOneWidget);
  });
}
