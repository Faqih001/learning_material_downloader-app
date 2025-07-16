import 'package:flutter/material.dart';
import '../models/material.dart';
import '../widgets/material_card.dart';
import '../services/auth_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedSubject = 'All';
  final List<String> _subjects = [
    'All',
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

  final List<LearningMaterial> _allMaterials = [
    LearningMaterial(
      id: '1',
      title: 'KCSE 2024 Mathematics Paper 1',
      subject: 'Mathematics',
      description: 'Latest KCSE Paper 1 with marking scheme.',
      fileUrl: '',
      rating: 4.8,
      downloads: 1200,
      size: 512,
      uploaderId: 'user1',
      tags: ['KCSE', '2024', 'Math'],
    ),
    LearningMaterial(
      id: '2',
      title: 'Form 2 Chemistry Notes',
      subject: 'Chemistry',
      description: 'Comprehensive notes for Form 2 Chemistry.',
      fileUrl: '',
      rating: 4.6,
      downloads: 900,
      size: 420,
      uploaderId: 'user2',
      tags: ['Notes', 'Chemistry'],
    ),
    // ...add more mock materials as needed
  ];

  Map<String, String?> _user = {};
  bool _loadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await AuthService().getCurrentUser();
    setState(() {
      _user = user;
      _loadingUser = false;
    });
  }

  List<LearningMaterial> get _filteredMaterials {
    return _allMaterials.where((m) {
      final matchesQuery =
          _query.isEmpty ||
          m.title.toLowerCase().contains(_query.toLowerCase());
      final matchesSubject =
          _selectedSubject == 'All' || m.subject == _selectedSubject;
      return matchesQuery && matchesSubject;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Materials'),
        backgroundColor: const Color(0xFF2563EB),
      ),
      body: _loadingUser
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if ((_user['name']?.isNotEmpty ?? false) || (_user['email']?.isNotEmpty ?? false))
                    Container(
                      width: double.infinity,
                      color: Colors.blue.shade50,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.account_circle, color: Color(0xFF2563EB)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_user['name'] != null && _user['name']!.isNotEmpty)
                                  Text(_user['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                                if (_user['email'] != null && _user['email']!.isNotEmpty)
                                  Text(_user['email']!, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for materials...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _subjects.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) => ChoiceChip(
                        label: Text(_subjects[i]),
                        selected: _selectedSubject == _subjects[i],
                        onSelected: (selected) {
                          setState(() => _selectedSubject = _subjects[i]);
                        },
                        selectedColor: const Color(0xFF2563EB),
                        labelStyle: TextStyle(
                          color: _selectedSubject == _subjects[i]
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _filteredMaterials.isEmpty
                        ? const Center(child: Text('No materials found.'))
                        : ListView.builder(
                            itemCount: _filteredMaterials.length,
                            itemBuilder: (context, i) => MaterialCard(
                              material: _filteredMaterials[i],
                              onDownload: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Downloading ${_filteredMaterials[i].title}...',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
