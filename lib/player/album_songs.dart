import 'package:afrikalyrics_mobile/misc/app_colors.dart';
import 'package:afrikalyrics_mobile/player/models/LocalAlbum.dart';
import 'package:afrikalyrics_mobile/player/models/LocalArtist.dart';
import 'package:afrikalyrics_mobile/player/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'lrc_page.dart';
import 'playing.dart';
import 'song_image_widget.dart';
import 'widgets/bottom_current_song.dart';

class AlbumSongs extends GetView<PlayerController> {
  final LocalAlbum album;
  bool _isLoaded = false;

  AlbumSongs(this.album);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${album.name}"),
      ),
      body: Obx(() {
        if (controller.currentArtistSongs.value == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          var songs = controller.currentAlbumSongs.value;
          return Column(
            children: [
              Expanded(
                child: Container(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return Container(
                        height: 1,
                        color: Colors.grey.withOpacity(.5),
                      );
                    },
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      var song = songs[index];
                      return Obx(() {
                        bool currentSongActive =
                            controller.playing.value != null &&
                                controller.playing.value.songId == song.songId;
                        return GestureDetector(
                          onTap: () async {
                            if (!_isLoaded) {
                              await controller.playCurrentArtistSong();
                              _isLoaded = true;
                            }
                            if (currentSongActive &&
                                controller.isPlaying.value) {
                              controller.play(listSong: songs);
                            } else {
                              controller.play(song: song, listSong: songs);
                            }
                            Get.to(PlayingScreen());
                            Get.to(LrcPage());
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${song.songTitle}",
                                            style: TextStyle(
                                              color: currentSongActive
                                                  ? AppColors.primary
                                                  : Theme.of(context)
                                                      .textTheme
                                                      .headline5
                                                      ?.color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            "${song.artistName}",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  ?.color,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: IconButton(
                                      icon: Icon((currentSongActive &&
                                              controller.isPlaying.value)
                                          ? Icons.pause
                                          : Icons.play_arrow),
                                      onPressed: () {
                                        if (currentSongActive) {
                                          if (controller.isPlaying.value) {
                                            controller.pause();
                                          } else {
                                            controller.play(listSong: songs);
                                          }
                                        } else {
                                          controller.play(
                                              song: song, listSong: songs);
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
                    },
                  ),
                ),
              ),
              if (controller.playing.value != null) BottomCurrentSong(),
            ],
          );
        }
      }),
    );
  }
}
