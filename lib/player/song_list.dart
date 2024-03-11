import 'package:afrikalyrics_mobile/misc/app_colors.dart';
import 'package:afrikalyrics_mobile/misc/utils.dart';
import 'package:afrikalyrics_mobile/player/player_controller.dart';
import 'package:afrikalyrics_mobile/player/widgets/song_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/bottom_current_song.dart';

class SongList extends GetView<PlayerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.songs.value == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          var songs = controller.songs.value;
          if (songs.length == 0) {
            return Center(
              child: Text(
                'No Song Found',
                style: Theme.of(context).textTheme.headline5,
              ),
            );
          }
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
                      return SongTile(
                        song: song,
                        songs: songs,
                      );
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
