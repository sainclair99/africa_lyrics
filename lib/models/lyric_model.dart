import 'package:afrikalyrics_mobile/models/genre_model.dart';
import 'package:slugify/slugify.dart';

import 'artist_model.dart';

class LyricModel {
  // ! added null safety behaviors
  LyricModel({
    this.idLyric,
    this.langue,
    this.langue2,
    this.titre,
    this.titreBis,
    this.artiste,
    this.featuring,
    this.artiste3,
    this.artiste4,
    this.paroles,
    this.traductionParoles,
    this.traductionParolesEn,
    this.description,
    this.descriptionEn,
    this.titreTraduction,
    this.titreTraductionEn,
    this.rubrique,
    this.rubrique2,
    this.nbreVue,
    this.nbreVueTraduction,
    this.image,
    this.thumnail,
    this.anneeSortie,
    this.typeAlbum,
    this.album,
    this.albumPrincipal,
    this.tag,
    this.youtube,
    this.droitAuteur,
    this.missing,
    this.traduction,
    this.nomProposant,
    this.urlProposant,
    this.urlProposantTraduction,
    this.proposantTraduction,
    this.dateCreation,
    this.dateCreationTraduction,
    this.dateMiseJour,
    this.album2,
    this.author,
    this.featArtists,
    this.comments,
    this.llangue,
    this.llangue2,
    this.genre,
    this.category2,
  });

  String get url {
    return "https://afrikalyrics.com/${slugify(author!.nom! + " " + titre!)}-lyrics";
  }

  int? idLyric;
  int? langue;
  int? langue2;
  String? titre;
  String? titreBis;
  int? artiste;
  int? featuring;
  int? artiste3;
  int? artiste4;
  String? paroles;
  String? traductionParoles;
  String? traductionParolesEn;
  String? description;
  String? descriptionEn;
  String? titreTraduction;
  String? titreTraductionEn;
  int? rubrique;
  int? rubrique2;
  int? nbreVue;
  int? nbreVueTraduction;
  String? image;
  String? thumnail;
  int? anneeSortie;
  TypeAlbum? typeAlbum;
  String? album;
  int? albumPrincipal;
  String? tag;
  String? youtube;
  String? droitAuteur;
  String? missing;
  String? traduction;
  String? nomProposant;
  String? urlProposant;
  String? urlProposantTraduction;
  String? proposantTraduction;
  DateTime? dateCreation;
  String? dateCreationTraduction;
  String? dateMiseJour;
  dynamic album2;
  ArtistModel? author;
  List<ArtistModel>? featArtists;
  List<dynamic>? comments;
  Llangue? llangue;
  dynamic llangue2;
  GenreModel? genre;
  GenreModel? category2;

