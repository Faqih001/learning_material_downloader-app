import 'package:flutter/material.dart';
import '../models/material.dart';
import '../widgets/material_card.dart';
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
    final List<LearningMaterial> featuredMaterials = [
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

    Widget sectionTitle(String title) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        final gridCount = isWide ? 3 : 2;
        final horizontalPadding = isWide ? 48.0 : 24.0;
        final verticalPadding = isWide ? 32.0 : 24.0;
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isWide ? 1200 : double.infinity),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Welcome
                  Row(
                    children: [
                      CircleAvatar(
                        radius: isWide ? 36 : 28,
                        backgroundColor: const Color(0xFF2563EB),
                        child: Text('Hi', style: TextStyle(color: Colors.white, fontSize: isWide ? 22 : 16)),
                      ),
                      SizedBox(width: isWide ? 28 : 16),
                      Expanded(
                        child: Text(
                          'Welcome back!\nFind the best learning materials for your studies.',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: isWide ? 22 : null),
                        ),
                      ),
                    ],
                  ),
                  sectionTitle('Top Subjects'),
                  // 2. Top Subjects
                  SizedBox(
                    height: isWide ? 48 : 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: topSubjects.length,
                      separatorBuilder: (_, __) => SizedBox(width: isWide ? 16 : 8),
                      itemBuilder: (context, i) => MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Chip(
                          label: Text(topSubjects[i]),
                          backgroundColor: const Color(0xFF60A5FA),
                          labelStyle: TextStyle(color: Colors.white, fontSize: isWide ? 16 : 14),
                          padding: EdgeInsets.symmetric(horizontal: isWide ? 18 : 10, vertical: isWide ? 8 : 4),
                        ),
                      ),
                    ),
                  ),
                  sectionTitle('Featured Materials'),
                  // 3. Featured Materials (animated grid)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: GridView.builder(
                      key: ValueKey(featuredMaterials.length),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridCount,
                        mainAxisSpacing: isWide ? 20 : 12,
                        crossAxisSpacing: isWide ? 20 : 12,
                        childAspectRatio: isWide ? 1.1 : 0.85,
                      ),
                      itemCount: featuredMaterials.length,
                      itemBuilder: (context, i) => MaterialCard(
                        material: featuredMaterials[i],
                        onDownload: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Downloading ${featuredMaterials[i].title}...'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  sectionTitle('Most Downloaded'),
                  // 4. Most Downloaded (animated list)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    child: Column(
                      children: featuredMaterials
                          .where((m) => m.downloads > 700)
                          .map((m) => MaterialCard(material: m, onDownload: () {}))
                          .toList(),
                    ),
                  ),
                  sectionTitle('Recently Added'),
                  // 5. Recently Added (animated list)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    child: Column(
                      children: featuredMaterials.reversed
                          .take(3)
                          .map((m) => MaterialCard(material: m, onDownload: () {}))
                          .toList(),
                    ),
                  ),
                  sectionTitle('Recommended For You'),
                  // 6. Recommended (animated list)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    child: Column(
                      children: featuredMaterials
                          .where((m) => m.rating > 4.5)
                          .map((m) => MaterialCard(material: m, onDownload: () {}))
                          .toList(),
                    ),
                  ),
                  sectionTitle('By Subject'),
                  // 7. By Subject (horizontal scroll)
                  SizedBox(
                    height: isWide ? 220 : 180,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: topSubjects.map((subject) {
                        final mat = featuredMaterials.firstWhere(
                          (m) => m.subject == subject,
                          orElse: () => featuredMaterials[0],
                        );
                        return Container(
                          width: isWide ? 280 : 220,
                          margin: EdgeInsets.only(right: isWide ? 20 : 12),
                          child: MaterialCard(material: mat, onDownload: () {}),
                        );
                      }).toList(),
                    ),
                  ),
                  sectionTitle('Popular Tags'),
                  // 8. Popular Tags (chips)
                  Wrap(
                    spacing: isWide ? 16 : 8,
                    runSpacing: isWide ? 16 : 8,
                    children: [
                      ...featuredMaterials
                          .expand((m) => m.tags)
                          .toSet()
                          .map((tag) => MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Chip(
                                  label: Text(tag),
                                  backgroundColor: const Color(0xFF2563EB).withAlpha((0.15 * 255).toInt()),
                                  labelStyle: const TextStyle(color: Color(0xFF2563EB)),
                                  padding: EdgeInsets.symmetric(horizontal: isWide ? 16 : 8, vertical: isWide ? 8 : 4),
                                ),
                              )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
