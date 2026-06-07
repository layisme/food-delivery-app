import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/config/app_flavor.dart';
import 'package:food_delivery_app/config/environment.dart';
import 'package:food_delivery_app/main.dart';

void main() {
  testWidgets('shows splash then opens onboarding', (tester) async {
    setAppFlavor(AppFlavor.dev);

    await tester.pumpWidget(const MyApp());

    expect(find.text('Culina'), findsOneWidget);
    expect(find.text('DIGITAL CONCIERGE'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Discover local'), findsOneWidget);
    expect(find.text('hidden gems.'), findsOneWidget);
  });
}
