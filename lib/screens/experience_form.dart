import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _title = '';
  String _organization = '';
  String _period = '';
  String _displayOrder = '0';
  String _description = '';
  String _category = 'full-time';
  String _thumbnail = '';
  String _skills = '';

  static const Map<String, String> _categories = {
    'internship': 'Internship',
    'research': 'Research',
    'volunteer': 'Volunteer',
    'part-time': 'Part-Time',
    'full-time': 'Full-Time',
    'freelance': 'Freelance',
  };

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    String? helperText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: helperText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  String? _validateText(
    String? value, {
    required String fieldName,
    required int maxLength,
    bool required = false,
  }) {
    final String normalizedValue = value?.trim() ?? '';
    if (required && normalizedValue.isEmpty) {
      return '$fieldName tidak boleh kosong!';
    }
    if (normalizedValue.length > maxLength) {
      return '$fieldName maksimal $maxLength karakter.';
    }
    return null;
  }

  String? _validateDisplayOrder(String? value) {
    final String normalizedValue = value?.trim() ?? '';
    final int? parsedValue = int.tryParse(normalizedValue);
    if (parsedValue == null) {
      return 'Urutan timeline harus berupa bilangan bulat.';
    }
    if (parsedValue < 0 || parsedValue > 32767) {
      return 'Urutan timeline harus berada di antara 0 dan 32767.';
    }
    return null;
  }

  String? _validateThumbnail(String? value) {
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
      return 'URL dokumentasi harus memakai http atau https.';
    }
    return null;
  }

  String _displayValue(String value) {
    final String normalizedValue = value.trim();
    return normalizedValue.isEmpty ? '-' : normalizedValue;
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _title = '';
      _organization = '';
      _period = '';
      _displayOrder = '0';
      _description = '';
      _category = 'full-time';
      _thumbnail = '';
      _skills = '';
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
        return AlertDialog(
          title: const Text('Experience berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Role Title: ${_title.trim()}'),
                Text('Organization: ${_displayValue(_organization)}'),
                Text('Display Period: ${_displayValue(_period)}'),
                Text('Timeline Position: $_displayOrder'),
                Text('Description: ${_description.trim()}'),
                Text('Employment Type: ${_categories[_category]}'),
                Text('Documentation URL: ${_displayValue(_thumbnail)}'),
                Text('Related Skills: ${_displayValue(_skills)}'),
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
          'Add Experience Form',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          key: const ValueKey('experience-form-scroll-view'),
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    key: const ValueKey('experience-title-field'),
                    decoration: _inputDecoration(
                      label: 'Role Title',
                      hint: 'Contoh: Teaching Staff',
                    ),
                    textInputAction: TextInputAction.next,
                    maxLength: 255,
                    onChanged: (String value) {
                      _title = value;
                    },
                    validator: (String? value) => _validateText(
                      value,
                      fieldName: 'Role title',
                      maxLength: 255,
                      required: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const ValueKey('experience-organization-field'),
                    decoration: _inputDecoration(
                      label: 'Organization',
                      hint: 'Contoh: BETIS Fasilkom UI',
                    ),
                    textInputAction: TextInputAction.next,
                    maxLength: 255,
                    onChanged: (String value) {
                      _organization = value;
                    },
                    validator: (String? value) => _validateText(
                      value,
                      fieldName: 'Organization',
                      maxLength: 255,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const ValueKey('experience-period-field'),
                    decoration: _inputDecoration(
                      label: 'Display Period',
                      hint: 'Contoh: January 2026 - June 2026',
                    ),
                    textInputAction: TextInputAction.next,
                    maxLength: 100,
                    onChanged: (String value) {
                      _period = value;
                    },
                    validator: (String? value) => _validateText(
                      value,
                      fieldName: 'Display period',
                      maxLength: 100,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const ValueKey('experience-order-field'),
                    initialValue: '0',
                    decoration: _inputDecoration(
                      label: 'Timeline Position',
                      hint: '0',
                      helperText: 'Angka lebih kecil tampil lebih awal.',
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChanged: (String value) {
                      _displayOrder = value;
                    },
                    validator: _validateDisplayOrder,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const ValueKey('experience-description-field'),
                    decoration: _inputDecoration(
                      label: 'Description',
                      hint: 'Jelaskan tanggung jawab dan kontribusimu',
                    ),
                    minLines: 3,
                    maxLines: 5,
                    maxLength: 2000,
                    onChanged: (String value) {
                      _description = value;
                    },
                    validator: (String? value) => _validateText(
                      value,
                      fieldName: 'Description',
                      maxLength: 2000,
                      required: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    key: const ValueKey('experience-category-field'),
                    initialValue: _category,
                    decoration: _inputDecoration(
                      label: 'Employment Type',
                      hint: 'Pilih tipe pengalaman',
                    ),
                    items: _categories.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
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
                    key: const ValueKey('experience-thumbnail-field'),
                    decoration: _inputDecoration(
                      label: 'Documentation Image URL',
                      hint: 'https://example.com/activity.jpg',
                    ),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.next,
                    onChanged: (String value) {
                      _thumbnail = value;
                    },
                    validator: _validateThumbnail,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const ValueKey('experience-skills-field'),
                    decoration: _inputDecoration(
                      label: 'Related Skills',
                      hint: 'Contoh: Teaching, Communication, Teamwork',
                      helperText: 'Pisahkan beberapa skill dengan koma.',
                    ),
                    textInputAction: TextInputAction.done,
                    maxLength: 255,
                    onChanged: (String value) {
                      _skills = value;
                    },
                    validator: (String? value) => _validateText(
                      value,
                      fieldName: 'Related skills',
                      maxLength: 255,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    key: const ValueKey('save-experience-button'),
                    onPressed: _submitForm,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Simpan'),
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
