import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

class ProjectDetailPage extends StatefulWidget {
  const ProjectDetailPage({
    super.key,
    required this.projectId,
    required this.apiClient,
  });

  final String projectId;
  final ApiClient apiClient;

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  late Future<Project> _projectFuture;

  @override
  void initState() {
    super.initState();
    _loadProject();
  }

  void _loadProject() {
    _projectFuture = widget.apiClient.fetchProject(widget.projectId);
  }

  void _retry() {
    setState(_loadProject);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Proyek',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Project>(
        future: _projectFuture,
        builder: (BuildContext context, AsyncSnapshot<Project> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _ProjectErrorState(
              message: snapshot.error.toString(),
              onRetry: _retry,
            );
          }

          return _ProjectDetail(project: snapshot.requireData);
        },
      ),
    );
  }
}

class _ProjectDetail extends StatelessWidget {
  const _ProjectDetail({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (project.projectImageUrl.isNotEmpty) ...[
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        project.projectImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const ColoredBox(
                          color: Color(0xFFE8EAF6),
                          child: Center(
                            child: Icon(Icons.image_not_supported_outlined),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  Text(
                    project.title,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(
                    icon: Icons.code_outlined,
                    label: 'Teknologi',
                    value: project.techStack,
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(
                    icon: Icons.link_outlined,
                    label: 'Tautan',
                    value: project.projectUrl.isEmpty
                        ? '-'
                        : project.projectUrl,
                  ),
                  const Divider(height: 32),
                  Text(
                    'Deskripsi',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(project.description),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text('$label: $value')),
      ],
    );
  }
}

class _ProjectErrorState extends StatelessWidget {
  const _ProjectErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 56),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
