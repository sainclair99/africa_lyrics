import 'package:afrikalyrics_mobile/home_controller.dart';
import 'package:afrikalyrics_mobile/misc/app_colors.dart';
import 'package:afrikalyrics_mobile/widgets/genre_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllGenres extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Get.isDarkMode
              ? Image.asset(
                  "assets/images/logo_white.png",
                  height: 48,
                )
              : Image.asset("assets/images/Logo3.png"),
          centerTitle: true,
          leading: BackButton(
            color: AppColors.primary,
          ),
        ),
        body: GridView.builder(
          physics: BouncingScrollPhysics(),
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemCount: controller.allGenres.value.length,
          itemBuilder: (context, index) {
            return Container(
              height: 80,
              child: GenreCard(
                genre: controller.allGenres.value[index],
              ),
            );
          },
        ),
      ),
    );
  }
}
