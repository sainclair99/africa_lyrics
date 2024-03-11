import 'package:afrikalyrics_mobile/api/al_api.dart';
import 'package:afrikalyrics_mobile/services/artists_service.dart';
import 'package:afrikalyrics_mobile/services/lyrics_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:get_it/get_it.dart';

import 'player/services/local_artists_service.dart';
import 'player/services/local_songs_service.dart';

var locator = GetIt.instance;

setupLocator() {
  locator.registerLazySingleton<Connectivity>(() => Connectivity());
  locator.registerLazySingleton<ALApi>(() => ALApi());
  locator.registerLazySingleton<LyricsService>(() => LyricsService());
  locator.registerLazySingleton<ArtistsService>(() => ArtistsService());
  locator.registerLazySingleton<LocalSongsService>(() => LocalSongsService());
  locator
      .registerLazySingleton<LocalArtistsService>(() => LocalArtistsService());
}
