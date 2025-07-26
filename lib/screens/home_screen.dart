import 'package:flutter/material.dart';

import '../models/material.dart';
import '../services/supabase_crud_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/material_card.dart';
import '../widgets/custom_button.dart';
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
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final List<String> topSubjects = [
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

    Widget sectionTitle(String title) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        final horizontalPadding = isWide ? 64.0 : 16.0;
        final verticalPadding = isWide ? 40.0 : 16.0;
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWide ? 1400 : double.infinity,
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ...existing code...
                      sectionTitle('Recently Added'),
                      FutureBuilder<List<LearningMaterial>>(
                        future: SupabaseCrudService(Supabase.instance.client).fetchMaterials(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text('Failed to load recent uploads.'));
                          }
                          final materials = snapshot.data ?? [];
                          if (materials.isEmpty) {
                            return const Center(child: Text('No recent uploads.'));
                          }
                          final recent = materials.reversed.take(10).toList();
                          return SizedBox(
                            height: isWide ? 220 : 160,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: recent.length,
                              separatorBuilder: (_, __) => SizedBox(width: isWide ? 24 : 12),
                              itemBuilder: (context, i) => SizedBox(
                                width: isWide ? 320 : 220,
                                child: MaterialCard(
                                  material: recent[i],
                                  onDownload: () {},
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // ...existing code...
        final isWide = constraints.maxWidth > 900;
        // gridCount is not used, so removed.
        final horizontalPadding = isWide ? 64.0 : 16.0;
        final verticalPadding = isWide ? 40.0 : 16.0;
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWide ? 1400 : double.infinity,
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Modern AppBar substitute
                      Row(
                        children: [
                          CircleAvatar(
                            radius: isWide ? 36 : 28,
                            backgroundColor: const Color(0xFF2563EB),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: isWide ? 32 : 22,
                            ),
                          ),
                          SizedBox(width: isWide ? 28 : 16),
                          Expanded(
                            child: Text(
                              'Welcome back!\nFind the best learning materials for your studies.',
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(
                                fontSize: isWide ? 26 : 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.notifications_none,
                              size: isWide ? 32 : 24,
                            ),
                            onPressed: () {},
                            tooltip: 'Notifications',
                          ),
                          IconButton(
                            icon: Icon(Icons.search, size: isWide ? 32 : 24),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SearchScreen(),
                                ),
                              );
                            },
                            tooltip: 'Search',
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Animated Carousel
                      CarouselSlider(
                        options: CarouselOptions(
                          height: isWide ? 260 : 180,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: isWide ? 0.45 : 0.85,
                          enableInfiniteScroll: true,
                        ),
                        items:
                            featuredMaterials.map((mat) {
                              return Builder(
                                builder:
                                    (context) => Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      elevation: 8,
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(
                                          isWide ? 32 : 16,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          gradient: LinearGradient(
                                            colors: [
                                              const Color(
                                                0xFF2563EB,
                                              ).withValues(alpha: 0.9),
                                              const Color(
                                                0xFF60A5FA,
                                              ).withValues(alpha: 0.7),
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
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: isWide ? 22 : 16,
                                              ),
                                            ),
                                            SizedBox(height: isWide ? 18 : 10),
                                            Text(
                                              mat.description,
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: isWide ? 16 : 13,
                                              ),
                                            ),
                                            const Spacer(),
                                            CustomButton(
                                              label: 'Download',
                                              icon: Icons.download,
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 32),
                      sectionTitle('Top Subjects'),
                      // Animated Category Cards
                      SizedBox(
                        height: isWide ? 120 : 80,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: topSubjects.length,
                          separatorBuilder:
                              (_, index2) => SizedBox(width: isWide ? 24 : 12),
                          itemBuilder:
                              (context, i) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: () {},
                                    child: Container(
                                      width: isWide ? 120 : 80,
                                      height: isWide ? 120 : 80,
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.book,
                                            color: Color(0xFF2563EB),
                                            size: isWide ? 38 : 26,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            topSubjects[i],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: isWide ? 16 : 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      sectionTitle('Recently Added'),
                      FutureBuilder<List<LearningMaterial>>(
                        future: SupabaseCrudService(Supabase.instance.client).fetchMaterials(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text('Failed to load recent uploads.'));
                          }
                          final materials = snapshot.data ?? [];
                          if (materials.isEmpty) {
                            return const Center(child: Text('No recent uploads.'));
                          }
                          final recent = materials.reversed.take(10).toList();
                          return SizedBox(
                            height: isWide ? 220 : 160,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: recent.length,
                              separatorBuilder: (_, __) => SizedBox(width: isWide ? 24 : 12),
                              itemBuilder: (context, i) => SizedBox(
                                width: isWide ? 320 : 220,
                                child: MaterialCard(
                                  material: recent[i],
                                  onDownload: () {},
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      sectionTitle('Most Downloaded'),
                      SizedBox(
                        height: isWide ? 220 : 160,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              featuredMaterials
                                  .where((m) => m.downloads > 700)
                                  .length,
                          separatorBuilder:
                              (_, index2) => SizedBox(width: isWide ? 24 : 12),
                          itemBuilder: (context, i) {
                            final mats =
                                featuredMaterials
                                    .where((m) => m.downloads > 700)
                                    .toList();
                            return SizedBox(
                              width: isWide ? 320 : 220,
                              child: MaterialCard(
                                material: mats[i],
                                onDownload: () {},
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                      sectionTitle('Recommended For You'),
                      SizedBox(
                        height: isWide ? 220 : 160,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              featuredMaterials
                                  .where((m) => m.rating > 4.5)
                                  .length,
                          separatorBuilder:
                              (_, index2) => SizedBox(width: isWide ? 24 : 12),
                          itemBuilder: (context, i) {
                            final mats =
                                featuredMaterials
                                    .where((m) => m.rating > 4.5)
                                    .toList();
                            return SizedBox(
                              width: isWide ? 320 : 220,
                              child: MaterialCard(
                                material: mats[i],
                                onDownload: () {},
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                      sectionTitle('Popular Tags'),
                      Wrap(
                        spacing: isWide ? 16 : 8,
                        runSpacing: isWide ? 16 : 8,
                        children: [
                          ...featuredMaterials
                              .expand((m) => m.tags)
                              .toSet()
                              .map(
                                (tag) => MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Chip(
                                    label: Text(tag),
                                    backgroundColor: const Color(
                                      0xFF2563EB,
                                    ).withAlpha((0.15 * 255).toInt()),
                                    labelStyle: const TextStyle(
                                      color: Color(0xFF2563EB),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isWide ? 16 : 8,
                                      vertical: isWide ? 8 : 4,
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
                // Floating Action Button
                Positioned(
                  bottom: 32,
                  right: 32,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UploadScreen()),
                      );
                    },
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload'),
                    backgroundColor: const Color(0xFF2563EB),
                    elevation: 8,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
