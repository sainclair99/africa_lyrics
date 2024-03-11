import 'package:afrikalyrics_mobile/models/lyric_model.dart';

class GenreModel {
  // ! added null safety behaviors
  GenreModel({
    this.idCategorie,
    this.titre,
    this.titreEn,
    this.titreBis,
    this.description,
    this.descriptionEn,
    this.lyrics,
  });

  int? idCategorie;
  String? titre;
  String? titreEn;
  String? titreBis;
  String? description;
  String? descriptionEn;
  List<LyricModel>? lyrics;

  GenreModel copyWith({
    int? idCategorie,
    String? titre,
    String? titreEn,
    String? titreBis,
    String? description,
    String? descriptionEn,
    List<LyricModel>? lyrics,
  }) =>
      GenreModel(
        idCategorie: idCategorie ?? this.idCategorie,
        titre: titre ?? this.titre,
        titreEn: titreEn ?? this.titreEn,
        titreBis: titreBis ?? this.titreBis,
        description: description ?? this.description,
        descriptionEn: descriptionEn ?? this.descriptionEn,
        lyrics: lyrics ?? this.lyrics,
      );

  factory GenreModel.fromJson(Map<String, dynamic> json) => GenreModel(
        idCategorie: json["id_categorie"] == null ? null : json["id_categorie"],
        titre: json["titre"] == null ? null : json["titre"],
        titreEn: json["titre_en"] == null ? null : json["titre_en"],
        titreBis: json["titre_bis"] == null ? null : json["titre_bis"],
        description: json["description"] == null ? null : json["description"],
        descriptionEn:
            json["description_en"] == null ? null : json["description_en"],
        lyrics: json["lyrics"] == null
            ? []
            : List<LyricModel>.from(
                json["lyrics"].map((json) => LyricModel.fromJson(json)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "id_categorie": idCategorie == null ? null : idCategorie,
        "titre": titre == null ? null : titre,
        "titre_en": titreEn == null ? null : titreEn,
        "titre_bis": titreBis == null ? null : titreBis,
        "description": description == null ? null : description,
        "description_en": descriptionEn == null ? null : descriptionEn,
      };
}
