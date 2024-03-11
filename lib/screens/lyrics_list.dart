import 'package:afrikalyrics_mobile/misc/app_colors.dart';
import 'package:afrikalyrics_mobile/misc/screen_utils.dart';
import 'package:afrikalyrics_mobile/models/lyric_model.dart';
import 'package:afrikalyrics_mobile/widgets/lyric_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LyricsList extends StatefulWidget {
  final List<LyricModel> lyrics;
  final String title;

  const LyricsList({super.key, required this.lyrics, this.title = "Lyrics"});

  @override
  _LyricsListState createState() => _LyricsListState();
}

class _LyricsListState extends State<LyricsList> {
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
          itemCount: widget.lyrics.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return LyricCard(
              lyric: widget.lyrics[index],
              width: ScreenUtils.getScreenWidth(context) * .5,
            );
          },
        ),
      ),
    );
  }
}
