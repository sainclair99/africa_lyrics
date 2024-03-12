import 'dart:io';

import 'package:afrikalyrics_mobile/misc/app_colors.dart';
import 'package:afrikalyrics_mobile/misc/screen_utils.dart';
import 'package:afrikalyrics_mobile/misc/utils.dart';
import 'package:afrikalyrics_mobile/player/lrc_page.dart';
import 'package:afrikalyrics_mobile/player/player_controller.dart';
import 'package:afrikalyrics_mobile/player/widgets/song_tile.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:marquee_widget/marquee_widget.dart';

class PlayingScreen extends GetView<PlayerController> {
  const PlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(body: Obx(() {
      var playing = PlayerController.to.playing.value;
      return Container(
        height: ScreenUtils.getScreenHeight(context),
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 40,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              AppColors.primary,
              Colors.black87,
            ],
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: const Icon(
                        LineIcons.angleDown,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {
                        Get.back();
                      }),
                  Column(
                    children: <Widget>[
                      const Text(
                        "PLAYING FROM ALBUM",
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${playing.albumTitle}",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          fontFamily: "ProximaNova",
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    LineIcons.verticalEllipsis,
                    color: Colors.white,
                    size: 24,
                  )
                ],
              ),
              SizedBox(
                height: ScreenUtils.getScreenHeight(context) * .1,
              ),
              Expanded(
                child: Container(
                  width: ScreenUtils.getScreenWidth(context) * .85,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: playing.coverUrl != null
                        ? Image.file(File(playing.coverUrl!))
                        : (playing.cover == null /*|| playing.cover.isEmpty*/
                            ? Image.asset(
                                "assets/images/logo-circle.jpg",
                              )
                            : Image.memory(playing.cover!)),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtils.getScreenHeight(context) * .1,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    Get.to(
                      () => LrcPage(),
                      preventDuplicates: false,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: PlayerController.to.isCurrentHasLrc.value == true
                          ? AppColors.primary
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Lyrics",
                        style: TextStyle(
                            fontSize: 18,
                            color: !PlayerController.to.isCurrentHasLrc.value ==
                                    true
                                ? AppColors.primary
                                : Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 25, right: 25),
                width: ScreenUtils.getScreenWidth(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Marquee(
                            child: Text(
                              '${playing.songTitle}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: "ProximaNova",
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                wordSpacing: 0.2,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${playing.artistName}',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontFamily: "ProximaNovaThin",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    width: double.infinity,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.grey.shade600,
                        activeTickMarkColor: Colors.white,
                        thumbColor: Colors.white,
                        trackHeight: 3,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 4,
                        ),
                      ),
                      child: StreamBuilder<Duration>(
                          initialData: const Duration(seconds: 0),
                          stream: controller.currentPosition.stream,
                          builder: (context, snapshot) {
                            return Slider(
                              value: snapshot.data!.inSeconds.toDouble(),
                              min: 0,
                              max: playing.duree.inSeconds.toDouble(),
                              onChanged: (double value) {
                                controller
                                    .seekTo(Duration(seconds: value.toInt()));
                              },
                            );
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "${controller.currentPosition.value.inMinutes.toString().padLeft(2, "0")}:${(controller.currentPosition.value.inSeconds % 60).toString().padLeft(2, "0")}",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontFamily: "ProximaNovaThin",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formatSongDuration(playing.duration),
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontFamily: "ProximaNovaThin",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 22, right: 22),
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        LineIcons.random,
                        color: controller.isShuffle.value
                            ? Colors.white
                            : Colors.grey.shade400,
                      ),
                      onPressed: () => controller.toggleShuffle(),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.skip_previous,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () {
                        controller.playPrevious();
                      },
                    ),
                    IconButton(
                      iconSize: 70,
                      alignment: Alignment.center,
                      icon: controller.isPlaying.value
                          ? const Icon(
                              Icons.pause_circle_filled,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.play_circle_filled,
                              color: Colors.white,
                            ),
                      onPressed: () {
                        if (controller.isPlaying.value) {
                          controller.pause();
                        } else {
                          controller.play();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.skip_next,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () {
                        controller.playNext();
                      },
                    ),
                    StreamBuilder<LoopMode>(
                        stream: controller.currentLoopMode.stream,
                        builder: (context, snapshot) {
                          var mode = snapshot.data;
                          return IconButton(
                              icon: Icon(
                                (mode == LoopMode.none)
                                    ? Icons.repeat
                                    : (mode == LoopMode.single
                                        ? Icons.repeat_one
                                        : LineIcons.reply),
                                color: (mode == LoopMode.single ||
                                        mode == LoopMode.playlist)
                                    ? Colors.white
                                    : Colors.grey.shade400,
                              ),
                              onPressed: () {
                                var index = LoopMode.values.indexOf(mode!);
                                var nextLoop = LoopMode.values[
                                    (index + 1) % LoopMode.values.length];
                                controller.setLoopMode(nextLoop);
                              });
                        }),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 22, right: 22),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.mic,
                        color: Colors.grey.shade400,
                      ),
                      onPressed: () {
                        Get.to(
                          () => LrcPage(),
                          preventDuplicates: false,
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        LineIcons.listUl,
                        color: Colors.grey.shade400,
                      ),
                      onPressed: () {
                        Get.bottomSheet(
                          const CurrentPlaListBottomSheet(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }));
  }
}

class CurrentPlaListBottomSheet extends GetView<PlayerController> {
  const CurrentPlaListBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var songs = controller.playList.value;
      return ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Playlist",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        icon: const Icon(
                          LineIcons.angleDown,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          Get.back();
                        }),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => SongTile(
                      song: songs[index],
                      songs: songs,
                    ),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: songs.length,
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
