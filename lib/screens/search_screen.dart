import 'package:flutter/material.dart';
import '../models/material.dart';

import '../widgets/material_card.dart';
import '../services/auth_service.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_crud_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<LearningMaterial> _uploadedMaterials = [];
  bool _loadingUploaded = true;
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
    // Mathematics
    LearningMaterial(
      id: 'math1',
      title: 'KCSE 2024 Mathematics Paper 1',
      subject: 'Mathematics',
      description: 'Latest KCSE Paper 1 with marking scheme.',
      fileUrl:
          'https://www.open.edu/openlearn/ocw/mod/oucontent/view.php?id=85917&section=1',
      rating: 4.8,
      downloads: 1200,
      size: 512,
      uploaderId: 'user1',
      tags: ['KCSE', '2024', 'Math'],
    ),
    LearningMaterial(
      id: 'math2',
      title: 'Form 1 Mathematics Notes',
      subject: 'Mathematics',
      description: 'Comprehensive notes for Form 1 Mathematics.',
      fileUrl:
          'https://www.open.edu/openlearn/ocw/pluginfile.php/629607/mod_resource/content/1/mathematics_book.pdf',
      rating: 4.7,
      downloads: 950,
      size: 400,
      uploaderId: 'user2',
      tags: ['Notes', 'Mathematics'],
    ),
    LearningMaterial(
      id: 'math3',
      title: 'Mathematics Revision Kit',
      subject: 'Mathematics',
      description: 'A complete revision kit for Mathematics.',
      fileUrl: 'https://www.saylor.org/site/textbooks/Prealgebra.pdf',
      rating: 4.6,
      downloads: 870,
      size: 350,
      uploaderId: 'user3',
      tags: ['Revision', 'Mathematics'],
    ),
    LearningMaterial(
      id: 'math4',
      title: 'Form 2 Mathematics Past Papers',
      subject: 'Mathematics',
      description: 'Past papers for Form 2 Mathematics.',
      fileUrl:
          'https://www.kcse-online.info/Mathematics/Mathematics%20Paper%201%202019.pdf',
      rating: 4.5,
      downloads: 800,
      size: 300,
      uploaderId: 'user4',
      tags: ['Past Papers', 'Mathematics'],
    ),
    LearningMaterial(
      id: 'math5',
      title: 'Mathematics Formulas Handbook',
      subject: 'Mathematics',
      description: 'Handbook of essential mathematics formulas.',
      fileUrl: 'https://www.cimt.org.uk/projects/mepres/step-up/stepup.pdf',
      rating: 4.4,
      downloads: 750,
      size: 250,
      uploaderId: 'user5',
      tags: ['Handbook', 'Formulas'],
    ),
    // English
    LearningMaterial(
      id: 'eng1',
      title: 'KCSE 2024 English Paper 1',
      subject: 'English',
      description: 'Latest KCSE English Paper 1 with marking scheme.',
      fileUrl: 'https://www.gutenberg.org/files/1342/1342-h/1342-h.htm',
      rating: 4.7,
      downloads: 1100,
      size: 500,
      uploaderId: 'user6',
      tags: ['KCSE', '2024', 'English'],
    ),
    LearningMaterial(
      id: 'eng2',
      title: 'English Set Books Guide',
      subject: 'English',
      description: 'Guide to KCSE English set books.',
      fileUrl: 'https://www.gutenberg.org/files/2600/2600-h/2600-h.htm',
      rating: 4.6,
      downloads: 900,
      size: 420,
      uploaderId: 'user7',
      tags: ['Set Books', 'English'],
    ),
    LearningMaterial(
      id: 'eng3',
      title: 'Form 1 English Notes',
      subject: 'English',
      description: 'Comprehensive notes for Form 1 English.',
      fileUrl:
          'https://www.saylor.org/site/textbooks/English%20Composition.pdf',
      rating: 4.5,
      downloads: 850,
      size: 380,
      uploaderId: 'user8',
      tags: ['Notes', 'English'],
    ),
    LearningMaterial(
      id: 'eng4',
      title: 'English Grammar Workbook',
      subject: 'English',
      description: 'Workbook for English grammar practice.',
      fileUrl:
          'https://www.englishpractice.com/wp-content/uploads/2010/07/Grammar-Practice.pdf',
      rating: 4.4,
      downloads: 800,
      size: 320,
      uploaderId: 'user9',
      tags: ['Grammar', 'Workbook'],
    ),
    LearningMaterial(
      id: 'eng5',
      title: 'English Composition Samples',
      subject: 'English',
      description: 'Sample compositions for KCSE preparation.',
      fileUrl:
          'https://www.saylor.org/site/wp-content/uploads/2012/09/ENGL000-2.1.2-Examples-of-Student-Essays.pdf',
      rating: 4.3,
      downloads: 780,
      size: 300,
      uploaderId: 'user10',
      tags: ['Composition', 'Samples'],
    ),
    // Kiswahili
    LearningMaterial(
      id: 'kis1',
      title: 'KCSE 2024 Kiswahili Paper 1',
      subject: 'Kiswahili',
      description: 'Latest KCSE Kiswahili Paper 1 with marking scheme.',
      fileUrl:
          'https://www.kicd.ac.ke/wp-content/uploads/2022/04/Kiswahili-Kidato-cha-Kwanza.pdf',
      rating: 4.8,
      downloads: 1050,
      size: 480,
      uploaderId: 'user11',
      tags: ['KCSE', '2024', 'Kiswahili'],
    ),
    LearningMaterial(
      id: 'kis2',
      title: 'Kiswahili Insha Samples',
      subject: 'Kiswahili',
      description: 'Best Insha samples for KCSE preparation.',
      fileUrl:
          'https://www.kcse-online.info/Kiswahili/Kiswahili%20Insha%20Samples.pdf',
      rating: 4.7,
      downloads: 900,
      size: 350,
      uploaderId: 'user12',
      tags: ['Insha', 'Kiswahili'],
    ),
    LearningMaterial(
      id: 'kis3',
      title: 'Form 1 Kiswahili Notes',
      subject: 'Kiswahili',
      description: 'Comprehensive notes for Form 1 Kiswahili.',
      fileUrl:
          'https://www.kcse-online.info/Kiswahili/Kiswahili%20Notes%20Form%201.pdf',
      rating: 4.6,
      downloads: 850,
      size: 320,
      uploaderId: 'user13',
      tags: ['Notes', 'Kiswahili'],
    ),
    LearningMaterial(
      id: 'kis4',
      title: 'Kiswahili Fasihi Guide',
      subject: 'Kiswahili',
      description: 'Guide to Kiswahili Fasihi for KCSE.',
      fileUrl: 'https://www.kcse-online.info/Kiswahili/Fasihi%20Guide.pdf',
      rating: 4.5,
      downloads: 800,
      size: 300,
      uploaderId: 'user14',
      tags: ['Fasihi', 'Guide'],
    ),
    LearningMaterial(
      id: 'kis5',
      title: 'Kiswahili Past Papers',
      subject: 'Kiswahili',
      description: 'Past papers for Kiswahili.',
      fileUrl:
          'https://www.kcse-online.info/Kiswahili/Kiswahili%20Past%20Papers.pdf',
      rating: 4.4,
      downloads: 750,
      size: 270,
      uploaderId: 'user15',
      tags: ['Past Papers', 'Kiswahili'],
    ),
    // Physics
    LearningMaterial(
      id: 'phy1',
      title: 'KCSE 2024 Physics Paper 1',
      subject: 'Physics',
      description: 'Latest KCSE Physics Paper 1 with marking scheme.',
      fileUrl:
          'https://www.open.edu/openlearn/ocw/mod/oucontent/view.php?id=85919&section=1',
      rating: 4.7,
      downloads: 1000,
      size: 470,
      uploaderId: 'user16',
      tags: ['KCSE', '2024', 'Physics'],
    ),
    LearningMaterial(
      id: 'phy2',
      title: 'Form 1 Physics Notes',
      subject: 'Physics',
      description: 'Comprehensive notes for Form 1 Physics.',
      fileUrl:
          'https://www.kcse-online.info/Physics/Physics%20Notes%20Form%201.pdf',
      rating: 4.6,
      downloads: 900,
      size: 420,
      uploaderId: 'user17',
      tags: ['Notes', 'Physics'],
    ),
    LearningMaterial(
      id: 'phy3',
      title: 'Physics Revision Kit',
      subject: 'Physics',
      description: 'A complete revision kit for Physics.',
      fileUrl: 'https://www.saylor.org/site/textbooks/Physics.pdf',
      rating: 4.5,
      downloads: 850,
      size: 380,
      uploaderId: 'user18',
      tags: ['Revision', 'Physics'],
    ),
    LearningMaterial(
      id: 'phy4',
      title: 'Physics Past Papers',
      subject: 'Physics',
      description: 'Past papers for Physics.',
      fileUrl:
          'https://www.kcse-online.info/Physics/Physics%20Past%20Papers.pdf',
      rating: 4.4,
      downloads: 800,
      size: 340,
      uploaderId: 'user19',
      tags: ['Past Papers', 'Physics'],
    ),
    LearningMaterial(
      id: 'phy5',
      title: 'Physics Formulas Handbook',
      subject: 'Physics',
      description: 'Handbook of essential physics formulas.',
      fileUrl:
          'https://www.physicsclassroom.com/class/math/Lesson-1/Physics-Equations',
      rating: 4.3,
      downloads: 780,
      size: 300,
      uploaderId: 'user20',
      tags: ['Handbook', 'Formulas'],
    ),
    // Chemistry
    LearningMaterial(
      id: 'chem1',
      title: 'KCSE 2024 Chemistry Paper 1',
      subject: 'Chemistry',
      description: 'Latest KCSE Chemistry Paper 1 with marking scheme.',
      fileUrl:
          'https://www.open.edu/openlearn/ocw/mod/oucontent/view.php?id=85920&section=1',
      rating: 4.8,
      downloads: 1100,
      size: 500,
      uploaderId: 'user21',
      tags: ['KCSE', '2024', 'Chemistry'],
    ),
    LearningMaterial(
      id: 'chem2',
      title: 'Form 2 Chemistry Notes',
      subject: 'Chemistry',
      description: 'Comprehensive notes for Form 2 Chemistry.',
      fileUrl:
          'https://www.kcse-online.info/Chemistry/Chemistry%20Notes%20Form%202.pdf',
      rating: 4.7,
      downloads: 950,
      size: 420,
      uploaderId: 'user22',
      tags: ['Notes', 'Chemistry'],
    ),
    LearningMaterial(
      id: 'chem3',
      title: 'Chemistry Revision Kit',
      subject: 'Chemistry',
      description: 'A complete revision kit for Chemistry.',
      fileUrl:
          'https://www.saylor.org/site/textbooks/General%20Chemistry%20Principles%2C%20Patterns%2C%20and%20Applications.pdf',
      rating: 4.6,
      downloads: 900,
      size: 380,
      uploaderId: 'user23',
      tags: ['Revision', 'Chemistry'],
    ),
    LearningMaterial(
      id: 'chem4',
      title: 'Chemistry Past Papers',
      subject: 'Chemistry',
      description: 'Past papers for Chemistry.',
      fileUrl:
          'https://www.kcse-online.info/Chemistry/Chemistry%20Past%20Papers.pdf',
      rating: 4.5,
      downloads: 850,
      size: 340,
      uploaderId: 'user24',
      tags: ['Past Papers', 'Chemistry'],
    ),
    LearningMaterial(
      id: 'chem5',
      title: 'Chemistry Formulas Handbook',
      subject: 'Chemistry',
      description: 'Handbook of essential chemistry formulas.',
      fileUrl:
          'https://chem.libretexts.org/Bookshelves/Physical_and_Theoretical_Chemistry_Textbook_Maps/Supplemental_Modules_(Physical_and_Theoretical_Chemistry)/Physical_Properties_of_Matter/Atomic_and_Molecular_Properties/Atomic_Theory/Chemistry_Formula_Sheet',
      rating: 4.4,
      downloads: 800,
      size: 300,
      uploaderId: 'user25',
      tags: ['Handbook', 'Formulas'],
    ),
    // Biology
    LearningMaterial(
      id: 'bio1',
      title: 'KCSE 2024 Biology Paper 1',
      subject: 'Biology',
      description: 'Latest KCSE Biology Paper 1 with marking scheme.',
      fileUrl:
          'https://www.open.edu/openlearn/ocw/mod/oucontent/view.php?id=85918&section=1',
      rating: 4.7,
      downloads: 1000,
      size: 470,
      uploaderId: 'user26',
      tags: ['KCSE', '2024', 'Biology'],
    ),
    LearningMaterial(
      id: 'bio2',
      title: 'Form 1 Biology Notes',
      subject: 'Biology',
      description: 'Comprehensive notes for Form 1 Biology.',
      fileUrl:
          'https://www.kcse-online.info/Biology/Biology%20Notes%20Form%201.pdf',
      rating: 4.6,
      downloads: 900,
      size: 420,
      uploaderId: 'user27',
      tags: ['Notes', 'Biology'],
    ),
    LearningMaterial(
      id: 'bio3',
      title: 'Biology Revision Kit',
      subject: 'Biology',
      description: 'A complete revision kit for Biology.',
      fileUrl:
          'https://www.saylor.org/site/textbooks/Concepts%20of%20Biology.pdf',
      rating: 4.5,
      downloads: 850,
      size: 380,
      uploaderId: 'user28',
      tags: ['Revision', 'Biology'],
    ),
    LearningMaterial(
      id: 'bio4',
      title: 'Biology Past Papers',
      subject: 'Biology',
      description: 'Past papers for Biology.',
      fileUrl:
          'https://www.kcse-online.info/Biology/Biology%20Past%20Papers.pdf',
      rating: 4.4,
      downloads: 800,
      size: 340,
      uploaderId: 'user29',
      tags: ['Past Papers', 'Biology'],
    ),
    LearningMaterial(
      id: 'bio5',
      title: 'Biology Formulas Handbook',
      subject: 'Biology',
      description: 'Handbook of essential biology formulas.',
      fileUrl: 'https://www.biologycorner.com/worksheets/formulas.pdf',
      rating: 4.3,
      downloads: 780,
      size: 300,
      uploaderId: 'user30',
      tags: ['Handbook', 'Formulas'],
    ),
    // Geography
    LearningMaterial(
      id: 'geo1',
      title: 'KCSE 2024 Geography Paper 1',
      subject: 'Geography',
      description: 'Latest KCSE Geography Paper 1 with marking scheme.',
      fileUrl:
          'https://www.open.edu/openlearn/ocw/mod/oucontent/view.php?id=85921&section=1',
      rating: 4.8,
      downloads: 950,
      size: 460,
      uploaderId: 'user31',
      tags: ['KCSE', '2024', 'Geography'],
    ),
    LearningMaterial(
      id: 'geo2',
      title: 'Form 1 Geography Notes',
      subject: 'Geography',
      description: 'Comprehensive notes for Form 1 Geography.',
      fileUrl:
          'https://www.kcse-online.info/Geography/Geography%20Notes%20Form%201.pdf',
      rating: 4.7,
      downloads: 900,
      size: 420,
      uploaderId: 'user32',
      tags: ['Notes', 'Geography'],
    ),
    LearningMaterial(
      id: 'geo3',
      title: 'Geography Revision Kit',
      subject: 'Geography',
      description: 'A complete revision kit for Geography.',
      fileUrl:
          'https://www.saylor.org/site/textbooks/World%20Regional%20Geography.pdf',
      rating: 4.6,
      downloads: 850,
      size: 380,
      uploaderId: 'user33',
      tags: ['Revision', 'Geography'],
    ),
    LearningMaterial(
      id: 'geo4',
      title: 'Geography Past Papers',
      subject: 'Geography',
      description: 'Past papers for Geography.',
      fileUrl:
          'https://www.kcse-online.info/Geography/Geography%20Past%20Papers.pdf',
      rating: 4.5,
      downloads: 800,
      size: 340,
      uploaderId: 'user34',
      tags: ['Past Papers', 'Geography'],
    ),
    LearningMaterial(
      id: 'geo5',
      title: 'Geography Atlas Guide',
      subject: 'Geography',
      description: 'Guide to using atlases in Geography.',
      fileUrl: 'https://www.kcse-online.info/Geography/Atlas%20Guide.pdf',
      rating: 4.4,
      downloads: 780,
      size: 300,
      uploaderId: 'user35',
      tags: ['Atlas', 'Guide'],
    ),
    // History
    LearningMaterial(
      id: 'his1',
      title: 'KCSE 2024 History Paper 1',
      subject: 'History',
      description: 'Latest KCSE History Paper 1 with marking scheme.',
      fileUrl: 'https://www.gutenberg.org/files/10676/10676-h/10676-h.htm',
      rating: 4.7,
      downloads: 900,
      size: 450,
      uploaderId: 'user36',
      tags: ['KCSE', '2024', 'History'],
    ),
    LearningMaterial(
      id: 'his2',
      title: 'Form 1 History Notes',
      subject: 'History',
      description: 'Comprehensive notes for Form 1 History.',
      fileUrl:
          'https://www.kcse-online.info/History/History%20Notes%20Form%201.pdf',
      rating: 4.6,
      downloads: 850,
      size: 400,
      uploaderId: 'user37',
      tags: ['Notes', 'History'],
    ),
    LearningMaterial(
      id: 'his3',
      title: 'History Revision Kit',
      subject: 'History',
      description: 'A complete revision kit for History.',
      fileUrl: 'https://www.saylor.org/site/textbooks/World%20History.pdf',
      rating: 4.5,
      downloads: 800,
      size: 350,
      uploaderId: 'user38',
      tags: ['Revision', 'History'],
    ),
    LearningMaterial(
      id: 'his4',
      title: 'History Past Papers',
      subject: 'History',
      description: 'Past papers for History.',
      fileUrl:
          'https://www.kcse-online.info/History/History%20Past%20Papers.pdf',
      rating: 4.4,
      downloads: 750,
      size: 320,
      uploaderId: 'user39',
      tags: ['Past Papers', 'History'],
    ),
    LearningMaterial(
      id: 'his5',
      title: 'History Timelines Guide',
      subject: 'History',
      description: 'Guide to important history timelines.',
      fileUrl:
          'https://www.kcse-online.info/History/History%20Timelines%20Guide.pdf',
      rating: 4.3,
      downloads: 700,
      size: 280,
      uploaderId: 'user40',
      tags: ['Timelines', 'Guide'],
    ),
    // Business
    LearningMaterial(
      id: 'bus1',
      title: 'KCSE 2024 Business Paper 1',
      subject: 'Business',
      description: 'Latest KCSE Business Paper 1 with marking scheme.',
      fileUrl:
          'https://www.saylor.org/site/textbooks/Introduction%20to%20Business.pdf',
      rating: 4.8,
      downloads: 850,
      size: 440,
      uploaderId: 'user41',
      tags: ['KCSE', '2024', 'Business'],
    ),
    LearningMaterial(
      id: 'bus2',
      title: 'Form 1 Business Notes',
      subject: 'Business',
      description: 'Comprehensive notes for Form 1 Business.',
      fileUrl:
          'https://www.kcse-online.info/Business/Business%20Notes%20Form%201.pdf',
      rating: 4.7,
      downloads: 800,
      size: 400,
      uploaderId: 'user42',
      tags: ['Notes', 'Business'],
    ),
    LearningMaterial(
      id: 'bus3',
      title: 'Business Revision Kit',
      subject: 'Business',
      description: 'A complete revision kit for Business.',
      fileUrl: 'https://www.saylor.org/site/textbooks/Business%20Ethics.pdf',
      rating: 4.6,
      downloads: 750,
      size: 350,
      uploaderId: 'user43',
      tags: ['Revision', 'Business'],
    ),
    LearningMaterial(
      id: 'bus4',
      title: 'Business Past Papers',
      subject: 'Business',
      description: 'Past papers for Business.',
      fileUrl:
          'https://www.kcse-online.info/Business/Business%20Past%20Papers.pdf',
      rating: 4.5,
      downloads: 700,
      size: 320,
      uploaderId: 'user44',
      tags: ['Past Papers', 'Business'],
    ),
    LearningMaterial(
      id: 'bus5',
      title: 'Business Entrepreneurship Guide',
      subject: 'Business',
      description: 'Guide to entrepreneurship in business.',
      fileUrl: 'https://www.saylor.org/site/textbooks/Entrepreneurship.pdf',
      rating: 4.4,
      downloads: 650,
      size: 280,
      uploaderId: 'user45',
      tags: ['Entrepreneurship', 'Guide'],
    ),
    // CRE
    LearningMaterial(
      id: 'cre1',
      title: 'KCSE 2024 CRE Paper 1',
      subject: 'CRE',
      description: 'Latest KCSE CRE Paper 1 with marking scheme.',
      fileUrl: 'https://www.bible.com/bible/114/GEN.1.NKJV',
      rating: 4.7,
      downloads: 800,
      size: 430,
      uploaderId: 'user46',
      tags: ['KCSE', '2024', 'CRE'],
    ),
    LearningMaterial(
      id: 'cre2',
      title: 'Form 1 CRE Notes',
      subject: 'CRE',
      description: 'Comprehensive notes for Form 1 CRE.',
      fileUrl: 'https://www.kcse-online.info/CRE/CRE%20Notes%20Form%201.pdf',
      rating: 4.6,
      downloads: 750,
      size: 400,
      uploaderId: 'user47',
      tags: ['Notes', 'CRE'],
    ),
    LearningMaterial(
      id: 'cre3',
      title: 'CRE Revision Kit',
      subject: 'CRE',
      description: 'A complete revision kit for CRE.',
      fileUrl: 'https://www.kcse-online.info/CRE/CRE%20Revision%20Kit.pdf',
      rating: 4.5,
      downloads: 700,
      size: 350,
      uploaderId: 'user48',
      tags: ['Revision', 'CRE'],
    ),
    LearningMaterial(
      id: 'cre4',
      title: 'CRE Past Papers',
      subject: 'CRE',
      description: 'Past papers for CRE.',
      fileUrl: 'https://www.kcse-online.info/CRE/CRE%20Past%20Papers.pdf',
      rating: 4.4,
      downloads: 650,
      size: 320,
      uploaderId: 'user49',
      tags: ['Past Papers', 'CRE'],
    ),
    LearningMaterial(
      id: 'cre5',
      title: 'CRE Bible Study Guide',
      subject: 'CRE',
      description: 'Guide to Bible study for CRE.',
      fileUrl: 'https://www.bible.com/reading-plans/22233-bible-study-guide',
      rating: 4.3,
      downloads: 600,
      size: 280,
      uploaderId: 'user50',
      tags: ['Bible Study', 'Guide'],
    ),
  ];

  Map<String, String?> _user = {};
  bool _loadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _fetchUploadedMaterials();
  }

  Future<void> _fetchUploadedMaterials() async {
    try {
      final supabase = Supabase.instance.client;
      final crud = SupabaseCrudService(supabase);
      final materials = await crud.fetchMaterials();
      if (!mounted) return;
      setState(() {
        _uploadedMaterials = materials;
        _loadingUploaded = false;
      });
    } catch (e, st) {
      debugPrint('Error fetching uploaded materials: $e\n$st');
      if (!mounted) return;
      setState(() {
        _uploadedMaterials = [];
        _loadingUploaded = false;
      });
    }
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

  List<LearningMaterial> get _filteredUploadedMaterials {
    return _uploadedMaterials.where((m) {
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
      body:
          _loadingUser || _loadingUploaded
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 800;
                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isWide ? 700 : double.infinity,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(isWide ? 32 : 16),
                        child: Column(
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
                            TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search for materials...',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    isWide ? 18 : 12,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: isWide ? 20 : 14,
                                  horizontal: isWide ? 20 : 12,
                                ),
                              ),
                              style: TextStyle(fontSize: isWide ? 18 : 15),
                              onChanged: (v) => setState(() => _query = v),
                            ),
                            SizedBox(height: isWide ? 20 : 12),
                            SizedBox(
                              height: isWide ? 44 : 36,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: _subjects.length,
                                separatorBuilder:
                                    (_, second) =>
                                        SizedBox(width: isWide ? 14 : 8),
                                itemBuilder:
                                    (context, i) => MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: ChoiceChip(
                                        label: Text(_subjects[i]),
                                        selected:
                                            _selectedSubject == _subjects[i],
                                        onSelected: (selected) {
                                          setState(
                                            () =>
                                                _selectedSubject = _subjects[i],
                                          );
                                        },
                                        selectedColor: const Color(0xFF2563EB),
                                        labelStyle: TextStyle(
                                          color:
                                              _selectedSubject == _subjects[i]
                                                  ? Colors.white
                                                  : Colors.black,
                                          fontSize: isWide ? 16 : 14,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isWide ? 18 : 10,
                                          vertical: isWide ? 8 : 4,
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                            SizedBox(height: isWide ? 24 : 16),
                            Expanded(
                              child: ListView(
                                children: [
                                  if (_filteredMaterials.isNotEmpty) ...[
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Text(
                                        'Demo Materials',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    ..._filteredMaterials.map(
                                      (mat) => MaterialCard(
                                        material: mat,
                                        onDownload: () async {
                                          final url = mat.fileUrl;
                                          final taskId = await FlutterDownloader.enqueue(
                                            url: url,
                                            savedDir: '/storage/emulated/0/Download',
                                            fileName: '${mat.title.replaceAll(' ', '_')}.pdf',
                                            showNotification: true,
                                            openFileFromNotification: true,
                                          );
                                          if (!context.mounted) return;
                                          if (taskId == null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Failed to start download.')),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Download started. Check notifications.')),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                  if (_filteredUploadedMaterials
                                      .isNotEmpty) ...[
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Text(
                                        'Uploaded Materials',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    ..._filteredUploadedMaterials.map(
                                      (mat) => MaterialCard(
                                        material: mat,
                                        onDownload: () async {
                                          final url = mat.fileUrl;
                                          final taskId = await FlutterDownloader.enqueue(
                                            url: url,
                                            savedDir: '/storage/emulated/0/Download',
                                            fileName: '${mat.title.replaceAll(' ', '_')}.pdf',
                                            showNotification: true,
                                            openFileFromNotification: true,
                                          );
                                          if (!context.mounted) return;
                                          if (taskId == null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Failed to start download.')),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Download started. Check notifications.')),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                  if (_filteredMaterials.isEmpty &&
                                      _filteredUploadedMaterials.isEmpty)
                                    const Center(
                                      child: Text('No materials found.'),
                                    ),
                                ],
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
