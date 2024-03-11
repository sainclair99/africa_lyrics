import 'package:afrikalyrics_mobile/misc/screen_utils.dart';
import 'package:afrikalyrics_mobile/models/artist_model.dart';
import 'package:afrikalyrics_mobile/models/lyric_model.dart';
import 'package:afrikalyrics_mobile/service_locator.dart';
import 'package:afrikalyrics_mobile/services/lyrics_service.dart';
import 'package:afrikalyrics_mobile/widgets/app_future_builder.dart';
import 'package:afrikalyrics_mobile/widgets/lyric_card.dart';
import 'package:flutter/material.dart';

class LyricsByArtist extends StatefulWidget {
  final ArtistModel artist;
  final String name;

  const LyricsByArtist({super.key, required this.artist, required this.name});
  @override
  _LyricsByArtistState createState() => _LyricsByArtistState();
}

class _LyricsByArtistState extends State<LyricsByArtist> {
  late Future<List<LyricModel>> _lyricFuture;
  @override
  void initState() {
    _lyricFuture = locator
        .get<LyricsService>()
        .findLyrics(artistId: widget.artist.idArtiste);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Lyrics By ${widget.name}"),
        ),
        body: AppFutureBuilder<List<LyricModel>>(
          future: _lyricFuture,
          onDataWidget: (lyrics) {
            return CustomScrollView(slivers: [
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                delegate: SliverChildListDelegate(
                  [
                    for (var i = 0; i < lyrics.length; i++)
                      LyricCard(
                        lyric: lyrics[i],
                        artist: widget.artist,
                        width: ScreenUtils.getScreenWidth(context) * .33,
                      )
                  ],
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}
