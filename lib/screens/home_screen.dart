
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import '../models/material.dart';
import '../services/supabase_crud_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'community_forum_screen.dart';
import 'search_screen.dart';
import 'upload_screen.dart';
import 'chat_page.dart';
import 'map_screen.dart';
import 'profile_screen.dart';
import '../widgets/app_nav_bar.dart';
import 'study_centers_screen.dart' as sc_screen;
import '../widgets/study_center_carousel.dart' as sc_widget;

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
    const ChatPage(),
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
      bottomNavigationBar: AppNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
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
      name: 'Nairobi Study Center',
      city: 'Nairobi',
      address: 'Kenyatta Avenue, Nairobi',
      description: 'Modern center in Nairobi with WiFi and digital library.',
    ),
    sc_widget.StudyCenter(
      name: 'Mombasa Study Center',
      city: 'Mombasa',
      address: 'Moi Avenue, Mombasa',
      description: 'Coastal study center with group rooms and resources.',
    ),
    sc_widget.StudyCenter(
      name: 'Kisumu Study Center',
      city: 'Kisumu',
      address: 'Oginga Odinga St, Kisumu',
      description: 'Lake region center with collaborative spaces.',
    ),
    sc_widget.StudyCenter(
      name: 'Nakuru Study Center',
      city: 'Nakuru',
      address: 'Kenyatta Ave, Nakuru',
      description: 'Central Rift study center with modern amenities.',
    ),
    sc_widget.StudyCenter(
      name: 'Eldoret Study Center',
      city: 'Uasin Gishu',
      address: 'Ronald Ngala St, Eldoret',
      description: 'North Rift center with digital resources.',
    ),
    sc_widget.StudyCenter(
      name: 'Thika Study Center',
      city: 'Kiambu',
      address: 'Commercial St, Thika',
      description: 'Kiambu county center for collaborative learning.',
    ),
  ];
  
  static final List<LearningMaterial> featuredMaterials = [
    LearningMaterial(
      id: '1',
      title: 'KCSE 2024 Mathematics Paper 1',
      subject: 'Mathematics',
      description: 'Latest KCSE Paper 1 with marking scheme.',
      fileUrl:
          'https://educationnewshub.co.ke/wp-content/uploads/2024/03/Mathematics-Paper-1-KCSE-2023.pdf', // Example from educationnewshub.co.ke
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
      fileUrl:
          'https://teacher.co.ke/wp-content/uploads/2020/03/Chemistry-Form-2-Notes.pdf', // Example from teacher.co.ke
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
      fileUrl:
          'https://educationnewshub.co.ke/wp-content/uploads/2023/05/Kiswahili-Insha-KCSE-2022.pdf', // Example from educationnewshub.co.ke
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
      fileUrl:
          'https://educationnewshub.co.ke/wp-content/uploads/2024/02/Geography-Revision-Kit-KCSE.pdf', // Example from educationnewshub.co.ke
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
      fileUrl:
          'https://teacher.co.ke/wp-content/uploads/2020/03/Physics-Form-1-Notes.pdf', // Example from teacher.co.ke
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
      fileUrl:
          'https://educationnewshub.co.ke/wp-content/uploads/2023/06/English-Set-Books-Guide-KCSE.pdf', // Example from educationnewshub.co.ke
      rating: 4.3,
      downloads: 500,
      size: 200,
      uploaderId: 'user6',
      tags: ['English', 'Set Books'],
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredForumItems = forumItems;
  List<sc_widget.StudyCenter> _filteredCenters = centers;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCards);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCards() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredForumItems =
          forumItems.where((forum) {
            final title = forum['title']!.toLowerCase();
            final description = forum['description']!.toLowerCase();
            return title.contains(query) || description.contains(query);
          }).toList();

      _filteredCenters =
          centers.where((center) {
            final name = center.name.toLowerCase();
            final city = center.city.toLowerCase();
            final description = center.description.toLowerCase();
            return name.contains(query) ||
                city.contains(query) ||
                description.contains(query);
          }).toList();
    });
  }

  Future<void> _downloadMaterial(LearningMaterial mat) async {
    if (!mounted) return;
    final url = mat.fileUrl;
    if (url.isNotEmpty) {
      try {
        final taskId = await FlutterDownloader.enqueue(
          url: url,
          savedDir: '/storage/emulated/0/Download',
          fileName: '${mat.title.replaceAll(' ', '_')}.pdf',
          showNotification: true,
          openFileFromNotification: true,
        );
        if (taskId == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to start download.')),
          );
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Download started. Check notifications.'),
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Download error: $e')));
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No file URL provided.')));
    }
  }

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
                                        color: const Color(0xFF2563EB),
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
                                            color: Colors.white.withOpacity(
                                              0.85,
                                            ),
                                            fontSize: isWide ? 36 : 26,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          userName,
                                          style: TextStyle(
                                            color: Colors.white,
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
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 12,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search forums or study centers...',
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Color(0xFF2563EB),
                                  ),
                                  suffixIcon:
                                      _searchController.text.isNotEmpty
                                          ? IconButton(
                                            icon: const Icon(
                                              Icons.clear,
                                              color: Color(0xFF2563EB),
                                            ),
                                            onPressed: () {
                                              _searchController.clear();
                                              _filterCards();
                                            },
                                          )
                                          : null,
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                    horizontal: 18,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: const BorderSide(
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 8,
                                  ),
                                ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(child: const SizedBox(height: 32)),
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
                                            const Color(
                                              0xFF60A5FA,
                                            ).withOpacity(0.15),
                                            Colors.white,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: SingleChildScrollView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
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
                                                color: const Color(0xFF2563EB),
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
                                                const Icon(
                                                  Icons.book,
                                                  color: Color(0xFF2563EB),
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  mat.subject,
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                const SizedBox(width: 18),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  mat.rating.toStringAsFixed(1),
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(
                                                  0xFF2563EB,
                                                ),
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              onPressed:
                                                  () => _downloadMaterial(mat),
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
                                        return GestureDetector(
                                          onTap: () => _downloadMaterial(mat),
                                          child: Card(
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
                                                    const Color(
                                                      0xFF60A5FA,
                                                    ).withOpacity(0.15),
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
                                                    color: const Color(
                                                      0xFF2563EB,
                                                    ),
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
                                                    const Icon(
                                                      Icons.book,
                                                      color: Color(0xFF2563EB),
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      mat.subject,
                                                      style: const TextStyle(
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 18),
                                                    const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      mat.rating
                                                          .toStringAsFixed(1),
                                                      style: const TextStyle(
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 16),
                                                ElevatedButton.icon(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF2563EB),
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
                                                    await _downloadMaterial(
                                                      mat,
                                                    );
                                                    if (!mounted) return;
                                                    int selectedRating = 0;
                                                    final dialogContext =
                                                        context;
                                                    await showDialog(
                                                      context: dialogContext,
                                                      builder: (context) {
                                                        return StatefulBuilder(
                                                          builder: (
                                                            context,
                                                            setState,
                                                          ) {
                                                            int hoverRating = 0;
                                                            return AlertDialog(
                                                              title: const Text(
                                                                'Rate this material',
                                                              ),
                                                              content: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: List.generate(5, (
                                                                      star,
                                                                    ) {
                                                                      return MouseRegion(
                                                                        onEnter: (
                                                                          _,
                                                                        ) {
                                                                          setState(() {
                                                                            hoverRating =
                                                                                star +
                                                                                1;
                                                                          });
                                                                        },
                                                                        onExit: (
                                                                          _,
                                                                        ) {
                                                                          setState(() {
                                                                            hoverRating =
                                                                                0;
                                                                          });
                                                                        },
                                                                        child: IconButton(
                                                                          icon: Icon(
                                                                            Icons.star,
                                                                            color:
                                                                                (hoverRating >
                                                                                            0
                                                                                        ? star <
                                                                                            hoverRating
                                                                                        : star <
                                                                                            selectedRating)
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
                                                                        ),
                                                                      );
                                                                    }),
                                                                  ),
                                                                ],
                                                              ),
                                                              actions: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    TextButton(
                                                                      onPressed: () {
                                                                        Navigator.of(
                                                                          context,
                                                                        ).pop();
                                                                      },
                                                                      child: const Text(
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
                                                                                if (!mounted) return;
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
                                                                                setState(
                                                                                  () {
                                                                                    mat.rating = selectedRating.toDouble();
                                                                                  },
                                                                                );
                                                                              }
                                                                              : null,
                                                                      child: const Text(
                                                                        'Submit',
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                    );
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
                      SliverToBoxAdapter(
                        child: Container(
                          color: const Color(0xFFE3F2FD),
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
                              _filteredForumItems.isEmpty
                                  ? const Center(
                                    child: Text('No forums match your search.'),
                                  )
                                  : SizedBox(
                                    height: isWide ? 200 : 150,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _filteredForumItems.length,
                                      separatorBuilder:
                                          (context, index) =>
                                              const SizedBox(width: 12),
                                      itemBuilder: (context, index) {
                                        final forum =
                                            _filteredForumItems[index];
                                        return GestureDetector(
                                          onTap: () {
                                            if (!mounted) return;
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (_) =>
                                                        CommunityForumScreen(),
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
                                              width: isWide ? 300 : 200,
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.forum,
                                                        color: Color(
                                                          0xFF2563EB,
                                                        ),
                                                        size: 24,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          forum['title']!,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                isWide
                                                                    ? 18
                                                                    : 14,
                                                            color: const Color(
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
                                                      fontSize:
                                                          isWide ? 14 : 12,
                                                      color: Colors.black87,
                                                    ),
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                      SliverToBoxAdapter(
                        child: Container(
                          color: const Color(0xFFE3F2FD),
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
                              _filteredCenters.isEmpty
                                  ? const Center(
                                    child: Text(
                                      'No study centers match your search.',
                                    ),
                                  )
                                  : Column(
                                    children: [
                                      ..._filteredCenters.take(3).map((center) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              if (!mounted) return;
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
                                                height: isWide ? 220 : 180,
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.location_on,
                                                          color: Color(
                                                            0xFF2563EB,
                                                          ),
                                                          size: 24,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            center.name,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  isWide
                                                                      ? 20
                                                                      : 16,
                                                              color:
                                                                  const Color(
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
                                      }),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF2563EB,
                                              ),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () {
                                              if (!mounted) return;
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) =>
                                                          sc_screen.StudyCentersScreen(),
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.list),
                                            label: const Text(
                                              'View All Study Centers',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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
