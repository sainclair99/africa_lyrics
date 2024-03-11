// To parse this JSON data, do
//
//     final artistModel = artistModelFromJson(jsonString);

import 'dart:convert';

import 'package:afrikalyrics_mobile/models/country_model.dart';
import 'package:afrikalyrics_mobile/models/lyric_model.dart';

ArtistModel artistModelFromJson(String str) =>
    ArtistModel.fromJson(json.decode(str));

String artistModelToJson(ArtistModel data) => json.encode(data.toJson());
// ! added null safety behaviors
class ArtistModel {
  ArtistModel({
    this.idArtiste,
    this.pays,
    this.nom,
    this.nomBis,
    this.tag,
    this.facebook,
    this.twitter,
    this.chaineYoutube,
    this.instagram,
    this.siteWeb,
    this.image,
    this.thumb,
    this.biographie,
    this.biographieEn,
    this.nbreVueArtiste,
    this.dateCreation,
    this.lyrics,
    this.country,
    this.classement,
  });

  int? idArtiste;
  int? pays;
  String? nom;
  String? nomBis;
  String? tag;
  String? facebook;
  String? twitter;
  String? chaineYoutube;
  String? instagram;
  String? siteWeb;
  String? image;
  String? thumb;
  String? biographie;
  String? biographieEn;
  int? nbreVueArtiste;
  DateTime? dateCreation;
  List<LyricModel>? lyrics;
  CountryModel? country;
  int? classement;

  ArtistModel copyWith({
    int? idArtiste,
    int? pays,
    String? nom,
    String? nomBis,
    String? tag,
    String? facebook,
    String? twitter,
    String? chaineYoutube,
    String? instagram,
    String? siteWeb,
    String? image,
    String? thumb,
    String? biographie,
    String? biographieEn,
    int? nbreVueArtiste,
    DateTime? dateCreation,
    List<LyricModel>? lyrics,
    CountryModel? country,
    int? classement,
  }) =>
      ArtistModel(
        idArtiste: idArtiste ?? this.idArtiste,
        pays: pays ?? this.pays,
        nom: nom ?? this.nom,
        nomBis: nomBis ?? this.nomBis,
        tag: tag ?? this.tag,
        facebook: facebook ?? this.facebook,
        twitter: twitter ?? this.twitter,
        chaineYoutube: chaineYoutube ?? this.chaineYoutube,
        instagram: instagram ?? this.instagram,
        siteWeb: siteWeb ?? this.siteWeb,
        image: image ?? this.image,
        thumb: thumb ?? this.thumb,
        biographie: biographie ?? this.biographie,
        biographieEn: biographieEn ?? this.biographieEn,
        nbreVueArtiste: nbreVueArtiste ?? this.nbreVueArtiste,
        dateCreation: dateCreation ?? this.dateCreation,
        lyrics: lyrics ?? this.lyrics,
        country: country ?? this.country,
        classement: classement ?? this.classement,
      );

  factory ArtistModel.fromJson(Map<String, dynamic> json) => ArtistModel(
        idArtiste: json["id_artiste"] == null ? null : json["id_artiste"],
        pays: json["pays"] == null ? null : json["pays"],
        nom: json["nom"] == null ? null : json["nom"],
        nomBis: json["nom_bis"] == null ? null : json["nom_bis"],
        tag: json["tag"] == null ? null : json["tag"],
        facebook: json["facebook"] == null ? null : json["facebook"],
        twitter: json["twitter"] == null ? null : json["twitter"],
        chaineYoutube:
            json["chaine_youtube"] == null ? null : json["chaine_youtube"],
        instagram: json["instagram"] == null ? null : json["instagram"],
        siteWeb: json["site_web"] == null ? null : json["site_web"],
        image: json["image"] == null ? null : json["image"],
        thumb: json["thumb"] == null ? null : json["thumb"],
        biographie: json["biographie"] == null ? null : json["biographie"],
        biographieEn:
            json["biographie_en"] == null ? null : json["biographie_en"],
        nbreVueArtiste:
            json["nbre_vue_artiste"] == null ? null : json["nbre_vue_artiste"],
        dateCreation: json["date_creation"] == null
            ? null
            : DateTime.parse(json["date_creation"]),
        lyrics: json["lyrics"] == null
            ? null
            : List<LyricModel>.from(
                json["lyrics"].map((x) => LyricModel.fromJson(x))),
        country: json["country"] == null
            ? null
            : CountryModel.fromJson(json["country"]),
        classement: json["classement"] == null ? null : json["classement"],
      );

  Map<String, dynamic> toJson() => {
        "id_artiste": idArtiste == null ? null : idArtiste,
        "pays": pays == null ? null : pays,
        "nom": nom == null ? null : nom,
        "nom_bis": nomBis == null ? null : nomBis,
        "tag": tag == null ? null : tag,
        "facebook": facebook == null ? null : facebook,
        "twitter": twitter == null ? null : twitter,
        "chaine_youtube": chaineYoutube == null ? null : chaineYoutube,
        "instagram": instagram == null ? null : instagram,
        "site_web": siteWeb == null ? null : siteWeb,
        "image": image == null ? null : image,
        "thumb": thumb == null ? null : thumb,
        "biographie": biographie == null ? null : biographie,
        "biographie_en": biographieEn == null ? null : biographieEn,
        "nbre_vue_artiste": nbreVueArtiste == null ? null : nbreVueArtiste,
        "date_creation": dateCreation == null
            ? null
            : "${dateCreation!.year.toString().padLeft(4, '0')}-${dateCreation!.month.toString().padLeft(2, '0')}-${dateCreation!.day.toString().padLeft(2, '0')}",
        "lyrics": lyrics == null
            ? null
            : List<dynamic>.from(lyrics!.map((x) => x.toJson())),
        "country": country == null ? null : country!.toJson(),
      };
}
