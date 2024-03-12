import 'dart:math';

import 'package:afrikalyrics_mobile/misc/app_colors.dart';
import 'package:afrikalyrics_mobile/misc/app_sizes.dart';
import 'package:afrikalyrics_mobile/misc/app_strings.dart';
import 'package:afrikalyrics_mobile/models/artist_model.dart';
import 'package:afrikalyrics_mobile/models/genre_model.dart';
import 'package:afrikalyrics_mobile/screens/artist_details_screen.dart';
import 'package:afrikalyrics_mobile/screens/lyrics_by_genre.dart';
import 'package:afrikalyrics_mobile/widgets/app_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenreCard extends StatelessWidget {
  final GenreModel genre;
  const GenreCard({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Get.to(() => LyricsByGenre(genre: genre));
        },
        child: Container(
          //  height: AppSizes.artistCardHsm,
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
                  ],
                )),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${genre.titre}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
