import 'package:flutter_test/flutter_test.dart';
import 'package:mdiscover/core/di/injection_container.dart' as di;
import 'package:mdiscover/main.dart';

void main() {
  testWidgets('MDiscover app loads onboarding screen successfully', (WidgetTester tester) async {
    await di.initDependencyInjection();

    await tester.pumpWidget(const MDiscoverApp());
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('WELCOME TO MDISCOVER'), findsOneWidget);
  });
}
