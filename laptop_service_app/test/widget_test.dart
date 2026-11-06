import 'package:flutter_test/flutter_test.dart';
import 'package:laptop_service_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LaptopServiceApp());
    expect(find.byType(LaptopServiceApp), findsOneWidget);
  });
}
