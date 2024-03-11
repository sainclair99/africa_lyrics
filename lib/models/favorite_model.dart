import 'package:hive/hive.dart';
part 'favorite_model.g.dart';

// ! added null safety behaviors
@HiveType(typeId: 2)
class FavoriteModel {
  FavoriteModel({this.idLyric, this.titre, this.artiste, this.cover});
  @HiveField(0)
  int? idLyric;
  @HiveField(1)
  String? titre;
  @HiveField(2)
  String? artiste;

  @HiveField(3)
  String? cover;
}
