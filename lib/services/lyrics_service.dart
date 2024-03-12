import 'package:afrikalyrics_mobile/api/al_api.dart';
import 'package:afrikalyrics_mobile/api/token_manager.dart';
import 'package:afrikalyrics_mobile/models/artist_model.dart';
import 'package:afrikalyrics_mobile/models/country_model.dart';
import 'package:afrikalyrics_mobile/models/genre_model.dart';
import 'package:afrikalyrics_mobile/models/lyric_model.dart';
import 'package:afrikalyrics_mobile/player/models/LrcModel.dart';
import 'package:afrikalyrics_mobile/service_locator.dart';
import 'package:afrikalyrics_mobile/services/al_service.dart';
import 'package:dio/dio.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class LyricsService extends ALService {
  final ALApi _alApi = locator.get<ALApi>(); // ! init here and add final
  LyricsService() {
    // ! this._alApi = locator.get<ALApi>();
  }

  Future<List<LyricModel>> fetchTopLyrics() async {
    Response resp = await this._alApi.getRequest("/lyrics/top", auth: true);

    Map data = this.parseResponse(resp);
    List<LyricModel> listData = [];

    data.entries.forEach((e) {
      listData.add(LyricModel.fromJson(e.value));
    });

    return listData;
  }

  Future<List<LyricModel>> fetchPopularLyrics() async {
    Response resp = await this._alApi.getRequest("/lyrics/popular", auth: true);
    List<LyricModel> listData = [];
    var data = this.parseResponse(resp);
    for (var i = 0; i < data.length; i++) {
      listData.add(LyricModel.fromJson(data[i]));
    }
    return listData;
  }

  Future<LyricModel> fetchLyricDetails(id) async {
    Response resp = await this._alApi.getRequest("/lyrics/$id", auth: true);
    var data = this.parseResponse(resp);

    return LyricModel.fromJson(data);
  }

  Future<List<LyricModel>> fetchUneLyrics() async {
    Response resp = await this._alApi.getRequest("/lyrics/une", auth: true);
    List<LyricModel> listData = [];
    var data = this.parseResponse(resp);
    for (var i = 0; i < data.length; i++) {
      listData.add(LyricModel.fromJson(data[i]));
    }
    return listData;
  }

  Future<List<LyricModel>> fetchLatestLyrics({page = 1}) async {
    Response resp =
        await this._alApi.getRequest("/lyrics/latest?page=$page", auth: true);
    List<LyricModel> listData = [];
    var data = this.parseResponse(resp)["data"];

    for (var i = 0; i < math.min(9, data.length); i++) {
      listData.add(LyricModel.fromJson(data[i]));
    }
    return listData;
  }

  Future<List<LyricModel>> findLyrics(
      {String? s, int? artistId, page = 1}) async {
    Map<String, dynamic> params = new Map();
    if (s != null) {
      params['s'] = s;
    }
    if (artistId != null) {
      params['artist_id'] = artistId;
    }
    Response resp = await this._alApi.getRequest(
          "/lyrics",
          queryParameters: params,
          auth: true,
        );
    List<LyricModel> listData = [];

    var data = this.parseResponse(resp)["data"];

    for (var i = 0; i < math.min(9, data.length); i++) {
      listData.add(LyricModel.fromJson(data[i]));
    }
    return listData;
  }

  Future<List<LyricModel>> fetchTranslationsLyrics({page = 1}) async {
    Response resp = await this
        ._alApi
        .getRequest("/lyrics/translations?page=$page", auth: true);
    List<LyricModel> listData = [];
    var data = this.parseResponse(resp)["data"];
    for (var i = 0; i < math.min(9, data.length); i++) {
      listData.add(LyricModel.fromJson(data[i]));
    }
    return listData;
  }

  Future<List<GenreModel>> fetchGenresLyrics({page = 1}) async {
    Response resp = await this._alApi.getRequest("/lyrics/genres", auth: true);
    List<GenreModel> listData = [];

    print(resp);
    var data = this.parseResponse(resp);

    for (var i = 0; i < data.length; i++) {
      listData.add(GenreModel.fromJson(data[i]));
    }
    return listData;
  }

  Future<List<ArtistModel>> fetchArtistsByCountry({@required countryId}) async {
    Response resp = await this
        ._alApi
        .getRequest("/countries/$countryId/artists", auth: true);
    List<ArtistModel> listData = [];
    var data = this.parseResponse(resp);
    for (var i = 0; i < math.min(9, data.length); i++) {
      listData.add(ArtistModel.fromJson(data[i]));
    }
    return listData;
  }

  Future<List<CountryModel>> fetchAllCountries({page = 1}) async {
    Response resp = await this._alApi.getRequest("/countries", auth: true);
    List<CountryModel> listData = [];
    var data = parseResponse(resp);
    for (var i = 0; i < data.length; i++) {
      listData.add(CountryModel.fromJson(data[i]));
    }
    return listData;
  }

  Future<List<LyricModel>> fetchGenreDetails(int genreId, {page = 1}) async {
    Response resp = await _alApi
        .getRequest("/lyrics/genres/$genreId?page=$page", auth: true);

    List<LyricModel> listData = [];
    var data = parseResponse(resp)["data"];
    print(resp);
    for (var i = 0; i < data.length; i++) {
      listData.add(LyricModel.fromJson(data[i]));
    }
    return listData;
  }

  Future<List<LrcModel>> searchLrc({String? artist, String? title}) async {
    print("In search lyrics: ");
    var options = Options();

    options.headers = {
      ...?options.headers,
      'accept': 'application/json'
    }; // ! added "!" tag

    var token = TokenManager().token;
    options.headers = {
      ...?options.headers,
      'Authorization': 'Bearer $token'
    }; // ! added "!" tag
    print(token);
    // options.headers = {
    //   'Accept': 'application/json',
    //   // 'Authorization': 'Bearer $token'
    // };
    var resp = await Dio().get(
      'https://api.afrikalyrics.com/api/lyric-media',
      queryParameters: {
        'artist_name': artist,
        "title": title,
      },
      options: options,
    );
    print(resp);
    var data = parseResponse(resp)["data"];
    List<LrcModel> listData = [];
    for (var i = 0; i < data.length; i++) {
      listData.add(LrcModel.fromJson(data[i]));
    }

    return listData;
  }

  getFile(String name) async {
    var resp = await _alApi.getRequest("/files/$name");
    print(resp);
    return resp.data;
  }
}
