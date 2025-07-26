import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_crud_service.dart';
import 'dart:math';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? _fileName;
  String? _subject;
  final List<String> _subjects = [
    'Mathematics',
    'English',
    'Kiswahili',
    'Physics',
    'Chemistry',
    'Biology',
    'Geography',
    'History',
    'Business',
    'CRE',
  ];
  bool _uploading = false;
  String? _uploadStatus;

  Map<String, String?> _user = {};
  bool _loadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await AuthService().getCurrentUser();
      if (!mounted) return;
      setState(() {
        _user = user;
        _loadingUser = false;
      });
    } catch (e, st) {
      debugPrint('Error loading user: $e\n$st');
      if (!mounted) return;
      setState(() {
        _user = {};
        _loadingUser = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load user data.')),
      );
    }
  }

  PlatformFile? _pickedFile;
  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pickedFile = result.files.first;
        _fileName = _pickedFile!.name;
      });
    }
  }

  void _upload() async {
    if (_pickedFile == null || _subject == null) {
      setState(() => _uploadStatus = 'Please select a file and subject.');
      return;
    }
    setState(() {
      _uploading = true;
      _uploadStatus = null;
    });
    try {
      final supabase = Supabase.instance.client;
      final storagePath = 'materials/${DateTime.now().millisecondsSinceEpoch}_${_pickedFile!.name}';
      // Upload file to Supabase Storage
      final storageResponse = await supabase.storage.from('materials').uploadBinary(
        storagePath,
        _pickedFile!.bytes!,
        fileOptions: const FileOptions(upsert: true),
      );
      if (storageResponse.isEmpty) throw Exception('Failed to upload file to storage');
      final publicUrl = supabase.storage.from('materials').getPublicUrl(storagePath);

      // Save metadata to DB
      final material = LearningMaterial(
        id: '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}',
        title: _fileName!,
        subject: _subject!,
        description: 'Uploaded by ${_user['name'] ?? 'Unknown'}',
        fileUrl: publicUrl,
        rating: 0.0,
        downloads: 0,
        size: (_pickedFile!.size / 1024).round(),
        uploaderId: _user['email'] ?? 'unknown',
        tags: [],
      );
      final crud = SupabaseCrudService(supabase);
      await crud.addMaterial(material);

      if (!mounted) return;
      setState(() {
        _uploading = false;
        _uploadStatus = 'Upload successful!';
        _fileName = null;
        _pickedFile = null;
        _subject = null;
      });
    } catch (e, st) {
      debugPrint('Error uploading: $e\n$st');
      if (!mounted) return;
      setState(() {
        _uploading = false;
        _uploadStatus = 'Upload failed!';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to upload file.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Material'),
        backgroundColor: const Color(0xFF2563EB),
      ),
      body:
          _loadingUser
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 700;
                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isWide ? 500 : double.infinity,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(isWide ? 40 : 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if ((_user['name']?.isNotEmpty ?? false) ||
                                (_user['email']?.isNotEmpty ?? false))
                              Container(
                                width: double.infinity,
                                color: Colors.blue.shade50,
                                padding: EdgeInsets.symmetric(
                                  vertical: isWide ? 18 : 12,
                                  horizontal: isWide ? 32 : 16,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.account_circle,
                                      color: Color(0xFF2563EB),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (_user['name'] != null &&
                                              _user['name']!.isNotEmpty)
                                            Text(
                                              _user['name']!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          if (_user['email'] != null &&
                                              _user['email']!.isNotEmpty)
                                            Text(
                                              _user['email']!,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black54,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Text(
                              'Select File',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontSize: isWide ? 22 : null),
                            ),
                            SizedBox(height: isWide ? 18 : 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isWide ? 24 : 16,
                                      vertical: isWide ? 18 : 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(
                                        isWide ? 14 : 10,
                                      ),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Text(
                                      _fileName ?? 'No file selected',
                                      style: TextStyle(
                                        fontSize: isWide ? 17 : 15,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: isWide ? 20 : 12),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: ElevatedButton.icon(
                                    onPressed: _uploading ? null : _pickFile,
                                    icon: const Icon(Icons.attach_file),
                                    label: const Text('Pick File'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2563EB),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isWide ? 24 : 12,
                                        vertical: isWide ? 16 : 10,
                                      ),
                                      textStyle: TextStyle(
                                        fontSize: isWide ? 16 : 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: isWide ? 32 : 24),
                            Text(
                              'Select Subject',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontSize: isWide ? 22 : null),
                            ),
                            SizedBox(height: isWide ? 18 : 12),
                            DropdownButtonFormField<String>(
                              value: _subject,
                              items:
                                  _subjects
                                      .map(
                                        (s) => DropdownMenuItem(
                                          value: s,
                                          child: Text(s),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  _uploading
                                      ? null
                                      : (v) => setState(() => _subject = v),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    isWide ? 14 : 8,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: isWide ? 18 : 12,
                                  vertical: isWide ? 14 : 8,
                                ),
                              ),
                              style: TextStyle(fontSize: isWide ? 17 : 15),
                            ),
                            SizedBox(height: isWide ? 40 : 32),
                            SizedBox(
                              width: double.infinity,
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: ElevatedButton(
                                  onPressed: _uploading ? null : _upload,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2563EB),
                                    padding: EdgeInsets.symmetric(
                                      vertical: isWide ? 20 : 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        isWide ? 12 : 8,
                                      ),
                                    ),
                                    textStyle: TextStyle(
                                      fontSize: isWide ? 18 : 16,
                                    ),
                                  ),
                                  child:
                                      _uploading
                                          ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                          : const Text('Upload'),
                                ),
                              ),
                            ),
                            if (_uploadStatus != null)
                              Padding(
                                padding: EdgeInsets.only(top: isWide ? 24 : 16),
                                child: Text(
                                  _uploadStatus!,
                                  style: TextStyle(
                                    color:
                                        _uploadStatus == 'Upload successful!'
                                            ? Colors.green
                                            : Colors.red,
                                    fontSize: isWide ? 17 : 15,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
