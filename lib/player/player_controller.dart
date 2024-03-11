import 'dart:io';

import 'package:afrikalyrics_mobile/misc/alert_utils.dart';
import 'package:afrikalyrics_mobile/player/models/LocalAlbum.dart';
import 'package:afrikalyrics_mobile/player/models/LocalArtist.dart';
import 'package:afrikalyrics_mobile/player/models/LocalSong.dart';
import 'package:afrikalyrics_mobile/player/models/LrcModel.dart';
import 'package:afrikalyrics_mobile/player/models/song_lrc.dart';
import 'package:afrikalyrics_mobile/player/services/local_artists_service.dart';
import 'package:afrikalyrics_mobile/services/lyrics_service.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../service_locator.dart';
import 'services/local_songs_service.dart';

class PlayerController extends GetxController {
  Rx<LocalSong> playing = Rx<LocalSong>(new LocalSong());
  Rx<Duration> currentPosition = Rx<Duration>(new Duration());
  Rx<LoopMode> currentLoopMode = Rx<LoopMode>(LoopMode.none);
  Rx<List<LocalSong>> songs = Rx<List<LocalSong>>([]);
  Rx<List<LocalArtist>> artists = Rx<List<LocalArtist>>([]);
  Rx<List<LocalAlbum>> albums = Rx<List<LocalAlbum>>([]);
  Rx<List<LocalSong>> playList = Rx<List<LocalSong>>([]);
  Rx<LocalArtist> currentArtist = Rx<LocalArtist>(new LocalArtist());
  Rx<List<LocalSong>> currentArtistSongs = Rx<List<LocalSong>>([]);
  Rx<LocalAlbum> currentAlbum = Rx<LocalAlbum>(new LocalAlbum());
  Rx<List<LocalSong>> currentAlbumSongs = Rx<List<LocalSong>>([]);
  RxBool isPlaying = RxBool(false);
  RxBool isShuffle = RxBool(false);
  static PlayerController get to => Get.find();
  final assetsAudioPlayer = AssetsAudioPlayer();
  LyricsService? _lyricsService;

  // Main method.
  final OnAudioQuery _audioQuery = OnAudioQuery();

  // Indicate if application has permission to the library.
  bool _hasPermission = false;

  @override
  void onInit() {
    super.onInit();

    init();
  }

  init({bool retry = false}) async {

    // Check and request for permission.
    // The param 'retryRequest' is false, by default.
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );

    // Only call update the UI if application has all required permissions.
    // _hasPermission ? setState(() {}) : null;

