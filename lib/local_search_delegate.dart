import 'dart:async';
import 'package:afrikalyrics_mobile/player/models/LocalSong.dart';
import 'package:afrikalyrics_mobile/player/player_controller.dart';
import 'package:afrikalyrics_mobile/player/widgets/song_tile.dart';
import 'package:afrikalyrics_mobile/widgets/app_future_builder.dart';
import './misc/string_ext.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';

class LocalSearchDelegate extends SearchDelegate {
  final debouncer = Debouncer<String>(Duration(milliseconds: 250), initialValue: '');

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  Future<List<LocalSong>> queryChanged(String query) async {
    debouncer.value = query;
    String nextValue = await debouncer.nextValue;
    var songs = PlayerController.to.songs.value
        .where(
          (element) =>
              '${element.songTitle}'
                  .replaceAll(" ", "")
                  .toLowerCase()
                  .withoutDiacriticalMarks
                  .contains(nextValue
                      .replaceAll(" ", "")
                      .withoutDiacriticalMarks
                      .toLowerCase()) ||
              '${element.artistName}'
                  .replaceAll(" ", "")
                  .withoutDiacriticalMarks
                  .toLowerCase()
                  .contains(nextValue
                      .replaceAll(" ", "")
                      .withoutDiacriticalMarks
                      .toLowerCase()),
        )
        .toList();
    return songs;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? IconButton(
              tooltip: 'Voice Search',
              icon: const Icon(Icons.mic),
              onPressed: () {
                query = 'TODO: implement voice input';
              },
            )
          : IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    if (query.isEmpty) {
      return Center(child: Text("Start Typing ..."));
    }
    return AppFutureBuilder<List<LocalSong>>(
      future: queryChanged(query),
      loadingWidget: Center(child: CircularProgressIndicator()),
      onDataWidget: (songs) {
        if (songs.length == 0) {
          return Center(
            child: Text("No Result found"),
          );
        }
        return ListView.separated(
          itemCount: songs.length,
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemBuilder: (context, index) {
            var l = songs[index];
            return SongTile(
              song: l,
              songs: songs,
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildContent();
  }
}
