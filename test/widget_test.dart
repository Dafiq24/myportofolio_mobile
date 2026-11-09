import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/menu.dart';

void main() {
  testWidgets('portfolio menu shows profile and interactive actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Sultan Noor Dafiq'), findsOneWidget);
    expect(find.text('2506600713'), findsOneWidget);
    expect(find.text('PBP E'), findsOneWidget);
    expect(find.text('Burhan'), findsNothing);
    expect(find.byType(InfoCard), findsNWidgets(3));
    expect(find.byType(ItemCard), findsNWidgets(3));

    final List<ItemCard> actionCards = tester
        .widgetList<ItemCard>(find.byType(ItemCard))
        .toList();
    expect(actionCards.map((ItemCard card) => card.item.color), <Color>[
      Colors.blue.shade700,
      Colors.green.shade700,
      Colors.red.shade700,
    ]);

    await tester.tap(find.text('Lihat Experience'));
    await tester.pump();

    expect(
      find.text('Kamu telah menekan tombol Lihat Experience!'),
      findsOneWidget,
    );
  });
}
