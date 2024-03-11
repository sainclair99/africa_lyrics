import 'package:afrikalyrics_mobile/ad_manager.dart';
import 'package:afrikalyrics_mobile/favorites_controller.dart';
import 'package:afrikalyrics_mobile/misc/alert_utils.dart';
import 'package:afrikalyrics_mobile/misc/app_colors.dart';
import 'package:afrikalyrics_mobile/misc/screen_utils.dart';
import 'package:afrikalyrics_mobile/models/lyric_model.dart';
import 'package:afrikalyrics_mobile/screens/artist_details_screen.dart';
import 'package:afrikalyrics_mobile/service_locator.dart';
import 'package:afrikalyrics_mobile/services/lyrics_service.dart';
import 'package:afrikalyrics_mobile/widgets/app_cached_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'lyrics_by_genre.dart';

enum ShowLyric { ORIGINAL, EN, FR }

class LyricDetails extends StatefulWidget {
  final LyricModel lyric;
  const LyricDetails({super.key, required this.lyric});
  @override
  _LyricDetailsState createState() => _LyricDetailsState();
}

class _LyricDetailsState extends State<LyricDetails> {
  late LyricModel lyric;
  late LyricsService _lyricsService;
  late Future<LyricModel> _lyricDetailsFuture;
  late YoutubePlayerController _controller;
  late String videoId;
  bool _showPlayer = false;
  double _top = 5;
  double _left = 0;
  double _bottom = 0;
  bool _isComplete = false;
  ShowLyric _showType = ShowLyric.ORIGINAL;
  Map<String, dynamic> translations = Map();
  @override
  void initState() {
    lyric = widget.lyric;
    _lyricsService = locator.get<LyricsService>();
    _lyricDetailsFuture = _lyricsService.fetchLyricDetails(lyric.idLyric);
    _lyricDetailsFuture.then((result) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted)
          setState(() {
            _isComplete = true;
            lyric = result;
            if (lyric.traductionParoles != null &&
                lyric.traductionParoles!.isNotEmpty) {
              translations["fr"] = lyric.traductionParoles;
            }
            if (lyric.traductionParolesEn != null &&
                lyric.traductionParolesEn!.isNotEmpty) {
              translations["en"] = lyric.traductionParolesEn;
            }

            if (lyric.youtube != null && lyric.youtube!.isNotEmpty) {
              videoId = YoutubePlayer.convertUrlToId(
                lyric.youtube!,
              ) ?? '';
              if (videoId != null) {
                _controller = YoutubePlayerController(
                  initialVideoId: videoId,
                  flags: YoutubePlayerFlags(
                    mute: false,
                    autoPlay: false,
                    disableDragSeek: false,
                    loop: false,
                    isLive: false,
                    forceHD: false,
                    enableCaption: true,
                  ),
                );
                if (_controller != null) {
                  _controller.addListener(listener);
                }
              }
            }
          });
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    AdManager.instance.disposeInterstitialAd();

    super.dispose();
  }

  void listener() {
    // if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
    //   setState(() {
    //     _playerState = _controller.value.playerState;
    //     _videoMetaData = _controller.metadata;
    //   });
    // }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller?.pause();
    super.deactivate();
  }

