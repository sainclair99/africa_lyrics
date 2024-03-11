// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_lrc.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongLrcAdapter extends TypeAdapter<SongLrc> {
  @override
  SongLrc read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongLrc(
      localSongId: fields[0] as String,
      alMediaId: fields[1] as String,
      localPath: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SongLrc obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.localSongId)
      ..writeByte(1)
      ..write(obj.alMediaId)
      ..writeByte(2)
      ..write(obj.localPath);
  }

  @override
  int get typeId => 1;
}
