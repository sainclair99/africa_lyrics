import 'package:afrikalyrics_mobile/models/lyric_model.dart';
import 'package:afrikalyrics_mobile/screens/lyric_details_screen.dart';
import 'package:afrikalyrics_mobile/service_locator.dart';
import 'package:afrikalyrics_mobile/services/lyrics_service.dart';
import 'package:afrikalyrics_mobile/widgets/app_future_builder.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class AlSearchDelegate extends SearchDelegate {
  final debouncer = Debouncer<String>(Duration(milliseconds: 250), initialValue: '');
  final bool _isSearching = false;
  final bool _isSearchCompleted = false;
  final bool _hasError = false;
  List<LyricModel> _songs = [];
  final bool waitQuery;

  AlSearchDelegate({this.waitQuery = false});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? Container()
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

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSuggestions(context);
  }

  _buildSuggestions(BuildContext context) {
    final suggestionsBox = Hive.box<String>('suggestions');
    suggestionsBox.watch().listen((event) {
      print(event);
    });
    var allSuggestions = suggestionsBox.values.toList();
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              "Your recent search",
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).textTheme.headline6?.color,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                height: 1,
              ),
              itemCount: allSuggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    this.query = allSuggestions[index];
                    this.showResults(context);
                  },
                  title: Text(
                    "${allSuggestions[index]}",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline5?.color,
                    ),
                  ),
                  trailing: GestureDetector(
                      onTap: () {
                        suggestionsBox.delete(allSuggestions[index]);
                        this.buildSuggestions(context);
                      },
                      child: Icon(Icons.clear)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildContent() {
    if (this.waitQuery) {
      Get.back(result: this.query);
    }
    if (query.isEmpty) {
      return Center(child: Text("Start Typing ..."));
    }
    if (query.length < 2) {
      return Center(child: Text("Type at least two letters ..."));
    }

    return AppFutureBuilder<List<LyricModel>>(
      future: searchSongs(query),
      loadingWidget: Center(
        child: CircularProgressIndicator(),
      ),
      onDataWidget: (lyrics) {
        return ListView.separated(
          itemCount: lyrics.length,
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemBuilder: (context, index) {
            var l = lyrics[index];
            return ListTile(
              onTap: () {
                final suggestionsBox = Hive.box<String>('suggestions');
                suggestionsBox.add(this.query);
                close(context, null);
                Get.to(() => LyricDetails(
                      lyric: l,
                    ));
              },
              title: Text(
                '${l.titre}',
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline6?.color,
                ),
              ),
              subtitle: Text(
                "${l.author?.nom}",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline6?.color,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<List<LyricModel>> searchSongs(String query) async {
    debouncer.value = query;
    String nextValue = await debouncer.nextValue;
    return locator.get<LyricsService>().findLyrics(s: nextValue);
  }
}