  LyricModel copyWith({
    int? idLyric,
    int? langue,
    int? langue2,
    String? titre,
    String? titreBis,
    int? artiste,
    int? featuring,
    int? artiste3,
    int? artiste4,
    String? paroles,
    String? traductionParoles,
    String? traductionParolesEn,
    String? description,
    String? descriptionEn,
    String? titreTraduction,
    String? titreTraductionEn,
    int? rubrique,
    int? rubrique2,
    int? nbreVue,
    int? nbreVueTraduction,
    String? image,
    String? thumnail,
    int? anneeSortie,
    TypeAlbum? typeAlbum,
    String? album,
    int? albumPrincipal,
    String? tag,
    String? youtube,
    String? droitAuteur,
    String? missing,
    String? traduction,
    String? nomProposant,
    String? urlProposant,
    String? urlProposantTraduction,
    String? proposantTraduction,
    DateTime? dateCreation,
    String? dateCreationTraduction,
    String? dateMiseJour,
    dynamic album2,
    ArtistModel? author,
    List<ArtistModel>? featArtists,
    List<dynamic>? comments,
    Llangue? llangue,
    dynamic llangue2,
    GenreModel? genre,
    dynamic category2,
  }) =>
      LyricModel(
        idLyric: idLyric ?? this.idLyric,
        langue: langue ?? this.langue,
        langue2: langue2 ?? this.langue2,
        titre: titre ?? this.titre,
        titreBis: titreBis ?? this.titreBis,
        artiste: artiste ?? this.artiste,
        featuring: featuring ?? this.featuring,
        artiste3: artiste3 ?? this.artiste3,
        artiste4: artiste4 ?? this.artiste4,
        paroles: paroles ?? this.paroles,
        traductionParoles: traductionParoles ?? this.traductionParoles,
        traductionParolesEn: traductionParolesEn ?? this.traductionParolesEn,
        description: description ?? this.description,
        descriptionEn: descriptionEn ?? this.descriptionEn,
        titreTraduction: titreTraduction ?? this.titreTraduction,
        titreTraductionEn: titreTraductionEn ?? this.titreTraductionEn,
        rubrique: rubrique ?? this.rubrique,
        rubrique2: rubrique2 ?? this.rubrique2,
        nbreVue: nbreVue ?? this.nbreVue,
        nbreVueTraduction: nbreVueTraduction ?? this.nbreVueTraduction,
        image: image ?? this.image,
        thumnail: thumnail ?? this.thumnail,
        anneeSortie: anneeSortie ?? this.anneeSortie,
        typeAlbum: typeAlbum ?? this.typeAlbum,
        album: album ?? this.album,
        albumPrincipal: albumPrincipal ?? this.albumPrincipal,
        tag: tag ?? this.tag,
        youtube: youtube ?? this.youtube,
        droitAuteur: droitAuteur ?? this.droitAuteur,
        missing: missing ?? this.missing,
        traduction: traduction ?? this.traduction,
        nomProposant: nomProposant ?? this.nomProposant,
        urlProposant: urlProposant ?? this.urlProposant,
        urlProposantTraduction:
            urlProposantTraduction ?? this.urlProposantTraduction,
        proposantTraduction: proposantTraduction ?? this.proposantTraduction,
        dateCreation: dateCreation ?? this.dateCreation,
        dateCreationTraduction:
            dateCreationTraduction ?? this.dateCreationTraduction,
        dateMiseJour: dateMiseJour ?? this.dateMiseJour,
        album2: album2 ?? this.album2,
        author: author ?? this.author,
        featArtists: featArtists ?? this.featArtists,
        comments: comments ?? this.comments,
        llangue: llangue ?? this.llangue,
        llangue2: llangue2 ?? this.llangue2,
        genre: genre ?? this.genre,
        category2: category2 ?? this.category2,
      );

  factory LyricModel.fromJson(Map<String, dynamic> json) => LyricModel(
        idLyric: json["id_lyric"] == null ? null : json["id_lyric"],
        langue: json["langue"] == null ? null : json["langue"],
        langue2: json["langue2"] == null ? null : json["langue2"],
        titre: json["titre"] == null ? null : json["titre"],
        titreBis: json["titre_bis"] == null ? null : json["titre_bis"],
        artiste: json["artiste"] == null ? null : json["artiste"],
        featuring: json["featuring"] == null ? null : json["featuring"],
        artiste3: json["artiste3"] == null ? null : json["artiste3"],
        artiste4: json["artiste4"] == null ? null : json["artiste4"],
        paroles: json["paroles"] == null ? null : json["paroles"],
        traductionParoles: json["traduction_paroles"] == null
            ? null
            : json["traduction_paroles"],
        traductionParolesEn: json["traduction_paroles_en"] == null
            ? null
            : json["traduction_paroles_en"],
        description: json["description"] == null ? null : json["description"],
        descriptionEn:
            json["description_en"] == null ? null : json["description_en"],
        titreTraduction:
            json["titre_traduction"] == null ? null : json["titre_traduction"],
        titreTraductionEn: json["titre_traduction_en"] == null
            ? null
            : json["titre_traduction_en"],
        rubrique: json["rubrique"] == null ? null : json["rubrique"],
        rubrique2: json["rubrique2"] == null ? null : json["rubrique2"],
        nbreVue: json["nbre_vue"] == null ? null : json["nbre_vue"],
        nbreVueTraduction: json["nbre_vue_traduction"] == null
            ? null
            : json["nbre_vue_traduction"],
        image: json["image"] == null ? null : json["image"],
        thumnail: json["thumnail"] == null ? null : json["thumnail"],
        anneeSortie: json["annee_sortie"] == null ? null : json["annee_sortie"],
        typeAlbum: json["type_album"] == null
            ? null
            : (json["type_album"] is int)
                ? null
                : TypeAlbum.fromJson(json["type_album"]),
        album: json["album"] == null ? null : json["album"],
        albumPrincipal:
            json["album_principal"] == null ? null : json["album_principal"],
        tag: json["tag"] == null ? null : json["tag"],
        youtube: json["youtube"] == null ? null : json["youtube"],
        droitAuteur: json["droit_auteur"] == null ? null : json["droit_auteur"],
        missing: json["missing"] == null ? null : json["missing"],
        traduction: json["traduction"] == null ? null : json["traduction"],
        nomProposant:
            json["nom_proposant"] == null ? null : json["nom_proposant"],
        urlProposant:
            json["url_proposant"] == null ? null : json["url_proposant"],
        urlProposantTraduction: json["url_proposant_traduction"] == null
            ? null
            : json["url_proposant_traduction"],
        proposantTraduction: json["proposant_traduction"] == null
            ? null
            : json["proposant_traduction"],
        dateCreation: json["date_creation"] == null
            ? null
            : DateTime.parse(json["date_creation"]),
        dateCreationTraduction: json["date_creation_traduction"] == null
            ? null
            : json["date_creation_traduction"],
        dateMiseJour:
            json["date_mise_jour"] == null ? null : json["date_mise_jour"],
        album2: json["album2"],
        author: json["author"] == null
            ? null
            : ArtistModel.fromJson(json["author"]),
        featArtists: json["feat_artists"] == null
            ? null
            : List<ArtistModel>.from(
                json["feat_artists"].map((x) => ArtistModel.fromJson(x))),
        comments: json["comments"] == null
            ? null
            : List<dynamic>.from(json["comments"].map((x) => x)),
        llangue:
            json["llangue"] == null ? null : Llangue.fromJson(json["llangue"]),
        llangue2: json["llangue2"],
        genre: json["category"] == null
            ? null
            : GenreModel.fromJson(json["category"]),
        category2: json["2"] == null ? null : GenreModel.fromJson(json["2"]),
      );

