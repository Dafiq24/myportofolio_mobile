import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/screens/experience_detail.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/utils/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceListPage extends StatefulWidget {
  ExperienceListPage({super.key, ApiClient? apiClient})
    : apiClient = apiClient ?? ApiClient();

  final ApiClient apiClient;

  @override
  State<ExperienceListPage> createState() => _ExperienceListPageState();
}

class _ExperienceListPageState extends State<ExperienceListPage> {
  late Future<List<Experience>> _experiencesFuture;

  @override
  void initState() {
    super.initState();
    _loadExperiences();
  }

  void _loadExperiences() {
    _experiencesFuture = widget.apiClient.fetchExperiences();
  }

  Future<void> _refreshExperiences() async {
    setState(_loadExperiences);
    await _experiencesFuture;
  }

  Future<void> _openExperienceForm() async {
    if (!await ensureLoggedIn(context) || !mounted) {
      return;
    }

    final bool? created = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(builder: (_) => const ExperienceFormPage()),
    );
    if (created == true && mounted) {
      await _refreshExperiences();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Experience',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        key: const ValueKey('add-experience-fab'),
        onPressed: _openExperienceForm,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Experience'),
      ),
      body: FutureBuilder<List<Experience>>(
        future: _experiencesFuture,
        builder:
            (BuildContext context, AsyncSnapshot<List<Experience>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return _ListMessage(
                  icon: Icons.cloud_off_outlined,
                  message: snapshot.error.toString(),
                  actionLabel: 'Coba Lagi',
                  onAction: () => setState(_loadExperiences),
                );
              }

              final List<Experience> experiences = snapshot.requireData;
              if (experiences.isEmpty) {
                return RefreshIndicator(
                  onRefresh: _refreshExperiences,
                  child: const _ListMessage(
                    icon: Icons.work_history_outlined,
                    message: 'Belum ada Experience yang tersedia.',
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _refreshExperiences,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: experiences.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (BuildContext context, int index) {
                    final Experience experience = experiences[index];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primaryContainer,
                          child: const Icon(Icons.work_outline),
                        ),
                        title: Text(
                          experience.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            <String>[
                              if (experience.organization.isNotEmpty)
                                experience.organization,
                              experience.categoryDisplay,
                              if (experience.period.isNotEmpty)
                                experience.period,
                            ].join(' • '),
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          final String? experienceId = experience.id;
                          if (experienceId == null) {
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => ExperienceDetailPage(
                                experienceId: experienceId,
                                apiClient: widget.apiClient,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
      ),
    );
  }
}

class _ListMessage extends StatelessWidget {
  const _ListMessage({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.6,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 56),
                const SizedBox(height: 12),
                Text(message, textAlign: TextAlign.center),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: onAction,
                    icon: const Icon(Icons.refresh),
                    label: Text(actionLabel!),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
