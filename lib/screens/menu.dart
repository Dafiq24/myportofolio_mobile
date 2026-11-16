import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final String npm = '2506600713';
  final String nama = 'Sultan Noor Dafiq';
  final String kelas = 'PBP E';

  final List<ItemHomepage> items = [
    ItemHomepage(
      'Lihat Experience',
      Icons.work_outline,
      Colors.blue.shade700,
      HomepageAction.viewExperience,
    ),
    ItemHomepage(
      'Tambah Experience',
      Icons.add_circle_outline,
      Colors.green.shade700,
      HomepageAction.addExperience,
    ),
    ItemHomepage(
      'Tambah Proyek',
      Icons.add_box_outlined,
      Colors.indigo.shade700,
      HomepageAction.addProject,
    ),
    ItemHomepage(
      'Logout',
      Icons.logout,
      Colors.red.shade700,
      HomepageAction.logout,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = MediaQuery.sizeOf(context).width >= 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InfoCard(title: 'NPM', content: npm),
                  InfoCard(title: 'Name', content: nama),
                  InfoCard(title: 'Class', content: kelas),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'Selamat datang di MyPortfolio Mobile!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    GridView.count(
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: isWideScreen ? 4 : 2,
                      childAspectRatio: isWideScreen ? 2 : 1,
                      shrinkWrap: true,
                      children: items.map((ItemHomepage item) {
                        return ItemCard(item);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        width: MediaQuery.of(context).size.width / 3.5,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }
}
