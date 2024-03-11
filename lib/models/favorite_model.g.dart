// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteModelAdapter extends TypeAdapter<FavoriteModel> {
  @override
  FavoriteModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteModel(
      idLyric: fields[0] as int,
      titre: fields[1] as String,
      artiste: fields[2] as String,
      cover: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.idLyric)
      ..writeByte(1)
      ..write(obj.titre)
      ..writeByte(2)
      ..write(obj.artiste)
      ..writeByte(3)
      ..write(obj.cover);
  }

  @override
  int get typeId => 2;
}
