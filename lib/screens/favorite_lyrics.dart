import 'package:afrikalyrics_mobile/favorites_controller.dart';
import 'package:afrikalyrics_mobile/misc/app_colors.dart';
import 'package:afrikalyrics_mobile/models/favorite_model.dart';
import 'package:afrikalyrics_mobile/models/lyric_model.dart';
import 'package:afrikalyrics_mobile/screens/lyric_details_screen.dart';
import 'package:afrikalyrics_mobile/widgets/fav_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteLyrics extends GetView<FavoritesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorites Lyrics",
          style: GoogleFonts.caveatBrush().copyWith(
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: Icon(
            Icons.menu,
            size: 35,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Obx(() {
          return GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: controller.favorites.value.length,
            itemBuilder: (context, index) {
              FavoriteModel item = controller.favorites.value[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => LyricDetails(
                    lyric: LyricModel(idLyric: item.idLyric),
                  ));
                },
                child: FavCard(
                  fav: item,
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
