import 'package:afrikalyrics_mobile/misc/app_colors.dart';
import 'package:afrikalyrics_mobile/player/player_controller.dart';
import 'package:afrikalyrics_mobile/player/playing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';

import '../song_image_widget.dart';

class BottomCurrentSong extends GetView<PlayerController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () {
          Get.bottomSheet(
            PlayingScreen(),
            persistent: true,
            isScrollControlled: true,
          );
        },
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Colors.black87,
                AppColors.primary,
              ],
              end: Alignment.bottomCenter,
            ),
          ),
          child: Row(
            children: [
              SongImageWidget(
                song: controller.playing.value,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Marquee(
                        child: Text(
                          "${controller.playing.value.songTitle}",
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Marquee(
                        child: Text(
                          "${controller.playing.value.artistName}",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            letterSpacing: 1,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.skip_previous, color: Colors.white),
                    onPressed: () {
                      controller.playPrevious();
                    },
                  ),
                  IconButton(
                    icon: Icon(
                        controller.isPlaying.value
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white),
                    onPressed: () {
                      controller.isPlaying.value
                          ? controller.pause()
                          : controller.play();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next, color: Colors.white),
                    onPressed: () {
                      controller.playNext();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
