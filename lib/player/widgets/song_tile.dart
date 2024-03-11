import 'dart:io';

import 'package:afrikalyrics_mobile/misc/app_colors.dart';
import 'package:afrikalyrics_mobile/player/lrc_page.dart';
import 'package:afrikalyrics_mobile/player/models/LocalSong.dart';
import 'package:afrikalyrics_mobile/player/player_controller.dart';
import 'package:afrikalyrics_mobile/player/playing.dart';
import 'package:afrikalyrics_mobile/player/song_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SongTile extends GetView<PlayerController> {
  final LocalSong song;
  final List<LocalSong> songs;

  const SongTile({
    super.key,
    required this.song,
    required this.songs,
  });
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool currentSongActive = controller.playing.value != null &&
          controller.playing.value.songId == song.songId;
      return GestureDetector(
        onTap: () {
          if (currentSongActive) {
            // controller.play(listSong: songs);
            if (controller.isPlaying.value) {
            } else {
              controller.play();
            }
          } else {
            controller.play(song: song, listSong: songs);
          }
          Get.to(() => PlayingScreen());
          Get.to(() => LrcPage());
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            child: Row(
              children: [
                SongImageWidget(
                  song: song,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${song.songTitle}",
                          style: TextStyle(
                            color: currentSongActive
                                ? AppColors.primary
                                : Theme.of(context).textTheme.headline5?.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${song.artistName}",
                          style: TextStyle(
                            color: currentSongActive
                                ? AppColors.primary
                                : Theme.of(context).textTheme.headline5?.color,
                            fontSize: 15,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (currentSongActive)
                  Image.asset(
                    "assets/images/isplaying.gif",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                Container(
                  child: IconButton(
                    icon: Icon((currentSongActive && controller.isPlaying.value)
                        ? Icons.pause
                        : Icons.play_arrow),
                    onPressed: () {
                      if (currentSongActive) {
                        if (controller.isPlaying.value) {
                          controller.pause();
                        } else {
                          controller.play(listSong: songs);
                          Get.to(() => LrcPage());
                        }
                      } else {
                        controller.play(song: song, listSong: songs);
                        Get.to(() => LrcPage());
                      }

                      // Get.changeTheme(Get.isDarkMode
                      //     ? ThemeData.light()
                      //     : ThemeData.dark());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
