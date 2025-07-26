import 'package:flutter/material.dart';
import '../widgets/study_center_carousel.dart';

final List<StudyCenter> studyCenters = [
  StudyCenter(
    name: 'Nairobi Study Center',
    city: 'Nairobi',
    address: 'Kenyatta Avenue, Nairobi',
    description: 'Modern center in Nairobi with WiFi and digital library.',
  ),
  StudyCenter(
    name: 'Mombasa Study Center',
    city: 'Mombasa',
    address: 'Moi Avenue, Mombasa',
    description: 'Coastal study center with group rooms and resources.',
  ),
  StudyCenter(
    name: 'Kisumu Study Center',
    city: 'Kisumu',
    address: 'Oginga Odinga St, Kisumu',
    description: 'Lake region center with collaborative spaces.',
  ),
  StudyCenter(
    name: 'Nakuru Study Center',
    city: 'Nakuru',
    address: 'Kenyatta Ave, Nakuru',
    description: 'Central Rift study center with modern amenities.',
  ),
  StudyCenter(
    name: 'Eldoret Study Center',
    city: 'Uasin Gishu',
    address: 'Ronald Ngala St, Eldoret',
    description: 'North Rift center with digital resources.',
  ),
  StudyCenter(
    name: 'Thika Study Center',
    city: 'Kiambu',
    address: 'Commercial St, Thika',
    description: 'Kiambu county center for collaborative learning.',
  ),
  StudyCenter(
    name: 'Machakos Study Center',
    city: 'Machakos',
    address: 'Ngei Rd, Machakos',
    description: 'Eastern region study center.',
  ),
  StudyCenter(
    name: 'Meru Study Center',
    city: 'Meru',
    address: 'Embu-Meru Hwy, Meru',
    description: 'Mount Kenya region study center.',
  ),
  StudyCenter(
    name: 'Nyeri Study Center',
    city: 'Nyeri',
    address: 'Kenyatta Rd, Nyeri',
    description: 'Central Kenya study center.',
  ),
  StudyCenter(
    name: 'Embu Study Center',
    city: 'Embu',
    address: 'Mama Ngina St, Embu',
    description: 'Eastern region study center.',
  ),
  StudyCenter(
    name: 'Kericho Study Center',
    city: 'Kericho',
    address: 'Kericho-Kisumu Rd, Kericho',
    description: 'Tea region study center.',
  ),
  StudyCenter(
    name: 'Kakamega Study Center',
    city: 'Kakamega',
    address: 'Kisumu-Kakamega Rd, Kakamega',
    description: 'Western Kenya study center.',
  ),
  StudyCenter(
    name: 'Bungoma Study Center',
    city: 'Bungoma',
    address: 'Moi Ave, Bungoma',
    description: 'Western region study center.',
  ),
  StudyCenter(
    name: 'Kitale Study Center',
    city: 'Trans Nzoia',
    address: 'Kitale-Webuye Rd, Kitale',
    description: 'North Rift study center.',
  ),
  StudyCenter(
    name: 'Garissa Study Center',
    city: 'Garissa',
    address: 'Kismayu Rd, Garissa',
    description: 'North Eastern region study center.',
  ),
  StudyCenter(
    name: 'Wajir Study Center',
    city: 'Wajir',
    address: 'Wajir-Mandera Rd, Wajir',
    description: 'North Eastern region study center.',
  ),
  StudyCenter(
    name: 'Mandera Study Center',
    city: 'Mandera',
    address: 'Mandera Rd, Mandera',
    description: 'North Eastern region study center.',
  ),
  StudyCenter(
    name: 'Marsabit Study Center',
    city: 'Marsabit',
    address: 'Marsabit-Moyale Rd, Marsabit',
    description: 'Northern Kenya study center.',
  ),
  StudyCenter(
    name: 'Isiolo Study Center',
    city: 'Isiolo',
    address: 'Isiolo-Marsabit Rd, Isiolo',
    description: 'Northern Kenya study center.',
  ),
  StudyCenter(
    name: 'Nanyuki Study Center',
    city: 'Laikipia',
    address: 'Nanyuki-Rumuruti Rd, Nanyuki',
    description: 'Central Kenya study center.',
  ),
  StudyCenter(
    name: 'Voi Study Center',
    city: 'Taita Taveta',
    address: 'Mombasa Rd, Voi',
    description: 'Coastal region study center.',
  ),
  StudyCenter(
    name: 'Malindi Study Center',
    city: 'Kilifi',
    address: 'Lamu Rd, Malindi',
    description: 'Coastal region study center.',
  ),
  StudyCenter(
    name: 'Lamu Study Center',
    city: 'Lamu',
    address: 'Lamu Island, Lamu',
    description: 'Coastal region study center.',
  ),
  StudyCenter(
    name: 'Homa Bay Study Center',
    city: 'Homa Bay',
    address: 'Rongo-Homa Bay Rd, Homa Bay',
    description: 'Lake region study center.',
  ),
  StudyCenter(
    name: 'Migori Study Center',
    city: 'Migori',
    address: 'Migori-Kisii Rd, Migori',
    description: 'Lake region study center.',
  ),
  StudyCenter(
    name: 'Kisii Study Center',
    city: 'Kisii',
    address: 'Kisii-Kisumu Rd, Kisii',
    description: 'Lake region study center.',
  ),
  StudyCenter(
    name: 'Siaya Study Center',
    city: 'Siaya',
    address: 'Siaya-Bondo Rd, Siaya',
    description: 'Lake region study center.',
  ),
  StudyCenter(
    name: 'Busia Study Center',
    city: 'Busia',
    address: 'Busia-Kisumu Rd, Busia',
    description: 'Western Kenya study center.',
  ),
  StudyCenter(
    name: 'Vihiga Study Center',
    city: 'Vihiga',
    address: 'Kakamega-Kisumu Rd, Vihiga',
    description: 'Western Kenya study center.',
  ),
  StudyCenter(
    name: 'Bomet Study Center',
    city: 'Bomet',
    address: 'Bomet-Sotik Rd, Bomet',
    description: 'Rift Valley study center.',
  ),
  StudyCenter(
    name: 'Narok Study Center',
    city: 'Narok',
    address: 'Narok-Mai Mahiu Rd, Narok',
    description: 'Rift Valley study center.',
  ),
  StudyCenter(
    name: 'Kajiado Study Center',
    city: 'Kajiado',
    address: 'Nairobi-Namanga Rd, Kajiado',
    description: 'Rift Valley study center.',
  ),
  StudyCenter(
    name: 'Turkana Study Center',
    city: 'Turkana',
    address: 'Lodwar-Kitale Rd, Lodwar',
    description: 'Northern Kenya study center.',
  ),
  StudyCenter(
    name: 'West Pokot Study Center',
    city: 'West Pokot',
    address: 'Kapenguria-Lodwar Rd, Kapenguria',
    description: 'Rift Valley study center.',
  ),
  StudyCenter(
    name: 'Samburu Study Center',
    city: 'Samburu',
    address: 'Maralal-Baragoi Rd, Maralal',
    description: 'Northern Kenya study center.',
  ),
  StudyCenter(
    name: 'Tana River Study Center',
    city: 'Tana River',
    address: 'Hola-Garsen Rd, Hola',
    description: 'Coastal region study center.',
  ),
  StudyCenter(
    name: 'Taita Taveta Study Center',
    city: 'Taita Taveta',
    address: 'Voi-Taveta Rd, Taveta',
    description: 'Coastal region study center.',
  ),
  StudyCenter(
    name: 'Kwale Study Center',
    city: 'Kwale',
    address: 'Ukunda-Lunga Lunga Rd, Kwale',
    description: 'Coastal region study center.',
  ),
  StudyCenter(
    name: 'Kilifi Study Center',
    city: 'Kilifi',
    address: 'Kilifi-Malindi Rd, Kilifi',
    description: 'Coastal region study center.',
  ),
  StudyCenter(
    name: 'Murang’a Study Center',
    city: 'Murang’a',
    address: 'Murang’a-Kenol Rd, Murang’a',
    description: 'Central Kenya study center.',
  ),
  StudyCenter(
    name: 'Kirinyaga Study Center',
    city: 'Kirinyaga',
    address: 'Kerugoya-Kutus Rd, Kerugoya',
    description: 'Central Kenya study center.',
  ),
  StudyCenter(
    name: 'Nyandarua Study Center',
    city: 'Nyandarua',
    address: 'Ol Kalou-Nyahururu Rd, Ol Kalou',
    description: 'Central Kenya study center.',
  ),
  StudyCenter(
    name: 'Embu Study Center',
    city: 'Embu',
    address: 'Embu-Meru Rd, Embu',
    description: 'Eastern region study center.',
  ),
  StudyCenter(
    name: 'Makueni Study Center',
    city: 'Makueni',
    address: 'Wote-Makindu Rd, Wote',
    description: 'Eastern region study center.',
  ),
  StudyCenter(
    name: 'Kitui Study Center',
    city: 'Kitui',
    address: 'Kitui-Mwingi Rd, Kitui',
    description: 'Eastern region study center.',
  ),
  StudyCenter(
    name: 'Taveta Study Center',
    city: 'Taita Taveta',
    address: 'Taveta-Voi Rd, Taveta',
    description: 'Coastal region study center.',
  ),
  StudyCenter(
    name: 'Nandi Study Center',
    city: 'Nandi',
    address: 'Kapsabet-Eldoret Rd, Kapsabet',
    description: 'Rift Valley study center.',
  ),
  StudyCenter(
    name: 'Laikipia Study Center',
    city: 'Laikipia',
    address: 'Nanyuki-Rumuruti Rd, Nanyuki',
    description: 'Central Kenya study center.',
  ),
];

class StudyCentersScreen extends StatefulWidget {
  const StudyCentersScreen({super.key});

  @override
  State<StudyCentersScreen> createState() => _StudyCentersScreenState();
}

class _StudyCentersScreenState extends State<StudyCentersScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final filtered =
        studyCenters
            .where(
              (c) =>
                  c.name.toLowerCase().contains(_search.toLowerCase()) ||
                  c.city.toLowerCase().contains(_search.toLowerCase()) ||
                  c.address.toLowerCase().contains(_search.toLowerCase()),
            )
            .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Study Centers')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name, city, or address...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
              ),
              onChanged: (val) => setState(() => _search = val),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final center = filtered[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(center.name),
                    subtitle: Text(
                      '${center.city}\n${center.address}\n${center.description}',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
