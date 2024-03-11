import 'dart:convert';
import 'dart:typed_data';
import 'package:on_audio_query/on_audio_query.dart';

class LocalSong {
  final String? songId;
  final String? songTitle;
  final String? artistName;
  final String? albumTitle;
  final String? uri;
  final String? duration;
  final String? filePath;
  Uint8List? cover;
  String? coverUrl;

  LocalSong({
    this.uri,
    this.songId,
    this.songTitle,
    this.artistName,
    this.albumTitle,
    this.duration,
    this.filePath,
    this.cover,
    this.coverUrl,
  });

  Duration get duree {
    int dur = int.parse("$duration");
    return Duration(milliseconds: dur);
  }

  factory LocalSong.fromAudioQuery(SongModel song) {
    return LocalSong(
      songId: song.id as String,
      uri: song.uri,
      songTitle: song.title,
      albumTitle: song.album ?? "",
      artistName: song.artist ?? '',
      duration: song.duration as String,
      // filePath: song.filePath,
      // coverUrl: song.albumArtwork,
    );
  }
}
