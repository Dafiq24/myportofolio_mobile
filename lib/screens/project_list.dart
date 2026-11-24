import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/screens/project_detail.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ProjectListPage extends StatefulWidget {
  ProjectListPage({super.key, ApiClient? apiClient})
    : apiClient = apiClient ?? ApiClient();

  final ApiClient apiClient;

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  late Future<List<Project>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  void _loadProjects() {
    _projectsFuture = widget.apiClient.fetchProjects();
  }

  Future<void> _refreshProjects() async {
    setState(_loadProjects);
    await _projectsFuture;
  }

  void _retry() {
    setState(_loadProjects);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Proyek',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<Project>>(
        future: _projectsFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Project>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _ProjectListMessage(
              icon: Icons.cloud_off_outlined,
              message: snapshot.error.toString(),
              actionLabel: 'Coba Lagi',
              onAction: _retry,
            );
          }

          final List<Project> projects = snapshot.requireData;
          if (projects.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refreshProjects,
              child: const _ProjectListMessage(
                icon: Icons.inventory_2_outlined,
                message: 'Belum ada proyek yang tersedia.',
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshProjects,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: projects.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (BuildContext context, int index) {
                final Project project = projects[index];
                return _ProjectListCard(
                  project: project,
                  onTap: () {
                    final String? projectId = project.id;
                    if (projectId == null) {
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => ProjectDetailPage(
                          projectId: projectId,
                          apiClient: widget.apiClient,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ProjectListCard extends StatelessWidget {
  const _ProjectListCard({required this.project, required this.onTap});

  final Project project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: const Icon(Icons.folder_outlined),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      project.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project.techStack,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectListMessage extends StatelessWidget {
  const _ProjectListMessage({
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
            child: Padding(
              padding: const EdgeInsets.all(24),
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
        ),
      ],
    );
  }
}
