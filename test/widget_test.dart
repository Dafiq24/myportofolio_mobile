import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/menu.dart';

void main() {
  testWidgets('portfolio menu shows profile and interactive actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Burhan'), findsOneWidget);
    expect(find.text('2406000001'), findsOneWidget);
    expect(find.text('PBP A'), findsOneWidget);
    expect(find.byType(InfoCard), findsNWidgets(3));
    expect(find.byType(ItemCard), findsNWidgets(3));

    await tester.tap(find.text('Lihat Proyek'));
    await tester.pump();

    expect(
      find.text('Kamu telah menekan tombol Lihat Proyek!'),
      findsOneWidget,
    );
  });
}
