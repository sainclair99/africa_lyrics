import 'package:afrikalyrics_mobile/player/models/LocalAlbum.dart';
import 'package:afrikalyrics_mobile/player/models/LocalArtist.dart';
import 'package:on_audio_query/on_audio_query.dart';

class LocalArtistsService {
  OnAudioQuery? audioQuery;
  LocalArtistsService() {
    this.audioQuery = OnAudioQuery();
  }

  Future<List<LocalArtist>> getLocalArtists() async {
    var artists = await audioQuery?.queryArtists();
    return artists!.map((e) => LocalArtist.fromAudioQuery(e)).toList();
  }

  Future<List<LocalAlbum>> getLocalAlbums() async {
    var albums = await audioQuery?.queryAlbums();
    List<LocalAlbum> listData = [];
    listData = albums!.map((e) => LocalAlbum.fromAudioQuery(e)).toList();
    return listData;
  }
}
