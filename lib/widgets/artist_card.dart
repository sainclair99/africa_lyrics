import 'package:afrikalyrics_mobile/misc/app_sizes.dart';
import 'package:afrikalyrics_mobile/misc/app_strings.dart';
import 'package:afrikalyrics_mobile/models/artist_model.dart';
import 'package:afrikalyrics_mobile/screens/artist_details_screen.dart';
import 'package:afrikalyrics_mobile/widgets/app_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArtistCard extends StatelessWidget {
  final ArtistModel artist;
  const ArtistCard({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Get.to(() => ArtistDetails(artist: artist));
        },
        child: Container(
          width: AppSizes.artistCardH,
          height: AppSizes.artistCardH,
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Stack(
                children: <Widget>[
                  AppCachedImage(
                      imageUrl: "${artist.image}",
                      baseUrl: AppStrings.artistImageBaseUrl,
                      imageBuilder: (context, provider) {
                        return Container(
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
                            '${artist.nom}'.capitalizeFirst ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
