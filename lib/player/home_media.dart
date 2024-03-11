import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../local_search_delegate.dart';
import './albums_list.dart';
import './artists_list.dart';
import './song_list.dart';

class HomeMediaScreen extends StatefulWidget {
  @override
  _HomeMediaScreenState createState() => _HomeMediaScreenState();
}

class _HomeMediaScreenState extends State<HomeMediaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
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
              showSearch(
                context: context,
                delegate: LocalSearchDelegate(),
              );
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
        bottom: TabBar(
          controller: _tabController,
          unselectedLabelColor: Theme.of(context).textTheme.headline5?.color,
          unselectedLabelStyle: Theme.of(context).textTheme.headline5,
          // labelColor: Theme.of(context).accentColor,
          labelColor: Theme.of(context).primaryColor,
          tabs: [
            Tab(
              child: Text(
                'TRACKS',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontSize: 20,
                    ),
              ),
            ),
            Tab(
              child: Text(
                'ARTISTS',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontSize: 20,
                    ),
              ),
            ),
            Tab(
              child: Text(
                'ALBUM',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontSize: 20,
                    ),
              ),
            ),
          ],
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: TabBarView(
          controller: _tabController,
          children: [
            SongList(),
            ArtistsList(),
            AlbumsList(),
          ],
        ),
      ),
    );
  }
}
