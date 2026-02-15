import 'package:flutter_test/flutter_test.dart';
import 'package:the_pink_club/main.dart';
import 'package:the_pink_club/core/di/service_locator.dart' as di;

void main() {
  setUp(() async {
    await di.init();
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Basic check to see if the app builds
    expect(find.byType(MyApp), findsOneWidget);
  });
}
