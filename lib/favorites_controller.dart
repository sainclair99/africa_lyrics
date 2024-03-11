import 'package:afrikalyrics_mobile/models/favorite_model.dart';
import 'package:afrikalyrics_mobile/models/lyric_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class FavoritesController extends GetxController {
  late Box<FavoriteModel> favoritesBox; // ! added 'late' tag
  Rx<List<FavoriteModel>> favorites = Rx<List<FavoriteModel>>([]);
  TabController? tabController; //! added "?" tag
  @override
  onInit() {
    super.onInit();

    favoritesBox = Hive.box<FavoriteModel>('favorites');
    favoritesBox.watch().listen((data) {
      print(data.key);
      print(data.value);
    });
    getAll();
  }

  initTabController({required TickerProvider vsync}) {
    // ! added 'required'
    tabController = TabController(initialIndex: 0, length: 5, vsync: vsync);
  }

  moveToPageAt(int index) {
    if (tabController != null) {
      tabController!.animateTo(index);
    }
  }

  getAll() {
    favorites.value = favoritesBox.values.toList();
    print(favoritesBox.values.toList());
  }

  addToFavorite(LyricModel lyric) {
    FavoriteModel fav = FavoriteModel(
      idLyric: lyric.idLyric,
      artiste: lyric.author!.nom,
      cover: lyric.image,
      titre: lyric.titre,
    );
    favoritesBox.put(fav.idLyric, fav);
    favorites.value.add(fav);
    favorites.value = [...favorites.value];
  }

  removeFromFav(int idLyric) {
    favoritesBox.delete(idLyric);
    favorites.value.removeWhere((fav) => fav.idLyric == idLyric);
    favorites.value = [...favorites.value];
  }

  bool isInFavorites(int idLyric) {
    return favorites.value.where((fav) => fav.idLyric == idLyric).isNotEmpty;
  }
}
