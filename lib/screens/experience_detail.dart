import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

class ExperienceDetailPage extends StatefulWidget {
  const ExperienceDetailPage({
    super.key,
    required this.experienceId,
    required this.apiClient,
  });

  final String experienceId;
  final ApiClient apiClient;

  @override
  State<ExperienceDetailPage> createState() => _ExperienceDetailPageState();
}

class _ExperienceDetailPageState extends State<ExperienceDetailPage> {
  late Future<Experience> _experienceFuture;

  @override
  void initState() {
    super.initState();
    _loadExperience();
  }

  void _loadExperience() {
    _experienceFuture = widget.apiClient.fetchExperience(widget.experienceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Experience',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Experience>(
        future: _experienceFuture,
        builder: (BuildContext context, AsyncSnapshot<Experience> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _ErrorState(
              message: snapshot.error.toString(),
              onRetry: () => setState(_loadExperience),
            );
          }
          return _ExperienceDetail(experience: snapshot.requireData);
        },
      ),
    );
  }
}

class _ExperienceDetail extends StatelessWidget {
  const _ExperienceDetail({required this.experience});

  final Experience experience;

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
                  if (experience.thumbnail?.isNotEmpty ?? false) ...[
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        experience.thumbnail!,
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
                    experience.title,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    experience.organization.isEmpty
                        ? 'Organisasi tidak dicantumkan'
                        : experience.organization,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  _DetailRow(
                    label: 'Kategori',
                    value: experience.categoryDisplay,
                  ),
                  _DetailRow(
                    label: 'Periode',
                    value: experience.period.isEmpty ? '-' : experience.period,
                  ),
                  _DetailRow(
                    label: 'Status',
                    value: experience.isOngoing ? 'Ongoing' : 'Completed',
                  ),
                  _DetailRow(
                    label: 'Skills',
                    value: experience.skillList.isEmpty
                        ? '-'
                        : experience.skillList.join(', '),
                  ),
                  _DetailRow(
                    label: 'Stars',
                    value: experience.starCount.toString(),
                  ),
                  const Divider(height: 32),
                  Text(
                    'Deskripsi',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(experience.description),
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
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
