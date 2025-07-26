import 'community_forum_screen.dart';
import 'study_centers_screen.dart' as sc_screen;
import '../widgets/study_center_carousel.dart' as sc_widget;
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
    const _HomeTab(),
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
  static final List<Map<String, String>> forumItems = [
    {
      'title': 'How to prepare for KCSE?',
      'description': 'Tips and strategies for KCSE preparation.',
    },
    {
      'title': 'Best revision materials?',
      'description': 'Discover top resources for effective revision.',
    },
    {
      'title': 'Share your study tips!',
      'description': 'Exchange study techniques with peers.',
    },
    {
      'title': 'Exam stress management',
      'description': 'Learn ways to cope with exam stress.',
    },
    {
      'title': 'Subject recommendations',
      'description': 'Get advice on choosing subjects.',
    },
  ];

  static final List<sc_widget.StudyCenter> centers = [
    sc_widget.StudyCenter(
      name: 'Lagos Study Center',
      city: 'Lagos',
      address: '123 Allen Avenue, Ikeja',
      description:
          'A modern study center in Lagos with free WiFi and resources.',
    ),
    sc_widget.StudyCenter(
      name: 'Abuja Study Center',
      city: 'Abuja',
      address: '456 Central Area, Abuja',
      description: 'Spacious center with group study rooms and a library.',
    ),
    sc_widget.StudyCenter(
      name: 'Kano Study Center',
      city: 'Kano',
      address: '789 Zaria Road, Kano',
      description: 'Well-equipped center for collaborative learning.',
    ),
  ];

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

  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final userName =
        Supabase.instance.client.auth.currentUser?.userMetadata?['name'] ??
        'Learner';
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
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: CustomScrollView(
                    slivers: [
                      // Header
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: isWide ? 48 : 38,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.school,
                                        color: Color(0xFF2563EB),
                                        size: isWide ? 60 : 44,
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Welcome back,',
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.85,
                                            ),
                                            fontSize: isWide ? 36 : 26,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          userName,
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 1.0,
                                            ),
                                            fontWeight: FontWeight.bold,
                                            fontSize: isWide ? 48 : 32,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    '😊',
                                    style: TextStyle(
                                      fontSize: isWide ? 64 : 44,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 28),
                            // Search bar
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 12,
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
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 18,
                                    horizontal: 18,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(
                                      color: Color(0xFF2563EB),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                style: TextStyle(fontSize: isWide ? 18 : 15),
                              ),
                            ),
                            const SizedBox(height: 18),
                          ],
                        ),
                      ),
                      // Subject chips
                      SliverToBoxAdapter(
                        child: SizedBox(
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
                      ),
                      SliverToBoxAdapter(child: const SizedBox(height: 32)),
                      // Featured carousel
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            SizedBox(
                              height: isWide ? 320 : 240,
                              child: CarouselSlider.builder(
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
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(
                                              0xFF60A5FA,
                                            ).withAlpha((255 * 0.15).round()),
                                            Colors.white,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: SingleChildScrollView(
                                        physics: NeverScrollableScrollPhysics(),
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
                                            const SizedBox(height: 16),
                                            ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(
                                                  0xFF2563EB,
                                                ),
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              onPressed: () async {
                                                if (!context.mounted) return;
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
                            ),
                            const SizedBox(height: 36),
                          ],
                        ),
                      ),
                      // Recent uploads
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                  return const Center(
                                    child: Text(
                                      'Failed to load recent uploads.',
                                    ),
                                  );
                                }
                                final materials = snapshot.data ?? [];
                                if (materials.isEmpty) {
                                  return const Center(
                                    child: Text('No recent uploads.'),
                                  );
                                }
                                final recent =
                                    materials.reversed.take(10).toList();
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                    height: isWide ? 320 : 240,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: recent.length,
                                      separatorBuilder:
                                          (_, i) =>
                                              SizedBox(width: isWide ? 24 : 12),
                                      itemBuilder: (context, i) {
                                        final mat = recent[i];
                                        return Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          elevation: 6,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          child: Container(
                                            width: isWide ? 320 : 220,
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFF60A5FA).withAlpha(
                                                    (255 * 0.15).round(),
                                                  ),
                                                  Colors.white,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
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
                                                const SizedBox(height: 16),
                                                ElevatedButton.icon(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Color(
                                                      0xFF2563EB,
                                                    ),
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    if (!context.mounted) {
                                                      return;
                                                    }
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
                                                      int selectedRating = 0;
                                                      if (!context.mounted) {
                                                        return;
                                                      }
                                                      await showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                              'Rate this material',
                                                            ),
                                                            content: StatefulBuilder(
                                                              builder: (
                                                                context,
                                                                setState,
                                                              ) {
                                                                return Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: List.generate(5, (
                                                                    star,
                                                                  ) {
                                                                    return IconButton(
                                                                      icon: Icon(
                                                                        Icons
                                                                            .star,
                                                                        color:
                                                                            star <
                                                                                    selectedRating
                                                                                ? Colors.amber
                                                                                : Colors.grey[400],
                                                                        size:
                                                                            32,
                                                                      ),
                                                                      onPressed: () {
                                                                        setState(() {
                                                                          selectedRating =
                                                                              star +
                                                                              1;
                                                                        });
                                                                      },
                                                                    );
                                                                  }),
                                                                );
                                                              },
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                    context,
                                                                  ).pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                      'Cancel',
                                                                    ),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed:
                                                                    selectedRating >
                                                                            0
                                                                        ? () async {
                                                                          await SupabaseCrudService(
                                                                            Supabase.instance.client,
                                                                          ).updateMaterialRating(
                                                                            mat.id,
                                                                            selectedRating.toDouble(),
                                                                          );
                                                                          if (!context
                                                                              .mounted) {
                                                                            return;
                                                                          }
                                                                          Navigator.of(
                                                                            context,
                                                                          ).pop();
                                                                          ScaffoldMessenger.of(
                                                                            context,
                                                                          ).showSnackBar(
                                                                            SnackBar(
                                                                              content: Text(
                                                                                'Thanks for rating $selectedRating star${selectedRating > 1 ? 's' : ''}!',
                                                                              ),
                                                                              backgroundColor:
                                                                                  Colors.green,
                                                                            ),
                                                                          );
                                                                        }
                                                                        : null,
                                                                child:
                                                                    const Text(
                                                                      'Submit',
                                                                    ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    } else {
                                                      if (!context.mounted) {
                                                        return;
                                                      }
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
                                                  icon: const Icon(
                                                    Icons.download,
                                                  ),
                                                  label: const Text('Download'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                      // Community Forum Cards
                      SliverToBoxAdapter(
                        child: Container(
                          color: const Color(
                            0xFFE3F2FD,
                          ), // Light blue background for visibility
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Community Forum',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2563EB),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: isWide ? 200 : 150,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: forumItems.length,
                                  separatorBuilder:
                                      (_, _) => const SizedBox(width: 12),
                                  itemBuilder: (context, index) {
                                    final forum = forumItems[index];
                                    return GestureDetector(
                                      onTap: () {
                                        if (!context.mounted) return;
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (_) => CommunityForumScreen(),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        elevation: 4,
                                        child: Container(
                                          width: isWide ? 300 : 200,
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.forum,
                                                    color: Color(0xFF2563EB),
                                                    size: isWide ? 32 : 24,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      forum['title']!,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            isWide ? 18 : 14,
                                                        color: Color(
                                                          0xFF2563EB,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                forum['description']!,
                                                style: TextStyle(
                                                  fontSize: isWide ? 14 : 12,
                                                  color: Colors.black87,
                                                ),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Study Centers Section
                      SliverToBoxAdapter(
                        child: Container(
                          color: const Color(
                            0xFFE3F2FD,
                          ), // Light blue background for visibility
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Study Centers',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2563EB),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Column(
                                children:
                                    centers.asMap().entries.map((entry) {
                                      final center = entry.value;
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (!context.mounted) return;
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (_) =>
                                                        sc_screen.StudyCentersScreen(),
                                              ),
                                            );
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            elevation: 4,
                                            child: Container(
                                              width: double.infinity,
                                              height:
                                                  isWide
                                                      ? 220
                                                      : 180, // Increased height
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Color(
                                                          0xFF2563EB,
                                                        ),
                                                        size: isWide ? 32 : 24,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          center.name,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                isWide
                                                                    ? 20
                                                                    : 16,
                                                            color: Color(
                                                              0xFF2563EB,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    center.city,
                                                    style: TextStyle(
                                                      fontSize:
                                                          isWide ? 16 : 14,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    center.address,
                                                    style: TextStyle(
                                                      fontSize:
                                                          isWide ? 14 : 12,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    center.description,
                                                    style: TextStyle(
                                                      fontSize:
                                                          isWide ? 14 : 12,
                                                      color: Colors.black87,
                                                    ),
                                                    maxLines: 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                              const SizedBox(height: 24),
                            ],
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
      ),
    );
  }
}
