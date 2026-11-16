import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
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

  testWidgets('project form validates input and shows a complete summary', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();

    expect(find.byType(ProjectFormPage), findsOneWidget);
    expect(find.text('Add Project Form'), findsOneWidget);

    final Finder saveButton = find.byKey(const ValueKey('save-project-button'));
    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pump();

    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    await tester.enterText(
      find.byKey(const ValueKey('project-name-field')),
      'Portfolio Mobile',
    );
    await tester.enterText(
      find.byKey(const ValueKey('project-description-field')),
      'Aplikasi Flutter untuk menampilkan pengalaman dan proyek.',
    );
    await tester.enterText(
      find.byKey(const ValueKey('project-technologies-field')),
      'Flutter, Django',
    );
    await tester.enterText(
      find.byKey(const ValueKey('project-link-field')),
      'example.com/portfolio',
    );

    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pump();

    expect(
      find.text('Tautan harus berupa URL http atau https yang valid.'),
      findsOneWidget,
    );
    expect(find.byType(AlertDialog), findsNothing);

    await tester.enterText(
      find.byKey(const ValueKey('project-link-field')),
      'https://example.com/portfolio',
    );
    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Nama Proyek: Portfolio Mobile'), findsOneWidget);
    expect(find.text('Kategori: Web Development'), findsOneWidget);
    expect(find.text('Teknologi: Flutter, Django'), findsOneWidget);
    expect(find.text('Tautan: https://example.com/portfolio'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('drawer opens project form and Home returns to the menu', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    final ScaffoldState homeScaffold = tester.state(find.byType(Scaffold));
    homeScaffold.openDrawer();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsOneWidget);

    final ScaffoldState formScaffold = tester.state(find.byType(Scaffold));
    formScaffold.openDrawer();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
  });
}
