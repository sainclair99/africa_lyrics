import 'package:afrikalyrics_mobile/misc/app_strings.dart';
import 'package:afrikalyrics_mobile/misc/screen_utils.dart';
import 'package:afrikalyrics_mobile/models/artist_model.dart';
import 'package:afrikalyrics_mobile/models/country_model.dart';
import 'package:afrikalyrics_mobile/services/lyrics_service.dart';
import 'package:afrikalyrics_mobile/widgets/app_cached_image.dart';
import 'package:afrikalyrics_mobile/widgets/app_future_builder.dart';
import 'package:afrikalyrics_mobile/widgets/artist_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../service_locator.dart';

class CountryDetails extends StatefulWidget {
  final CountryModel country;

  const CountryDetails({super.key, required this.country});
  @override
  _CountryDetailsState createState() => _CountryDetailsState();
}

class _CountryDetailsState extends State<CountryDetails> {
  late Future<List<ArtistModel>> _countryArtistsFuture;

  @override
  void initState() {
    super.initState();
    _countryArtistsFuture = locator
        .get<LyricsService>()
        .fetchArtistsByCountry(countryId: widget.country.idPays);
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              AppCachedImage(
                imageUrl: '${widget.country.drapeau}',
                baseUrl: AppStrings.countryImageBaseUrl,
                imageBuilder: (context, provider) {
                  return Container(
                    width: ScreenUtils.getScreenWidth(context),
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: provider as ImageProvider<Object>,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
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
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Artists from ${widget.country.nomPaysEn}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppFutureBuilder<List<ArtistModel>>(
                future: _countryArtistsFuture,
                onError: (e) {
                  print(e);
                },
                onDataWidget: (artists) {
                  print(artists);
                  artists.sort((a, b) => a.nom!.compareTo(b.nom!));
                  return GridView.builder(
                    itemCount: artists.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return ArtistCard(artist: artists[index]);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
