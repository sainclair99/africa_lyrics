import 'dart:async';
import 'dart:math';

import 'package:afrikalyrics_mobile/ad_manager.dart';
import 'package:afrikalyrics_mobile/al_search_delegate.dart';
import 'package:afrikalyrics_mobile/favorites_controller.dart';
import 'package:afrikalyrics_mobile/home_controller.dart';
import 'package:afrikalyrics_mobile/misc/app_colors.dart';
import 'package:afrikalyrics_mobile/misc/app_sizes.dart';
import 'package:afrikalyrics_mobile/misc/screen_utils.dart';
import 'package:afrikalyrics_mobile/misc/string_ext.dart';
import 'package:afrikalyrics_mobile/misc/utils.dart';
import 'package:afrikalyrics_mobile/models/artist_model.dart';
import 'package:afrikalyrics_mobile/models/lyric_model.dart';
import 'package:afrikalyrics_mobile/screens/all_artists_screen.dart';
import 'package:afrikalyrics_mobile/screens/all_countries.dart';
import 'package:afrikalyrics_mobile/screens/all_genres.dart';
import 'package:afrikalyrics_mobile/screens/all_lyrics_screen.dart';
import 'package:afrikalyrics_mobile/screens/lyric_details_screen.dart';
import 'package:afrikalyrics_mobile/screens/lyrics_list.dart';
import 'package:afrikalyrics_mobile/service_locator.dart';
import 'package:afrikalyrics_mobile/services/artists_service.dart';
import 'package:afrikalyrics_mobile/services/lyrics_service.dart';
import 'package:afrikalyrics_mobile/widgets/app_cached_image.dart';
import 'package:afrikalyrics_mobile/widgets/app_future_builder.dart';
import 'package:afrikalyrics_mobile/widgets/artist_card.dart';
import 'package:afrikalyrics_mobile/widgets/country_card.dart';
import 'package:afrikalyrics_mobile/widgets/genre_card.dart';
import 'package:afrikalyrics_mobile/widgets/lyric_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ! added 'late'
  late Future<List<LyricModel>> popularLyricsFuture;
  late Future<List<LyricModel>> topLyricsFuture;
  late Future<List<LyricModel>> latestLyricsFuture;
  late Future<List<LyricModel>> translationsLyricsFuture;
  late Future<List<ArtistModel>> topArtistsFuture;
  late LyricsService _lyricsService;
  late ArtistsService _artistsService;
  late HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<HomeController>();
  }

  setFutures({shouldSetState = false}) {
    Completer _completer = Completer();
    popularLyricsFuture = controller.loadPopularLyrics();
    topLyricsFuture = controller.loadTopLyrics();
    latestLyricsFuture = controller.loadLatestLyrics();
    translationsLyricsFuture = controller.loadTranslationsLyrics();
    topArtistsFuture = _artistsService.fetchTopArtists();
    _completer.complete();
    return _completer.future;
  }

  Future<void> _onRefresh() {
    return setFutures(shouldSetState: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Get.isDarkMode
            ? Image.asset(
                "assets/images/logo_white.png",
                height: 48,
              )
            : Image.asset("assets/images/Logo3.png"),
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
        actions: [
          GestureDetector(
            onTap: () {
              Get.find<FavoritesController>().moveToPageAt(2);
              // showSearch(
              //   context: context,
              //   delegate: AlSearchDelegate(),
              // );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.search,
                size: 35,
              ),
            ),
          )
        ],
      ),
      //.withBottomAdmobBanner(context),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          children: [
            Obx(() {
              if (controller.popularLyrics.value == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                var lyrics = controller.popularLyrics.value;

                return CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                  ),
                  items: lyrics
                      .map((item) => GestureDetector(
                            onTap: () {
                              Get.to(() => LyricDetails(lyric: item));
                            },
                            child: Container(
                              margin: EdgeInsets.all(5.0),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  child: Stack(
                                    children: <Widget>[
                                      AppCachedImage(
                                          imageUrl: "${item.image}",
                                          imageBuilder: (context, provider) {
                                            return Container(
                                              width: 1000,
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
                                                '${item.titre}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '${item.author?.nom}'
                                                    .capitalizeFirst ?? '',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ))
                      .toList(),
                );
              }
            }),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Browse Lyrics By Country",
                          style: Theme.of(context).textTheme.headline5?.copyWith(
                                fontSize: 30,
                              ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => AllCountries());
                          },
                          child: Text(
                            "View More",
                            style:
                                Theme.of(context).textTheme.headline6?.copyWith(
                                      fontSize: 15,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: AppSizes.artistCardH,
                    child: Obx(() {
                      if (controller.allCountries.value == null &&
                          controller.allCountriesError.value == null) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        var countries = controller.allCountries.value;
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: min(countries.length, 9),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return CountryCard(
                              country: countries[index],
                            );
                          },
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
            AdManager.instance.showBannerAds(context, slot: 1),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Top Lyrics",
                          style: Theme.of(context).textTheme.headline5?.copyWith(
                                fontSize: 30,
                              ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (controller.topLyrics.value != null)
                              Get.to(() => LyricsList(
                                lyrics: controller.topLyrics.value,
                              ));
                          },
                          child: Text(
                            "View More",
                            style:
                                Theme.of(context).textTheme.headline6?.copyWith(
                                      fontSize: 15,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: AppSizes.artistCardH,
                    child: Obx(() {
                      if (controller.topLyrics.value == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        var lyrics = controller.topLyrics.value;
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: lyrics.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Hero(
                              tag: '${lyrics[index].image}' + "-hero",
                              child: LyricCard(
                                lyric: lyrics[index],
                              ),
                            );
                          },
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Top Artists",
                          style: Theme.of(context).textTheme.headline5?.copyWith(
                                fontSize: 30,
                              ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => AllArtists());
                          },
                          child: Text(
                            "View More",
                            style:
                                Theme.of(context).textTheme.headline6?.copyWith(
                                      fontSize: 15,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: AppSizes.artistCardH,
                    child: Obx(() {
                      if (controller.topArtists.value == null) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        var artists = controller.topArtists.value;
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: artists.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return ArtistCard(
                              artist: artists[index],
                            );
                          },
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
            AdManager.instance.showBannerAds(context, slot: 2),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Browse Lyrics By Genre",
                          style: Theme.of(context).textTheme.headline5?.copyWith(
                                fontSize: 30,
                              ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => AllGenres());
                          },
                          child: Text(
                            "View More",
                            style:
                                Theme.of(context).textTheme.headline6?.copyWith(
                                      fontSize: 15,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Obx(() {
                      if (controller.allGenres.value == null) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        var genres = controller.allGenres.value;
                        double cardHeight = 120;
                        double lineNumber = 3;
                        return Column(
                          children: [
                            for (var i = 0; i < min(lineNumber, genres.length); i++)
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: cardHeight,
                                      child: GenreCard(genre: genres[i]),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: cardHeight,
                                      child: GenreCard(genre: genres[i + 1]),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recently Translated",
                          style: Theme.of(context).textTheme.headline5?.copyWith(
                                fontSize: 30,
                              ),
                        ),
                        Text(
                          "View More",
                          style: Theme.of(context).textTheme.headline6?.copyWith(
                                fontSize: 15,
                              ),
                        ),
                      ],
                    ),
                  ),
                  AdManager.instance.showBannerAds(context, slot: 3),
                  Container(
                    height: AppSizes.artistCardH,
                    child: Obx(() {
                      if (controller.translationsLyrics.value == null) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        var lyrics = controller.translationsLyrics.value;
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: lyrics.length > 9 ? 9 : lyrics.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return LyricCard(lyric: lyrics[index]);
                          },
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
