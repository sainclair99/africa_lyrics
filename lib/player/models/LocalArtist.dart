import 'dart:typed_data';

import 'package:on_audio_query/on_audio_query.dart';

class LocalArtist {
  final String? name;
  final String? artistId;
  Uint8List? cover;
  final String? coverUrl;
  final int? songCount;
  LocalArtist({
    this.name,
    this.artistId,
    this.cover,
    this.songCount,
    this.coverUrl,
  });

  factory LocalArtist.fromAudioQuery(ArtistModel artist) {
    return LocalArtist(
      artistId: artist.id as String,
      name: artist.artist,
      songCount: artist.numberOfTracks ?? 0,
      // coverUrl: artist.artistArtPath,
    );
  }
}