  Map<String, dynamic> toJson() => {
        "id_lyric": idLyric == null ? null : idLyric,
        "langue": langue == null ? null : langue,
        "langue2": langue2 == null ? null : langue2,
        "titre": titre == null ? null : titre,
        "titre_bis": titreBis == null ? null : titreBis,
        "artiste": artiste == null ? null : artiste,
        "featuring": featuring == null ? null : featuring,
        "artiste3": artiste3 == null ? null : artiste3,
        "artiste4": artiste4 == null ? null : artiste4,
        "paroles": paroles == null ? null : paroles,
        "traduction_paroles":
            traductionParoles == null ? null : traductionParoles,
        "traduction_paroles_en":
            traductionParolesEn == null ? null : traductionParolesEn,
        "description": description == null ? null : description,
        "description_en": descriptionEn == null ? null : descriptionEn,
        "titre_traduction": titreTraduction == null ? null : titreTraduction,
        "titre_traduction_en":
            titreTraductionEn == null ? null : titreTraductionEn,
        "rubrique": rubrique == null ? null : rubrique,
        "rubrique2": rubrique2 == null ? null : rubrique2,
        "nbre_vue": nbreVue == null ? null : nbreVue,
        "nbre_vue_traduction":
            nbreVueTraduction == null ? null : nbreVueTraduction,
        "image": image == null ? null : image,
        "thumnail": thumnail == null ? null : thumnail,
        "annee_sortie": anneeSortie == null ? null : anneeSortie,
        "type_album": typeAlbum == null ? null : typeAlbum!.toJson(),
        "album": album == null ? null : album,
        "album_principal": albumPrincipal == null ? null : albumPrincipal,
        "tag": tag == null ? null : tag,
        "youtube": youtube == null ? null : youtube,
        "droit_auteur": droitAuteur == null ? null : droitAuteur,
        "missing": missing == null ? null : missing,
        "traduction": traduction == null ? null : traduction,
        "nom_proposant": nomProposant == null ? null : nomProposant,
        "url_proposant": urlProposant == null ? null : urlProposant,
        "url_proposant_traduction":
            urlProposantTraduction == null ? null : urlProposantTraduction,
        "proposant_traduction":
            proposantTraduction == null ? null : proposantTraduction,
        "date_creation": dateCreation == null
            ? null
            : "${dateCreation!.year.toString().padLeft(4, '0')}-${dateCreation!.month.toString().padLeft(2, '0')}-${dateCreation!.day.toString().padLeft(2, '0')}",
        "date_creation_traduction":
            dateCreationTraduction == null ? null : dateCreationTraduction,
        "date_mise_jour": dateMiseJour == null ? null : dateMiseJour,
        "album2": album2,
        "author": author == null ? null : author!.toJson(),
        "feat_artists": featArtists == null
            ? null
            : List<dynamic>.from(featArtists!.map((x) => x.toJson())),
        "comments": comments == null
            ? null
            : List<dynamic>.from(comments!.map((x) => x)),
        "llangue": llangue == null ? null : llangue!.toJson(),
        "llangue2": llangue2,
        "category": genre == null ? null : genre!.toJson(),
        "category2": category2,
      };
}

