import 'dart:io';

import 'package:afrikalyrics_mobile/player/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'album_songs.dart';
import 'widgets/bottom_current_song.dart';

class AlbumsList extends GetView<PlayerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.albums.value == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          var albums = controller.albums.value;
          if (albums.length == 0) {
            return Center(
              child: Text(
                'No Album Found',
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
                      itemCount: albums.length,
                      itemBuilder: (context, index) {
                        var album = albums[index];
                        return GestureDetector(
                          onTap: () async {
                            await controller.loadAlbumSongs(album);
                            Get.to(() => AlbumSongs(album));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              child: Row(
                                children: [
                                  if (album.coverUrl != null)
                                    Image.file(
                                      File('${album.coverUrl}'),
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
                                  else if (album.cover != null)
                                    Image.memory(
                                      album.cover!,
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
                                            "${album.name}",
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
                                            "${album.songCount} Track(s)",
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
