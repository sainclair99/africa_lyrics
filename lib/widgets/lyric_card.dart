import 'package:afrikalyrics_mobile/favorites_controller.dart';
import 'package:afrikalyrics_mobile/misc/app_sizes.dart';
import 'package:afrikalyrics_mobile/models/artist_model.dart';
import 'package:afrikalyrics_mobile/models/lyric_model.dart';
import 'package:afrikalyrics_mobile/screens/lyric_details_screen.dart';
import 'package:afrikalyrics_mobile/widgets/app_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LyricCard extends StatelessWidget {
  final LyricModel lyric;
  final double width;
  final ArtistModel? artist;

  const LyricCard({
    super.key,
    required this.lyric,
    this.width = AppSizes.artistCardH,
    this.artist,
  });
  @override
  Widget build(BuildContext context) {
    if (artist != null) {
      lyric.author = artist;
    }
    return Container(
      child: GestureDetector(
        onTap: () {
          Get.to(
            LyricDetails(lyric: lyric),
          );
        },
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: width,
            height: width,
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    AppCachedImage(
                        imageUrl: "${lyric.image}",
                        imageBuilder: (context, provider) {
                          return Container(
                            width: width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: provider as ImageProvider<Object>,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${lyric.titre}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${lyric.author?.nom}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.0,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(() {
                      var favController = Get.find<FavoritesController>();

                      bool isInFav =
                          favController.isInFavorites(lyric.idLyric!);

                      return Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            if (isInFav) {
                              favController.removeFromFav(lyric.idLyric!);
                            } else {
                              favController.addToFavorite(lyric);
                            }
                          },
                          icon: Icon(
                            isInFav
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            color: Colors.red,
                          ),
                        ),
                      );
                    }),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
