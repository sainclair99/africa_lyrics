import 'package:afrikalyrics_mobile/favorites_controller.dart';
import 'package:afrikalyrics_mobile/misc/app_colors.dart';
import 'package:afrikalyrics_mobile/player/home_media.dart';
import 'package:afrikalyrics_mobile/screens/favorite_lyrics.dart';
import 'package:afrikalyrics_mobile/screens/home_screen.dart';
import 'package:afrikalyrics_mobile/screens/search_lytics_sreen.dart';
import 'package:afrikalyrics_mobile/screens/submit_lyrics.dart';
import 'package:afrikalyrics_mobile/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import 'keep_alive_wrapper.dart';

class BottomNavigationPage extends StatefulWidget {
  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage>
    with SingleTickerProviderStateMixin {
  late FavoritesController favoritesController; // ! added "late" tag

  @override
  void initState() {
    // _tabController = TabController(initialIndex: 0, length: 5, vsync: this);
    favoritesController = Get.find<FavoritesController>();
    favoritesController.initTabController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: AppDrawer(),
        body: DefaultTabController(
          length: 5,
          child: TabBarView(
            controller: favoritesController.tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              KeepAliveWrapper(child: HomeScreen()),
              KeepAliveWrapper(child: HomeMediaScreen()),
              KeepAliveWrapper(child: SearchLyricsScreen()),
              KeepAliveWrapper(child: FavoriteLyrics()),
              KeepAliveWrapper(child: SubmitLyricPage()),
            ],
          ),
        ),
        bottomNavigationBar: Material(
          elevation: 5,
          child: Container(
            height: 60,
            color: Theme.of(context).bottomAppBarColor,
            child: TabBar(
              controller: favoritesController.tabController,
              indicator: BoxDecoration(
                // color: AppColors.primary,
                border: Border(
                  top: BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
              unselectedLabelColor: Theme.of(context).textTheme.headline5!.color, // ! added "!" symbol
              labelColor: AppColors.primary,
              labelStyle:
                  GoogleFonts.caveatBrushTextTheme(Theme.of(context).textTheme)
                      .headline6
                      !.copyWith( // ! added "!" symbol
                        fontSize: 16,
                      ),
              tabs: [
                Tab(
                  iconMargin: EdgeInsets.zero,
                  text: "Home",
                  icon: Icon(
                    Icons.home,
                  ),
                ),
                Tab(
                  iconMargin: EdgeInsets.zero,
                  text: "Player",
                  icon: Icon(
                    Icons.library_music,
                  ),
                ),
                Tab(
                  iconMargin: EdgeInsets.zero,
                  text: "Search",
                  icon: Icon(
                    Icons.search,
                  ),
                ),
                Tab(
                  iconMargin: EdgeInsets.zero,
                  text: "Favorites",
                  icon: Icon(
                    Icons.favorite,
                  ),
                ),
                Tab(
                  iconMargin: EdgeInsets.zero,
                  text: "Submit",
                  icon: Icon(
                    Icons.send,
                  ),
                ),

                // Tab(
                //   icon: Icon(
                //     Icons.folder,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