class Pivot {
  Pivot({
    this.lyricId,
    this.artistId,
  });

  int? lyricId;
  int? artistId;

  Pivot copyWith({
    int? lyricId,
    int? artistId,
  }) =>
      Pivot(
        lyricId: lyricId ?? this.lyricId,
        artistId: artistId ?? this.artistId,
      );

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        lyricId: json["lyric_id"] == null ? null : json["lyric_id"],
        artistId: json["artist_id"] == null ? null : json["artist_id"],
      );

  Map<String, dynamic> toJson() => {
        "lyric_id": lyricId == null ? null : lyricId,
        "artist_id": artistId == null ? null : artistId,
      };
}

class Llangue {
  Llangue({
    this.idLangue,
    this.nomLangue,
    this.nomLangueEn,
    this.titreBis,
    this.description,
    this.descriptionEn,
    this.dateCreation,
  });

  int? idLangue;
  String? nomLangue;
  String? nomLangueEn;
  String? titreBis;
  String? description;
  String? descriptionEn;
  DateTime? dateCreation;

  Llangue copyWith({
    int? idLangue,
    String? nomLangue,
    String? nomLangueEn,
    String? titreBis,
    String? description,
    String? descriptionEn,
    DateTime? dateCreation,
  }) =>
      Llangue(
        idLangue: idLangue ?? this.idLangue,
        nomLangue: nomLangue ?? this.nomLangue,
        nomLangueEn: nomLangueEn ?? this.nomLangueEn,
        titreBis: titreBis ?? this.titreBis,
        description: description ?? this.description,
        descriptionEn: descriptionEn ?? this.descriptionEn,
        dateCreation: dateCreation ?? this.dateCreation,
      );

  factory Llangue.fromJson(Map<String, dynamic> json) => Llangue(
        idLangue: json["id_langue"] == null ? null : json["id_langue"],
        nomLangue: json["nom_langue"] == null ? null : json["nom_langue"],
        nomLangueEn:
            json["nom_langue_en"] == null ? null : json["nom_langue_en"],
        titreBis: json["titre_bis"] == null ? null : json["titre_bis"],
        description: json["description"] == null ? null : json["description"],
        descriptionEn:
            json["description_en"] == null ? null : json["description_en"],
        dateCreation: json["date_creation"] == null
            ? null
            : DateTime.parse(json["date_creation"]),
      );

  Map<String, dynamic> toJson() => {
        "id_langue": idLangue == null ? null : idLangue,
        "nom_langue": nomLangue == null ? null : nomLangue,
        "nom_langue_en": nomLangueEn == null ? null : nomLangueEn,
        "titre_bis": titreBis == null ? null : titreBis,
        "description": description == null ? null : description,
        "description_en": descriptionEn == null ? null : descriptionEn,
        "date_creation": dateCreation == null
            ? null
            : "${dateCreation!.year.toString().padLeft(4, '0')}-${dateCreation!.month.toString().padLeft(2, '0')}-${dateCreation!.day.toString().padLeft(2, '0')}",
      };
}

class TypeAlbum {
  TypeAlbum({
    this.idTypeAlbum,
    this.nomTypeAlbum,
  });

  int? idTypeAlbum;
  String? nomTypeAlbum;

  TypeAlbum copyWith({
    int? idTypeAlbum,
    String? nomTypeAlbum,
  }) =>
      TypeAlbum(
        idTypeAlbum: idTypeAlbum ?? this.idTypeAlbum,
        nomTypeAlbum: nomTypeAlbum ?? this.nomTypeAlbum,
      );

  factory TypeAlbum.fromJson(Map<String, dynamic> json) {
    try {
      return TypeAlbum(
        idTypeAlbum:
            json["id_type_album"] == null ? null : json["id_type_album"],
        nomTypeAlbum:
            json["nom_type_album"] == null ? null : json["nom_type_album"],
      );
    } catch (e) {
      return TypeAlbum(); // ! removed "return null" to add actual value
    }
  }

  Map<String, dynamic> toJson() => {
        "id_type_album": idTypeAlbum == null ? null : idTypeAlbum,
        "nom_type_album": nomTypeAlbum == null ? null : nomTypeAlbum,
      };
}
