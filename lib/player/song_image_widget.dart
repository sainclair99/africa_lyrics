import 'dart:io';

import 'package:afrikalyrics_mobile/player/models/LocalSong.dart';
import 'package:flutter/material.dart';

class SongImageWidget extends StatelessWidget {
  final LocalSong song;

  const SongImageWidget({super.key, required this.song});
  @override
  Widget build(BuildContext context) {
    if (song.coverUrl != null)
      return Image.file(
        File('${song.coverUrl}'),
        height: 50,
        width: 50,
        errorBuilder: (context, object, stacTrace) {
          return Image.asset(
            "assets/images/logo-circle.jpg",
            width: 50,
            height: 50,
          );
        },
      );
    else if (song.cover != null)
      return Image.memory(
        song.cover!,
        height: 50,
        width: 50,
        errorBuilder: (context, object, stacTrace) {
          return Image.asset(
            "assets/images/logo-circle.jpg",
            width: 50,
            height: 50,
          );
        },
      );
    else
      return Image.asset(
        "assets/images/logo-circle.jpg",
        width: 50,
        height: 50,
      );
  }
}
