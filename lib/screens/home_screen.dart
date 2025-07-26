import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/material.dart';
import '../services/supabase_crud_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'search_screen.dart';
import 'upload_screen.dart';
import 'chatbot_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    _HomeTab(),
    const SearchScreen(),
    const UploadScreen(),
    const ChatbotScreen(),
    const MapScreen(),
    const ProfileScreen(),
  ];

  Widget _buildSafePage(int index) {
    try {
      return _pages[index];
    } catch (e, st) {
      debugPrint('Error building page $index: $e\n$st');
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              const Text('Something went wrong loading this page.'),
              const SizedBox(height: 8),
              Text('$e', style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Material Downloader'),
        backgroundColor: const Color(0xFF2563EB),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: List.generate(_pages.length, (i) => _buildSafePage(i)),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          height: 68,
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          backgroundColor: Colors.transparent,
          indicatorColor: const Color(0xFF2563EB).withValues(alpha: 0.08),
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Icon(Icons.upload_file_outlined),
              selectedIcon: Icon(Icons.upload_file),
              label: 'Upload',
            ),
            NavigationDestination(
              icon: Icon(Icons.smart_toy_outlined),
              selectedIcon: Icon(Icons.smart_toy),
              label: 'Chatbot',
            ),
            NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map),
              label: 'Map',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  static final List<LearningMaterial> featuredMaterials = [
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
    LearningMaterial(
      id: '3',
      title: 'Kiswahili Insha Samples',
      subject: 'Kiswahili',
      description: 'Best Insha samples for KCSE preparation.',
      fileUrl: '',
      rating: 4.7,
      downloads: 800,
      size: 300,
      uploaderId: 'user3',
      tags: ['Insha', 'Kiswahili'],
    ),
    LearningMaterial(
      id: '4',
      title: 'Geography Revision Kit',
      subject: 'Geography',
      description: 'A complete revision kit for Geography.',
      fileUrl: '',
      rating: 4.5,
      downloads: 700,
      size: 350,
      uploaderId: 'user4',
      tags: ['Geography', 'Revision'],
    ),
    LearningMaterial(
      id: '5',
      title: 'Form 1 Physics Notes',
      subject: 'Physics',
      description: 'Comprehensive notes for Form 1 Physics.',
      fileUrl: '',
      rating: 4.4,
      downloads: 600,
      size: 280,
      uploaderId: 'user5',
      tags: ['Physics', 'Notes'],
    ),
    LearningMaterial(
      id: '6',
      title: 'English Set Books Guide',
      subject: 'English',
      description: 'Guide to KCSE English set books.',
      fileUrl: '',
      rating: 4.3,
      downloads: 500,
      size: 200,
      uploaderId: 'user6',
      tags: ['English', 'Set Books'],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final userMeta = Supabase.instance.client.auth.currentUser?.userMetadata;
    String userName = 'Learner';
    if (userMeta != null) {
      final fullName = userMeta['name'] ?? userMeta['full_name'] ?? '';
      if (fullName is String && fullName.trim().isNotEmpty) {
        userName = fullName.trim().split(' ').first;
      }
      final firstName = userMeta['first_name'];
      if (firstName is String && firstName.trim().isNotEmpty) {
        userName = firstName.trim();
      }
    }
    final subjects = [
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
    // Removed unused selectedSubject
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2563EB), Color(0xFF60A5FA), Color(0xFFF1F5F9)],
        ),
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 900;
            final horizontalPadding = isWide ? 64.0 : 16.0;
            final verticalPadding = isWide ? 40.0 : 16.0;
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWide ? 1400 : double.infinity,
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 36,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.school,
                                    color: Color(0xFF2563EB),
                                    size: 48,
                                  ),
                                ),
                                const SizedBox(width: 22),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome,',
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.85,
                                        ),
                                        fontSize: isWide ? 32 : 26,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      userName,
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 1.0,
                                        ),
                                        fontWeight: FontWeight.bold,
                                        fontSize: isWide ? 40 : 32,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Text(
                              '😊',
                              style: TextStyle(fontSize: 56),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        // Search bar
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText:
                                  'Search for materials, topics, or authors...',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Color(0xFF2563EB),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 18,
                                horizontal: 18,
                              ),
                            ),
                            style: TextStyle(fontSize: isWide ? 18 : 15),
                          ),
                        ),
                        const SizedBox(height: 18),
                        // Subject chips
                        SizedBox(
                          height: 44,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: subjects.length,
                            separatorBuilder:
                                (_, i) => const SizedBox(width: 10),
                            itemBuilder:
                                (context, i) => ChoiceChip(
                                  label: Text(subjects[i]),
                                  selected: false,
                                  onSelected: (_) {},
                                  selectedColor: const Color(0xFF2563EB),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: isWide ? 16 : 14,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 8,
                                  ),
                                ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Top Downloaded Materials
                        Text(
                          'Top Downloaded Materials',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Placeholder for top downloaded materials
                        Container(
                          height: isWide ? 180 : 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Top downloaded materials will appear here.',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Recommended for You
                        Text(
                          'Recommended for You',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Placeholder for recommended materials
                        Container(
                          height: isWide ? 180 : 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Personalized recommendations will appear here.',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Community Highlights
                        Text(
                          'Community Highlights',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Placeholder for community highlights
                        Container(
                          height: isWide ? 120 : 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Top contributors and trending tips will appear here.',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Feedback & Suggestions
                        Text(
                          'Feedback & Suggestions',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'We value your feedback! Let us know what materials you need or how we can improve.',
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Type your feedback or request here...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                ),
                                maxLines: 2,
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2563EB),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('Submit'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Featured carousel
                        Text(
                          'Featured Materials',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(height: 16),
                        CarouselSlider.builder(
                          itemCount: featuredMaterials.length,
                          itemBuilder: (context, i, _) {
                            final mat = featuredMaterials[i];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 6,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: SizedBox(
                                height: isWide ? 320 : 240,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF60A5FA).withAlpha((255 * 0.15).round()),
                                        Colors.white,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            mat.title,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: isWide ? 22 : 18,
                                              color: Color(0xFF2563EB),
                                            ),
                                          ),
                                          const SizedBox(height: 9),
                                          Text(
                                            mat.description,
                                            style: TextStyle(
                                              fontSize: isWide ? 16 : 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.book,
                                                color: Color(0xFF2563EB),
                                                size: 20,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                mat.subject,
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              const SizedBox(width: 18),
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                mat.rating.toString(),
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF2563EB),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () async {
                                            final url = mat.fileUrl;
                                            if (url.isNotEmpty && await canLaunchUrl(Uri.parse(url))) {
                                              await launchUrl(
                                                Uri.parse(url),
                                                mode: LaunchMode.externalApplication,
                                              );
                                            } else {
                                              if (!context.mounted) return;
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Could not launch file URL.'),
                                                ),
                                              );
                                            }
                                          },
                                          icon: const Icon(Icons.download),
                                          label: const Text('Download'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: isWide ? 320 : 240,
                            viewportFraction: isWide ? 0.3 : 0.8,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 5),
                          ),
                        ),
                        const SizedBox(height: 36),
                        // Recent uploads
                        Text(
                          'Recently Added',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(height: 16),
                        FutureBuilder<List<LearningMaterial>>(
                          future:
                              SupabaseCrudService(
                                Supabase.instance.client,
                              ).fetchMaterials(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Failed to load recent uploads.'),
                              );
                            }
                            final materials = snapshot.data ?? [];
                            if (materials.isEmpty) {
                              return const Center(
                                child: Text('No recent uploads.'),
                              );
                            }
                            final recent = materials.reversed.take(10).toList();
                            return SizedBox(
                              height: isWide ? 220 : 160,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: recent.length,
                                separatorBuilder:
                                    (_, i) => SizedBox(width: isWide ? 24 : 12),
                                itemBuilder: (context, i) {
                                  final mat = recent[i];
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    elevation: 4,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: Container(
                                      width: isWide ? 320 : 220,
                                      padding: const EdgeInsets.all(18),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            mat.title,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: isWide ? 18 : 15,
                                              color: Color(0xFF2563EB),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            mat.description,
                                            style: TextStyle(
                                              fontSize: isWide ? 15 : 13,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.book,
                                                color: Color(0xFF2563EB),
                                                size: 18,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                mat.subject,
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                mat.rating.toString(),
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(
                                                0xFF2563EB,
                                              ),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () async {
                                              final url = mat.fileUrl;
                                              if (url.isNotEmpty &&
                                                  await canLaunchUrl(
                                                    Uri.parse(url),
                                                  )) {
                                                await launchUrl(
                                                  Uri.parse(url),
                                                  mode:
                                                      LaunchMode
                                                          .externalApplication,
                                                );
                                              } else {
                                                if (!context.mounted) return;
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Could not launch file URL.',
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            icon: const Icon(Icons.download),
                                            label: const Text('Download'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} // End of _HomeTab