    if(_hasPermission){
      isPlaying.bindStream(assetsAudioPlayer.isPlaying);
      isShuffle.bindStream(assetsAudioPlayer.isShuffling);
      currentPosition.bindStream(assetsAudioPlayer.currentPosition);
      currentLoopMode.bindStream(assetsAudioPlayer.loopMode);
      assetsAudioPlayer.current.listen((event) {
        if (event != null && playList.value != null) {
          print(event);
          playing.value = playList.value
              .where((song) => event.audio.assetAudioPath == song.uri)
              .toList()
              .first;
        }
      });

      playing.stream.listen((value) {
        print(value);
        if (value?.songTitle != null) {
          isCurrentLrcReady.value = false;
          isCurrentHasLrc.value = false;
          currentLrcString.value = "";

          this.fetchCurrrentSongLrc(
            artist: value.artistName,
            title: value.songTitle,
          );
        }
      });

      loadAllSongs();
      loadAllArtists();
      loadAllAlbums();

      _lyricsService = locator.get<LyricsService>();
    }
  }

  loadArtistSongs(LocalArtist artist) async {
    currentArtist.value = artist;
    currentArtistSongs = Rx<List<LocalSong>>([]);
    var results = await locator
        .get<LocalSongsService>()
        .getLocalSongsByArtist(artist.artistId!);
    try {
      results = await this.getArtWorks(results);
    } catch (e) {
      print(e);
    } finally {
      currentArtistSongs.value = results;
    }
  }

  Future<List<LocalSong>> getArtWorks(List<LocalSong> results) async {
    try {
      for (var i = 0; i < results.length; i++) {
        results[i].cover = await _audioQuery.queryArtwork(
          int.parse('${results[i].songId}'),
          ArtworkType.AUDIO,
        );
      }
    } catch (e, s) {}

    return results;
  }

  loadAlbumSongs(LocalAlbum album) async {
    currentAlbum.value = album;
    currentAlbumSongs = Rx<List<LocalSong>>([]);
    try {
      var results = await locator
          .get<LocalSongsService>()
          .getLocalSongsByAlbum('${album.albumId}');
      try {
        results = await this.getArtWorks(results);
      } catch (e) {}

      currentAlbumSongs.value = results;
      print(currentAlbumSongs.value);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Loading All song error",
        printDetails: true,
      );
      print(e);
    }
  }

  seekTo(Duration duration) {
    assetsAudioPlayer.seek(duration);
  }

  toggleShuffle() {
    assetsAudioPlayer.toggleShuffle();
  }

  setLoopMode(LoopMode mode) {
    assetsAudioPlayer.setLoopMode(mode);
  }

  playCurrentArtistSong() async {
    if (currentArtist != null) {
      await this.stop();
      await openSongs(currentArtistSongs.value);
      // assetsAudioPlayer.play();
    }
  }

  loadAllArtists() async {
    try {
      var results = await locator.get<LocalArtistsService>().getLocalArtists();
      artists.value = results;
      try {
        for (var i = 0; i < results.length; i++) {
          try {
            results[i].cover = await _audioQuery.queryArtwork(
              int.parse('${results[i].artistId}'),
              ArtworkType.ARTIST,
            );
          } catch (e) {
            print(e);
          }
        }
        artists.value = results;
      } catch (e) {}
    } catch (e) {
      print(e);
    }
  }

  loadAllAlbums() async {
    try {
      var results = await locator.get<LocalArtistsService>().getLocalAlbums();
      albums.value = results;
      try {
        for (var i = 0; i < results.length; i++) {
          results[i].cover = await _audioQuery.queryArtwork(
            int.parse('${results[i].albumId}'),
            ArtworkType.ALBUM,
          );
        }
      } catch (e) {
        print(e);
      }
      albums.value = results;
    } catch (e) {
      print(e);
    }
  }

  loadAllSongs() async {
    var results;
    try {
      results = await locator.get<LocalSongsService>().getLocalSongs();

      songs.value = results;
      results = await this.getArtWorks(results);

      // await openSongs(results);
      // await assetsAudioPlayer.stop();
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: "Loading All song error",
        printDetails: true,
      );
      songs.value = results;
      print(e);
    } finally {
      songs.value = results;
    }
  }

  openSongs(List<LocalSong> songs) async {
    await assetsAudioPlayer.open(
      Playlist(
        audios: songs
            .map(
              (song) => Audio.file(
                '${song.uri}',
                metas: Metas(
                  title: song.songTitle,
                  artist: song.artistName,
                  album: song.albumTitle,
                  image: song.coverUrl != null
                      ? MetasImage.file('${song.coverUrl}')
                      : MetasImage.asset(
                          song.coverUrl ?? "assets/images/logo-circle.jpg",
                        ), //can be MetasImage.network
                  onImageLoadFail: MetasImage.asset(
                    "assets/images/logo-circle.jpg",
                  ),
                ),
              ),
            )
            .toList(),
      ),
      loopMode: LoopMode.playlist, //loop the full playlist,
      showNotification: true,
    );
    playList.value = songs;
    return songs;
  }

  playNext() {
    assetsAudioPlayer.next();
  }

  stop() {
    assetsAudioPlayer.stop();
  }

  playPrevious() {
    assetsAudioPlayer.previous();
  }

  pause() async {
    await assetsAudioPlayer.pause();
  }

  play({LocalSong? song, List<LocalSong>? listSong}) async {
    if (listSong != null && playList.value != listSong) {
      await openSongs(listSong);
    }
    if (song == null) {
      assetsAudioPlayer.playOrPause();
    } else {
      await assetsAudioPlayer.stop();

      this.playing.value = song;
      int index = playList.value.indexOf(song);
      assetsAudioPlayer.playlistPlayAtIndex(index);
    }
  }

  // LRC feature

  RxBool isCurrentLrcReady = false.obs;
  RxBool isSearchingLrc = false.obs;
  RxString currentLrcString = "".obs;
  RxString currentLyricString = "".obs;
  RxBool isCurrentHasLrc = false.obs;

  fetchCurrrentSongLrc({
    String? artist,
    String? title,
  }) async {
    var localCorrespondance = searchLocalLrc('${playing.value.songId}');
    isCurrentHasLrc.value = false;
    isCurrentLrcReady.value = false;
    currentLrcString.value = '';
    try {
      if (localCorrespondance != null) {
        print(localCorrespondance);
        this.setCurrentLrc(
          local: true,
          localPath: localCorrespondance.localPath,
        );
      } else {
        if(_lyricsService != null){
          List<LrcModel> results = await _lyricsService!.searchLrc(
            artist: artist,
            title: title,
          );
          print(results);
          if (results.length == 1) {
            this.setCurrentLrc(lrc: results.first);
          } else {
            isCurrentLrcReady.value = true;
          }
        }

      }
    } catch (e) {
      print(e);
    }
  }

  setCurrentLrc({LrcModel? lrc, bool local = false, String? localPath}) async {
    try {
      if (local == false) {
        var lrcString =
            await this.fetchFile('${lrc?.translations?.first.lrcUrl}');
        currentLrcString.value = lrcString;
        isCurrentLrcReady.value = true;
        isCurrentHasLrc.value = true;
        print(lrcString);
      } else {
        var file = new File('${localPath}');
        currentLrcString.value = await file.readAsString();
        isCurrentLrcReady.value = true;
        isCurrentHasLrc.value = true;
        return true;
      }
    } catch (e) {
      print(e);
      showError("Invalid File");
    }
  }

  SongLrc searchLocalLrc(String songId) {
    final songLrcBox = Hive.box<SongLrc>('songlrcs');
    var allLrcsMap = songLrcBox
        .valuesBetween(startKey: 0, endKey: songLrcBox.length)
        .toList();

    return allLrcsMap.firstWhere(
      (s) => s.localSongId == songId && s.localPath != null,
      orElse: () => new SongLrc(),
    );
  }

  void addLocalLrc(
      {required String localSongId, required String localPath, String? alId}) {
    final songLrcBox = Hive.box('songlrcs');
    SongLrc s = new SongLrc(
      localSongId: localSongId,
      localPath: localPath,
      alMediaId: '$alId',
    );
    songLrcBox.add(s);
  }

  fetchFile(String fileName, {bool local = false}) {
    if (local) {
    } else {
      return _lyricsService?.getFile(fileName);
    }
  }
}

enum HasLyricState { FOUND, NOT_FOUND }
