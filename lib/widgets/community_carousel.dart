import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CommunityCarousel extends StatelessWidget {
  final List<String> forumTitles;
  final void Function(int) onTap;

  const CommunityCarousel({
    Key? key,
    required this.forumTitles,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 120.0,
        enlargeCenterPage: true,
        autoPlay: true,
      ),
      items: forumTitles.asMap().entries.map((entry) {
        int idx = entry.key;
        String title = entry.value;
        return GestureDetector(
          onTap: () => onTap(idx),
          child: Card(
            color: Colors.blueAccent,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
