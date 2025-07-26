import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class StudyCenter {
  final String name;
  final String city;
  final String address;
  final String description;

  StudyCenter({
    required this.name,
    required this.city,
    required this.address,
    required this.description,
  });
}

class StudyCenterCarousel extends StatelessWidget {
  final List<StudyCenter> centers;
  final void Function(int) onTap;

  const StudyCenterCarousel({
    super.key,
    required this.centers,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 140.0,
        enlargeCenterPage: true,
        autoPlay: true,
      ),
      items:
          centers.asMap().entries.map((entry) {
            int idx = entry.key;
            StudyCenter center = entry.value;
            return GestureDetector(
              onTap: () => onTap(idx),
              child: Card(
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        center.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        center.city,
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 4),
                      Text(
                        center.address,
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 4),
                      Text(
                        center.description,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
