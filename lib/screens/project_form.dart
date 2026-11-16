import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _projectName = '';
  String _description = '';
  String _category = 'Web Development';
  String _technologies = '';
  String _projectLink = '';

  static const List<String> _categories = [
    'Web Development',
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  String? _validateRequired(
    String? value, {
    required String fieldName,
    required int maxLength,
  }) {
    final String normalizedValue = value?.trim() ?? '';
    if (normalizedValue.isEmpty) {
      return '$fieldName tidak boleh kosong!';
    }
    if (normalizedValue.length > maxLength) {
      return '$fieldName maksimal $maxLength karakter.';
    }
    return null;
  }

  String? _validateProjectLink(String? value) {
    final String normalizedValue = value?.trim() ?? '';
    if (normalizedValue.isEmpty) {
      return null;
    }

    final Uri? uri = Uri.tryParse(normalizedValue);
    final bool isHttpUrl =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
    if (!isHttpUrl) {
      return 'Tautan harus berupa URL http atau https yang valid.';
    }
    return null;
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _projectName = '';
      _description = '';
      _category = 'Web Development';
      _technologies = '';
      _projectLink = '';
    });
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        final String technologies = _technologies.trim().isEmpty
            ? '-'
            : _technologies.trim();
        final String projectLink = _projectLink.trim().isEmpty
            ? '-'
            : _projectLink.trim();

        return AlertDialog(
          title: const Text('Proyek berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Nama Proyek: ${_projectName.trim()}'),
                Text('Deskripsi: ${_description.trim()}'),
                Text('Kategori: $_category'),
                Text('Teknologi: $technologies'),
                Text('Tautan: $projectLink'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _resetForm();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Project Form',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    key: const ValueKey('project-name-field'),
                    decoration: _inputDecoration(
                      label: 'Nama Proyek',
                      hint: 'Contoh: MyPortfolio Mobile',
                    ),
                    textInputAction: TextInputAction.next,
                    maxLength: 100,
                    onChanged: (String value) {
                      _projectName = value;
                    },
                    validator: (String? value) => _validateRequired(
                      value,
                      fieldName: 'Nama proyek',
                      maxLength: 100,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const ValueKey('project-description-field'),
                    decoration: _inputDecoration(
                      label: 'Deskripsi Proyek',
                      hint: 'Jelaskan tujuan dan hasil proyek',
                    ),
                    minLines: 3,
                    maxLines: 5,
                    maxLength: 1000,
                    onChanged: (String value) {
                      _description = value;
                    },
                    validator: (String? value) => _validateRequired(
                      value,
                      fieldName: 'Deskripsi proyek',
                      maxLength: 1000,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    key: const ValueKey('project-category-field'),
                    initialValue: _category,
                    decoration: _inputDecoration(
                      label: 'Kategori Proyek',
                      hint: 'Pilih kategori proyek',
                    ),
                    items: _categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _category = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const ValueKey('project-technologies-field'),
                    decoration: _inputDecoration(
                      label: 'Teknologi yang Digunakan',
                      hint: 'Contoh: Flutter, Django, Figma',
                    ),
                    textInputAction: TextInputAction.next,
                    maxLength: 200,
                    onChanged: (String value) {
                      _technologies = value;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const ValueKey('project-link-field'),
                    decoration: _inputDecoration(
                      label: 'Tautan Proyek',
                      hint: 'https://example.com/project',
                    ),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    onChanged: (String value) {
                      _projectLink = value;
                    },
                    validator: _validateProjectLink,
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    key: const ValueKey('save-project-button'),
                    onPressed: _submitForm,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
