import 'package:afrikalyrics_mobile/misc/utils.dart';
import 'package:afrikalyrics_mobile/models/genre_model.dart';
import 'package:get/get.dart';

import 'models/artist_model.dart';
import 'models/country_model.dart';
import 'models/lyric_model.dart';
import 'service_locator.dart';
import 'services/artists_service.dart';
import 'services/lyrics_service.dart';

// ! added init parameters : '' and []

class HomeController extends GetxController {
  late LyricsService _lyricsService;
  late ArtistsService _artistsService;
  Rx<List<LyricModel>> popularLyrics = Rx<List<LyricModel>>([]);
  Rx<List<LyricModel>> topLyrics = Rx<List<LyricModel>>([]);
  Rx<List<LyricModel>> latestLyrics = Rx<List<LyricModel>>([]);
  Rx<List<LyricModel>> translationsLyrics = Rx<List<LyricModel>>([]);
  Rx<List<ArtistModel>> topArtists = Rx<List<ArtistModel>>([]);
  Rx<List<GenreModel>> allGenres = Rx<List<GenreModel>>([]);
  Rx<List<CountryModel>> allCountries = Rx<List<CountryModel>>([]);

  RxString popularLyricsError = RxString('');
  RxString topLyricsError = RxString('');
  RxString latestLyricsError = RxString('');
  RxString translationsLyricsError = RxString('');
  RxString topArtistsError = RxString('');
  RxString allCountriesError = RxString('');
  RxString allGenresError = RxString('');

  @override
  void onInit() {
    super.onInit();
    _lyricsService = locator.get<LyricsService>();
    _artistsService = locator.get<ArtistsService>();
    loadAll();
  }

  loadAll() {
    loadPopularLyrics();
    loadLatestLyrics();
    loadTranslationsLyrics();
    loadTopArtists();
    loadAllGenres();
    loadTopLyrics();
    loadAllCountries();
  }

  loadAllCountries() async {
    try {
      allCountries.value = await _lyricsService.fetchAllCountries();
    } catch (e) {
      this.allCountriesError.value = extractMessage(e);
      print(e);
    }
  }

  loadTopLyrics() async {
    try {
      topLyrics.value = await _lyricsService.fetchTopLyrics();
    } catch (e) {
      this.topLyricsError.value = extractMessage(e);
      print(e);
    }
  }

  loadPopularLyrics() async {
    try {
      popularLyrics.value = await _lyricsService.fetchPopularLyrics();
    } catch (e) {
      this.popularLyricsError.value = extractMessage(e);
      print(e);
    }
  }

  loadLatestLyrics() async {
    try {
      latestLyrics.value = await _lyricsService.fetchLatestLyrics();
    } catch (e) {
      this.latestLyricsError.value = extractMessage(e);
      print(e);
    }
  }

  loadTranslationsLyrics() async {
    try {
      translationsLyrics.value = await _lyricsService.fetchTranslationsLyrics();
    } catch (e) {
      print(e);
      this.translationsLyricsError.value = extractMessage(e);
    }
  }

  loadTopArtists() async {
    try {
      topArtists.value = await _artistsService.fetchTopArtists();
    } catch (e) {
      print(e);
      this.topArtistsError.value = extractMessage(e);
    }
  }

  loadAllGenres() async {
    try {
      allGenres.value = await _lyricsService.fetchGenresLyrics();
    } catch (e) {
      print(e);
      this.allGenresError.value = extractMessage(e);
    }
  }
}
