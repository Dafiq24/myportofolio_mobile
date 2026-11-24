import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list.dart';
import 'package:myportofolio_mobile/state/auth_state.dart';
import 'package:myportofolio_mobile/utils/auth_guard.dart';
import 'package:provider/provider.dart';

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
        onTap: () async {
          switch (item.action) {
            case HomepageAction.addExperience:
              if (!await ensureLoggedIn(context) || !context.mounted) {
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExperienceFormPage(),
                ),
              );
              break;
            case HomepageAction.addProject:
              if (!await ensureLoggedIn(context) || !context.mounted) {
                return;
              }
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
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('Kamu telah menekan tombol ${item.name}!'),
                  ),
                );
              break;
            case HomepageAction.logout:
              final AuthState authState = context.read<AuthState>();
              final bool wasAuthenticated = authState.isAuthenticated;
              await authState.logout();
              if (!context.mounted) {
                return;
              }
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      wasAuthenticated
                          ? 'Logout berhasil.'
                          : 'Kamu belum login.',
                    ),
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
