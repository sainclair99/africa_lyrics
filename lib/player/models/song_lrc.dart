import 'package:hive/hive.dart';

part 'song_lrc.g.dart';

@HiveType(typeId: 1)
class SongLrc {
  @HiveField(0)
  final String? localSongId;

  @HiveField(1)
  final String? alMediaId;

  @HiveField(2)
  final String? localPath;

  SongLrc({this.localSongId, this.alMediaId, this.localPath});
}
