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

class SearchLyricsScreen extends StatefulWidget {
  const SearchLyricsScreen({super.key});
  @override
  _SearchLyricsScreenState createState() => _SearchLyricsScreenState();
}

class _SearchLyricsScreenState extends State<SearchLyricsScreen> {
  late ALApi _alApi;
  int _page = 1;
  late List<LyricModel> _lyrics;
  bool _canLoadMore = true;
  bool _isLoading = false;
  late ScrollController _scrollController;
  String? s;
  late TextEditingController _searchController;
  @override
  void initState() {
    _alApi = locator.get<ALApi>();
    _lyrics = /*List<LyricModel>()*/[];
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    _scrollController.addListener(scrollListener);

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
    if (!_canLoadMore || _searchController.text.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _isLoading = true;
      });
    });

    var resp = await this._alApi.getRequest(
        "/lyrics?s=${_searchController.text}&page=$page&save_search=true");
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

  _makeSearch() {
    _page = 1;
    _canLoadMore = true;
    _loadMore(this._page);
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
            if (_isLoading && _page != 1)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
          ],
          bottom: _searchController.text.isNotEmpty
              ? PreferredSize(
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
                        "Search results for \"${_searchController.text}\"",
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
                )
              : null,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: Theme.of(context).textTheme.headline5,
                      decoration: InputDecoration(
                        hintText: "Enter your search",
                      ),
                      onSubmitted: (value) {
                        _makeSearch();
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      _makeSearch();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  GridView.builder(
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
                  if (_isLoading && _page == 1)
                    Center(
                      child: CircularProgressIndicator(),
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
