import 'dart:math';

import 'package:afrikalyrics_mobile/misc/app_colors.dart';
import 'package:afrikalyrics_mobile/misc/app_strings.dart';
import 'package:afrikalyrics_mobile/misc/screen_utils.dart';
import 'package:afrikalyrics_mobile/models/artist_model.dart';
import 'package:afrikalyrics_mobile/screens/country_details.dart';
import 'package:afrikalyrics_mobile/service_locator.dart';
import 'package:afrikalyrics_mobile/services/artists_service.dart';
import 'package:afrikalyrics_mobile/widgets/app_cached_image.dart';
import 'package:afrikalyrics_mobile/widgets/app_future_builder.dart';
import 'package:afrikalyrics_mobile/widgets/lyric_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class ArtistDetails extends StatefulWidget {
  final ArtistModel artist;

  const ArtistDetails({super.key, required this.artist});
  @override
  _ArtistDetailsState createState() => _ArtistDetailsState();
}

class _ArtistDetailsState extends State<ArtistDetails> {
  late ArtistModel artist;
  late Future<ArtistModel> _getArtistDetails;
  bool isExpanded = false;
  @override
  void initState() {
    artist = widget.artist;
    _getArtistDetails = locator
        .get<ArtistsService>()
        .fetchArtistDetails(widget.artist.idArtiste);
    super.initState();
  }

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
        body: AppFutureBuilder<ArtistModel>(
            future: _getArtistDetails,
            onDataWidget: (data) {
              artist = data;
              return CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AppCachedImage(
                                  imageUrl: "${artist.image}",
                                  baseUrl: AppStrings.artistImageBaseUrl,
                                  imageBuilder: (context, provider) {
                                    return Container(
                                      height: 75,
                                      width: 75,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(150),
                                        image: DecorationImage(
                                          image: provider as ImageProvider<Object>,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "${artist.nom}",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              ?.color,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(() => CountryDetails(
                                              country: artist.country!));
                                        },
                                        child: Chip(
                                          onDeleted: () {
                                            Get.to(() => CountryDetails(
                                                country: artist.country!));
                                          },
                                          label: Text(
                                            "${artist.country?.nomPays}",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  ?.color,
                                            ),
                                          ),
                                          deleteIcon: Image.network(
                                            AppStrings.countryImageBaseUrl +
                                                artist.country!.drapeau!,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: Text(
                            "Artist Biography",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.headline5?.color,
                            ),
                          ),
                          children: [
                            if ("${artist.biographieEn}".length >= 200) ...[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Html(
                                  data: isExpanded
                                      ? artist.biographieEn
                                      : "${artist.biographieEn}".substring(0,
                                          min(199, "${artist.biographie}".length)),
                                  style: {
                                    "p": Style(
                                      fontSize: FontSize.large,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          ?.color,
                                      fontFamily: "lato",
                                    )
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isExpanded = !isExpanded;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "${isExpanded ? 'View Less' : 'View More'}"),
                                    ),
                                  ),
                                ),
                              )
                            ] else
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Html(
                                  data: artist.biographieEn,
                                  style: {
                                    "p": Style(
                                      fontSize: FontSize.large,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          ?.color,
                                      fontFamily: "lato",
                                    )
                                  },
                                ),
                              )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Lyrics By ${artist.nom}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.headline5?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    delegate: SliverChildListDelegate(
                      [
                        for (var i = 0; i < artist.lyrics!.length; i++)
                          LyricCard(
                            lyric: artist.lyrics![i],
                            artist: artist,
                            width: ScreenUtils.getScreenWidth(context) * .33,
                          )
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