  Widget _buildContent() {
    return Html(
      data: _showType == ShowLyric.EN
          ? lyric.traductionParolesEn
          : (_showType == ShowLyric.FR
              ? lyric.traductionParoles
              : lyric.paroles),
      // onLinkTap: (url) {
      //   // open url in a webview
      // },
      // onImageTap: (src) {
      //   // Display the image in large form.
      // },
      style: {
        "p": Style(
          fontSize: FontSize.xLarge,
          color: Theme.of(context).textTheme.headline5?.color,
          fontFamily: GoogleFonts.lato().fontFamily,
        )
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var favController = Get.find<FavoritesController>();
    if (lyric.artiste == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return WillPopScope(
      onWillPop: () async {
        AdManager.instance.showInstertialAd();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              ListView(
                children: [
                  Stack(
                    children: [
                      AppCachedImage(
                          imageUrl: '${lyric.image}',
                          imageBuilder: (context, provider) {
                            return Material(
                              color: Colors.transparent,
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: provider as ImageProvider<Object>,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    BackButton(
                                      color: Colors.white,
                                    ),
                                    Expanded(child: Container()),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
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
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                '${lyric.titre}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                    text: '${lyric.author?.nom}'
                                                        .capitalizeFirst,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                    children: [
                                                      if (lyric.featArtists !=
                                                              null &&
                                                          lyric.featArtists
                                                              !.isNotEmpty) ...[
                                                        TextSpan(
                                                          text: " Feat ",
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .primary,
                                                            fontSize: 14.0,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                        for (var i = 0;
                                                            i <
                                                                lyric
                                                                    .featArtists
                                                                    !.length;
                                                            i++)
                                                          TextSpan(
                                                              text: lyric
                                                                  .featArtists![
                                                                      i]
                                                                  .nom
                                                                  ?.capitalizeFirst,
                                                              recognizer:
                                                                  TapGestureRecognizer()
                                                                    ..onTap =
                                                                        () {
                                                                      Get.to(
                                                                        ArtistDetails(
                                                                            artist:
                                                                                lyric.featArtists![i]),
                                                                      );
                                                                    })
                                                      ],
                                                    ]),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: _buildYoutubePreview(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                  ExpansionTile(
                    title: Text(
                      "Song Details",
                      style: TextStyle(
                        fontSize: 18,
                        color: Get.isDarkMode ? Colors.white : null,
                      ),
                    ),
                    maintainState: true,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(
                                          ArtistDetails(artist: lyric.author!));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Artist: ${lyric.author?.nom}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                ?.color,
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Title: ${lyric.titre}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              ?.color,
                                        ),
                                      ),
                                      // Icon(
                                      //   Icons.arrow_forward_ios,
                                      //   color: Colors.grey,
                                      // )
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Album: ${lyric.album}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              ?.color,
                                        ),
                                      ),
                                      // Icon(
                                      //   Icons.arrow_forward_ios,
                                      //   color: Colors.grey,
                                      // )
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Release Year: ${lyric.anneeSortie}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              ?.color,
                                        ),
                                      ),
                                      // Icon(
                                      //   Icons.arrow_forward_ios,
                                      //   color: Colors.grey,
                                      // )
                                    ],
                                  ),
                                  Divider(),
                                  if (lyric.genre != null)
                                    Row(
                                      children: [
                                        Text(
                                          "Genre:",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                ?.color,
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.to(LyricsByGenre(
                                                genre: lyric.genre!,
                                              ));
                                            },
                                            child: Chip(
                                              label: Text(
                                                " ${lyric.genre?.titre}",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .headline5
                                                      ?.color,
                                                ),
                                              ),
                                              backgroundColor:
                                                  AppColors.primary,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            if (translations["en"] != null)
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showType = ShowLyric.EN;
                                    });
                                    print(_showType);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: _showType == ShowLyric.EN
                                          ? AppColors.primary.withOpacity(.5)
                                          : Colors.grey.withOpacity(.3),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                        child: Text("English Translation",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  ?.color,
                                              fontFamily:
                                                  GoogleFonts.lato().fontFamily,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (translations["fr"] != null)
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showType = ShowLyric.FR;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: _showType == ShowLyric.FR
                                          ? AppColors.primary.withOpacity(.5)
                                          : Colors.grey.withOpacity(.3),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                        child: Text("Traduction Francaise",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  ?.color,
                                              fontFamily:
                                                  GoogleFonts.lato().fontFamily,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showType = ShowLyric.ORIGINAL;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: _showType == ShowLyric.ORIGINAL
                                      ? AppColors.primary.withOpacity(.5)
                                      : Colors.grey.withOpacity(.3),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                    child: Text("Original",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              ?.color,
                                          fontFamily:
                                              GoogleFonts.lato().fontFamily,
                                        )),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  AdManager.instance.showBannerAds(context, slot: 4),
                  _buildContent(),
                  ListTile(
                    onTap: () {
                      Get.to(ArtistDetails(
                        artist: lyric.author!,
                      ));
                    },
                    title: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.primary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "More Lyrics By ${lyric.author?.nom}",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.headline5?.color,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                child: _showPlayer && _controller != null
                    ? AnimatedPositioned(
                        duration: Duration(milliseconds: 500),
                        // top: _top,
                        bottom: _bottom,
                        left: _left,
                        child: Draggable(
                          onDragEnd: (details) {
                            if (details.offset.dx > 0) {
                              _left = details.offset.dx;
                            } else if (details.offset.dx >
                                ScreenUtils.getScreenWidth(context)) {
                              _left = ScreenUtils.getScreenWidth(context);
                            } else {
                              _left = 0;
                            }
                            if (details.offset.dy > 0) {
                              _top = details.offset.dy;

                              _bottom = details.offset.dy;
                            } else {
                              _top = 0;
                              _bottom = ScreenUtils.getScreenHeight(context) -
                                  details.offset.dy;
                              print(details.offset);
                            }
                            setState(() {});
                            _controller.play();
                          },
                          onDragStarted: () {
                            _controller.pause();
                          },
                          child: brandPlayer(context),
                          feedback: Container(
                            width: ScreenUtils.getScreenWidth(context) * .5,
                            height: ScreenUtils.getScreenWidth(context) * .5,
                            child: Image.network(
                              YoutubePlayer.getThumbnail(
                                videoId: videoId,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ),
            ],
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() {
                bool isInFav =
                    favController.isInFavorites(widget.lyric.idLyric!);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: FloatingActionButton(
                    heroTag: Key("Favorite"),
                    onPressed: () {
                      if (isInFav) {
                        favController.removeFromFav(widget.lyric.idLyric!);
                      } else {
                        favController.addToFavorite(widget.lyric);
                      }
                    },
                    child: Icon(
                      Icons.favorite,
                      color: isInFav ? Colors.red : null,
                    ),
                  ),
                );
              }),
              FloatingActionButton(
                heroTag: Key("Share"),
                onPressed: () {
                  print(widget.lyric.url);
                  Share.share(
                    'check out *${widget.lyric.author?.nom}-${widget.lyric.titre}* Lyrics at ${widget.lyric.url} \n#AfrikaLyrics',
                  );
                },
                child: Icon(Icons.share),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYoutubePreview() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_controller == null) {
            showError("Couldn't parse the video");
          } else {
            _showPlayer = true;
            _controller?.play();
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
    );
  }

  Container brandPlayer(BuildContext context) {
    return Container(
      width: ScreenUtils.getScreenWidth(context) * .6,
      height: ScreenUtils.getScreenWidth(context) * .6,
      child: Stack(
        children: <Widget>[
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
          ),
          Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 35,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _showPlayer = false;
                    _controller?.pause();
                  });
                },
              ))
        ],
      ),
    );
  }
}
