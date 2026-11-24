import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list.dart';

enum HomepageAction {
  viewExperience,
  viewProjects,
  addExperience,
  addProject,
  logout,
}

class ItemHomepage {
  ItemHomepage(this.name, this.icon, this.color, this.action);

  final String name;
  final IconData icon;
  final Color color;
  final HomepageAction action;
}

class ItemCard extends StatelessWidget {
  const ItemCard(this.item, {super.key});

  final ItemHomepage item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          switch (item.action) {
            case HomepageAction.addExperience:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExperienceFormPage(),
                ),
              );
              break;
            case HomepageAction.addProject:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProjectFormPage(),
                ),
              );
              break;
            case HomepageAction.viewProjects:
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => ProjectListPage(),
                ),
              );
              break;
            case HomepageAction.viewExperience:
            case HomepageAction.logout:
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('Kamu telah menekan tombol ${item.name}!'),
                  ),
                );
              break;
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
