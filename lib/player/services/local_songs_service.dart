import 'package:on_audio_query/on_audio_query.dart';
import '../models/LocalSong.dart';

class LocalSongsService {
  OnAudioQuery? audioQuery;
  LocalSongsService() {
    audioQuery = OnAudioQuery();
  }

  bool isValidMusic(SongModel song) {
    if (song.duration != null) {
      return !song.isAlarm! &&
          !song.isNotification! &&
          !song.isRingtone! &&
          Duration(milliseconds: song.duration ?? 0).inSeconds >=
              50;
    }
    return !song.isAlarm! && !song.isNotification! && !song.isRingtone!;
  }

  // Future<List<LocalSong>> getLocalSongs() async {
  //   List<SongModel> songs =
  //       await audioQuery.getSongs(sortType: SongSortType.CURRENT_IDs_ORDER);
  //   List<LocalSong> listData = [];
  //   songs.sort((a, b) => b.id.compareTo(a.id));
  //   songs = songs.where(isValidMusic).toList();
  //   listData = songs.map((e) => LocalSong.fromAudioQuery(e)).toList();

  //   return listData;
  // }

  Future<List<LocalSong>> getLocalSongs() async {
    List<SongModel> songs =
        await audioQuery!.querySongs(sortType: SongSortType.DATE_ADDED);
    List<LocalSong> listData = [];
    songs.sort((a, b) => b.id.compareTo(a.id));
    songs = songs.where(isValidMusic).toList();
    listData = songs.map((e) => LocalSong.fromAudioQuery(e)).toList();

    return listData;
  }

  // Future<List<LocalSong>> getLocalSongsByArtist(String artistId) async {
  //   var songs = await audioQuery.getSongsFromArtist(artistId: artistId);
  //   List<LocalSong> listData = [];
  //   songs = songs.where(isValidMusic).toList();
  //   listData = songs.map((e) => LocalSong.fromAudioQuery(e)).toList();

  //   return listData;
  // }
  Future<List<LocalSong>> getLocalSongsByArtist(String artistId) async {
    var songs = await audioQuery!.queryAudiosFrom(AudiosFromType.ARTIST_ID,artistId);
    List<LocalSong> listData = [];
    songs = songs.where(isValidMusic).toList();
    listData = songs.map((e) => LocalSong.fromAudioQuery(e)).toList();

    return listData;
  }

  Future<List<LocalSong>> getLocalSongsByAlbum(String albumId) async {
    var songs = await audioQuery!.queryAudiosFrom(AudiosFromType.ALBUM_ID,albumId);
    List<LocalSong> listData = [];
    songs = songs.where(isValidMusic).toList();
    listData = songs.map((e) => LocalSong.fromAudioQuery(e)).toList();

    return listData;
  }
}
