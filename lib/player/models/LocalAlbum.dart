import 'dart:typed_data';

import 'package:on_audio_query/on_audio_query.dart';

class LocalAlbum {
  final int? albumId;
  final String? name;
  Uint8List? cover;
  int? songCount;
  final String? coverUrl;
  LocalAlbum({
    this.albumId,
    this.name,
    this.cover,
    this.songCount,
    this.coverUrl,
  });
  factory LocalAlbum.fromAudioQuery(AlbumModel album) {
    return LocalAlbum(
      albumId: album.id,
      name: album.album,
      songCount: album.numOfSongs,
      // coverUrl: album.albumArt,
    );
  }
}
