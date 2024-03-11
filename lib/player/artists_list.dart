import 'dart:io';

import 'package:afrikalyrics_mobile/misc/app_colors.dart';
import 'package:afrikalyrics_mobile/player/artist_songs.dart';
import 'package:afrikalyrics_mobile/player/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/bottom_current_song.dart';

class ArtistsList extends GetView<PlayerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.artists.value == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          var artists = controller.artists.value;
          if (artists.length == 0) {
            return Center(
              child: Text(
                'No Artist Found',
                style: Theme.of(context).textTheme.headline5,
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: Container(
                  child: ListView.separated(
                      separatorBuilder: (context, i) => Divider(),
                      itemCount: artists.length,
                      itemBuilder: (context, index) {
                        var artist = artists[index];
                        return GestureDetector(
                          onTap: () async {
                            await controller.loadArtistSongs(artist);
                            Get.to(() => ArtistSongs(artist));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              child: Row(
                                children: [
                                  if (artist.coverUrl != null)
                                    Image.file(
                                      File('${artist.coverUrl}'),
                                      height: 50,
                                      width: 50,
                                      errorBuilder:
                                          (context, object, stacTrace) {
                                        return Image.asset(
                                          "assets/images/logo-circle.jpg",
                                          width: 50,
                                          height: 50,
                                        );
                                      },
                                    )
                                  else if (artist.cover != null)
                                    Image.memory(
                                      artist.cover!,
                                      height: 50,
                                      width: 50,
                                      errorBuilder:
                                          (context, object, stacTrace) {
                                        return Image.asset(
                                          "assets/images/logo-circle.jpg",
                                          width: 50,
                                          height: 50,
                                        );
                                      },
                                    )
                                  else
                                    Image.asset(
                                      "assets/images/logo-circle.jpg",
                                      width: 50,
                                      height: 50,
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
                                            "${artist.name}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                              letterSpacing: 1,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  ?.color,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            "${artist.songCount} Track(s)",
                                            style: TextStyle(
                                              fontSize: 15,
                                              letterSpacing: 1,
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
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
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
