class CountryModel {
  // ! added null safety behaviors
  CountryModel({
    this.idPays,
    this.nomPays,
    this.nomPaysEn,
    this.nomPaysBis,
    this.description,
    this.descriptionEn,
    this.drapeau,
    this.dateCreation,
  });

  int? idPays;
  String? nomPays;
  String? nomPaysEn;
  String? nomPaysBis;
  String? description;
  String? descriptionEn;
  String? drapeau;
  DateTime? dateCreation;

  CountryModel copyWith({
    int? idPays,
    String? nomPays,
    String? nomPaysEn,
    String? nomPaysBis,
    String? description,
    String? descriptionEn,
    String? drapeau,
    DateTime? dateCreation,
  }) =>
      CountryModel(
        idPays: idPays ?? this.idPays,
        nomPays: nomPays ?? this.nomPays,
        nomPaysEn: nomPaysEn ?? this.nomPaysEn,
        nomPaysBis: nomPaysBis ?? this.nomPaysBis,
        description: description ?? this.description,
        descriptionEn: descriptionEn ?? this.descriptionEn,
        drapeau: drapeau ?? this.drapeau,
        dateCreation: dateCreation ?? this.dateCreation,
      );

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        idPays: json["id_pays"] == null ? null : json["id_pays"],
        nomPays: json["nom_pays"] == null ? null : json["nom_pays"],
        nomPaysEn: json["nom_pays_en"] == null ? null : json["nom_pays_en"],
        nomPaysBis: json["nom_pays_bis"] == null ? null : json["nom_pays_bis"],
        description: json["description"] == null ? null : json["description"],
        descriptionEn:
            json["description_en"] == null ? null : json["description_en"],
        drapeau: json["drapeau"] == null ? null : json["drapeau"],
        dateCreation: json["date_creation"] == null
            ? null
            : DateTime.parse(json["date_creation"]),
      );

  Map<String, dynamic> toJson() => {
        "id_pays": idPays == null ? null : idPays,
        "nom_pays": nomPays == null ? null : nomPays,
        "nom_pays_en": nomPaysEn == null ? null : nomPaysEn,
        "nom_pays_bis": nomPaysBis == null ? null : nomPaysBis,
        "description": description == null ? null : description,
        "description_en": descriptionEn == null ? null : descriptionEn,
        "drapeau": drapeau == null ? null : drapeau,
        "date_creation": dateCreation == null
            ? null
            : "${dateCreation!.year.toString().padLeft(4, '0')}-${dateCreation!.month.toString().padLeft(2, '0')}-${dateCreation!.day.toString().padLeft(2, '0')}",
      };
}
