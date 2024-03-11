import 'package:afrikalyrics_mobile/api/al_api.dart';
import 'package:afrikalyrics_mobile/misc/app_colors.dart';
import 'package:afrikalyrics_mobile/misc/screen_utils.dart';
import 'package:afrikalyrics_mobile/models/genre_model.dart';
import 'package:afrikalyrics_mobile/models/lyric_model.dart';
import 'package:afrikalyrics_mobile/services/lyrics_service.dart';
import 'package:afrikalyrics_mobile/widgets/lyric_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../service_locator.dart';

class LyricsByGenre extends StatefulWidget {
  final GenreModel genre;
  const LyricsByGenre({super.key, required this.genre});
  @override
  _LyricsByGenreState createState() => _LyricsByGenreState();
}

class _LyricsByGenreState extends State<LyricsByGenre> {
  late Future<List<LyricModel>> _genreLyricsFuture;
  late ALApi _alApi;
  int _page = 1;
  late List<LyricModel> _lyrics;
  bool _canLoadMore = true;
  bool _isLoading = false;
  late ScrollController _scrollController;
  @override
  void initState() {
    _genreLyricsFuture = locator
        .get<LyricsService>()
        .fetchGenreDetails(widget.genre.idCategorie!);
    _alApi = locator.get<ALApi>();
    _lyrics = /*List<LyricModel>()*/[];
    _scrollController = ScrollController();
    _scrollController.addListener(scrollListener);
    this._loadMore(_page);
    super.initState();
  }

  scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        _isLoading == false) {
      _loadMore(_page);
    }
  }

  _loadMore(int page) async {
    if (!_canLoadMore) return;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _isLoading = true;
      });
    });
    var resp = await this
        ._alApi
        .getRequest("/lyrics/genres/${widget.genre.idCategorie}?page=$page");
    var data = resp.data["data"];
    List<LyricModel> listData = [];
    for (var i = 0; i < data['data'].length; i++) {
      listData.add(LyricModel.fromJson(data['data'][i]));
    }
    _lyrics.addAll(listData);
    _page++;
    _canLoadMore = _page < data["last_page"];
    _isLoading = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) setState(() {});
    });
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
          actions: [
            if (_isLoading && _page != 1)
              Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.search,
                color: AppColors.primary,
                size: 35,
              ),
            )
          ],
          bottom: PreferredSize(
            child: Container(
              height: 50,
              width: ScreenUtils.getScreenWidth(context),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  Colors.black,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              )),
              child: Center(
                child: Text(
                  "${widget.genre.titre} Lyrics",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            preferredSize: Size(ScreenUtils.getScreenWidth(context), 50),
          ),
        ),
        body: (_isLoading && _page == 1)
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : GridView.builder(
                physics: BouncingScrollPhysics(),
                controller: _scrollController,
                itemCount: _lyrics.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return LyricCard(
                    lyric: _lyrics[index],
                    width: ScreenUtils.getScreenWidth(context) * .33,
                  );
                },
              ),
      ),
    );
  }
}
