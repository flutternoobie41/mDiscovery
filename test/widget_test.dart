import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdiscover/core/di/injection_container.dart' as di;
import 'package:mdiscover/main.dart';

void main() {
  testWidgets('MDiscover app loads onboarding screen successfully', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await di.initDependencyInjection();

    await tester.pumpWidget(const MDiscoverApp());
    await tester.pump(const Duration(seconds: 3));

    expect(find.text('Add Profile'), findsOneWidget);
  });
}
