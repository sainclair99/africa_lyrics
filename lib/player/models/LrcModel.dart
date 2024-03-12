// To parse this JSON data, do
//
//     final lrcModel = lrcModelFromJson(jsonString);

import 'dart:convert';

LrcModel lrcModelFromJson(String str) => LrcModel.fromJson(json.decode(str));

String lrcModelToJson(LrcModel data) => json.encode(data.toJson());

class LrcModel {
  LrcModel({
    required this.id,
    this.title,
    this.artistName,
    this.createdAt,
    this.updatedAt,
    this.translations,
  });

  int id;
  String? title;
  String? artistName;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Translation>? translations;

  LrcModel copyWith({
    int? id,
    String? title,
    String? artistName,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Translation>? translations,
  }) =>
      LrcModel(
        id: id ?? this.id,
        title: title ?? this.title,
        artistName: artistName ?? this.artistName,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        translations: translations ?? this.translations,
      );

  factory LrcModel.fromJson(Map<String, dynamic> json) => LrcModel(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        artistName: json["artist_name"] == null ? null : json["artist_name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        translations: json["translations"] == null
            ? null
            : List<Translation>.from(
                json["translations"].map((x) => Translation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "artist_name": artistName == null ? null : artistName,
        "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "translations": translations == null
            ? null
            : List<dynamic>.from(translations!.map((x) => x.toJson())),
      };
}

class Translation {
  Translation({
    this.id,
    this.lyricUrl,
    this.lrcUrl,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.lang,
  });

  int? id;
  String? lyricUrl;
  String? lrcUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;
  Lang? lang;

  Translation copyWith({
    int? id,
    String? lyricUrl,
    String? lrcUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
    Lang? lang,
  }) =>
      Translation(
        id: id ?? this.id,
        lyricUrl: lyricUrl ?? this.lyricUrl,
        lrcUrl: lrcUrl ?? this.lrcUrl,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        user: user ?? this.user,
        lang: lang ?? this.lang,
      );

  factory Translation.fromJson(Map<String, dynamic> json) => Translation(
        id: json["id"] == null ? null : json["id"],
        lyricUrl: json["lyric_url"] == null ? null : json["lyric_url"],
        lrcUrl: json["lrc_url"] == null ? null : json["lrc_url"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        lang: json["lang"] == null ? null : Lang.fromJson(json["lang"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "lyric_url": lyricUrl == null ? null : lyricUrl,
        "lrc_url": lrcUrl == null ? null : lrcUrl,
        "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "user": user == null ? null : user?.toJson(),
        "lang": lang == null ? null : lang?.toJson(),
      };
}

class Lang {
  Lang({
    this.id,
    this.code,
    this.longName,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? code;
  String? longName;
  dynamic createdAt;
  dynamic updatedAt;

  Lang copyWith({
    int? id,
    String? code,
    String? longName,
    dynamic createdAt,
    dynamic updatedAt,
  }) =>
      Lang(
        id: id ?? this.id,
        code: code ?? this.code,
        longName: longName ?? this.longName,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Lang.fromJson(Map<String, dynamic> json) => Lang(
        id: json["id"] == null ? null : json["id"],
        code: json["code"] == null ? null : json["code"],
        longName: json["long_name"] == null ? null : json["long_name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "code": code == null ? null : code,
        "long_name": longName == null ? null : longName,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class User {
  User({
    this.idUtilisateur,
    this.nom,
    this.pseudo,
    this.email,
    this.valide,
    this.dateInscription,
    this.emailVerifiedAt,
    this.updatedAt,
    this.dateModification,
  });

  int? idUtilisateur;
  String? nom;
  String? pseudo;
  String? email;
  int? valide;
  DateTime? dateInscription;
  dynamic emailVerifiedAt;
  DateTime? updatedAt;
  DateTime? dateModification;

  User copyWith({
    int? idUtilisateur,
    String? nom,
    String? pseudo,
    String? email,
    int? valide,
    DateTime? dateInscription,
    dynamic emailVerifiedAt,
    DateTime? updatedAt,
    DateTime? dateModification,
  }) =>
      User(
        idUtilisateur: idUtilisateur ?? this.idUtilisateur,
        nom: nom ?? this.nom,
        pseudo: pseudo ?? this.pseudo,
        email: email ?? this.email,
        valide: valide ?? this.valide,
        dateInscription: dateInscription ?? this.dateInscription,
        emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        updatedAt: updatedAt ?? this.updatedAt,
        dateModification: dateModification ?? this.dateModification,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        idUtilisateur:
            json["id_utilisateur"] == null ? null : json["id_utilisateur"],
        nom: json["nom"] == null ? null : json["nom"],
        pseudo: json["pseudo"] == null ? null : json["pseudo"],
        email: json["email"] == null ? null : json["email"],
        valide: json["valide"] == null ? null : json["valide"],
        dateInscription: json["date_inscription"] == null
            ? null
            : DateTime.parse(json["date_inscription"]),
        emailVerifiedAt: json["email_verified_at"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        dateModification: json["date_modification"] == null
            ? null
            : DateTime.parse(json["date_modification"]),
      );

  Map<String, dynamic> toJson() => {
        "id_utilisateur": idUtilisateur == null ? null : idUtilisateur,
        "nom": nom == null ? null : nom,
        "pseudo": pseudo == null ? null : pseudo,
        "email": email == null ? null : email,
        "valide": valide == null ? null : valide,
        "date_inscription": dateInscription == null
            ? null
            : "${dateInscription?.year.toString().padLeft(4, '0')}-${dateInscription?.month.toString().padLeft(2, '0')}-${dateInscription?.day.toString().padLeft(2, '0')}",
        "email_verified_at": emailVerifiedAt,
        "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "date_modification": dateModification == null
            ? null
            : dateModification?.toIso8601String(),
      };
}
