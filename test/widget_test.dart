import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

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
    expect(find.byType(ItemCard), findsNWidgets(4));

    final List<ItemCard> actionCards = tester
        .widgetList<ItemCard>(find.byType(ItemCard))
        .toList();
    expect(actionCards.map((ItemCard card) => card.item.color), <Color>[
      Colors.blue.shade700,
      Colors.green.shade700,
      Colors.indigo.shade700,
      Colors.red.shade700,
    ]);

    await tester.tap(find.text('Lihat Experience'));
    await tester.pump();

    expect(
      find.text('Kamu telah menekan tombol Lihat Experience!'),
      findsOneWidget,
    );

    final ScaffoldState scaffoldState = tester.state(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Add Project'), findsOneWidget);
    expect(
      find.text('Explore personal experiences and projects!'),
      findsOneWidget,
    );
  });
}
