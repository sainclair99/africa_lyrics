import 'package:afrikalyrics_mobile/api/al_api.dart';
import 'package:afrikalyrics_mobile/models/artist_model.dart';
import 'package:afrikalyrics_mobile/service_locator.dart';
import 'package:afrikalyrics_mobile/services/al_service.dart';
import 'package:dio/dio.dart';

class ArtistsService extends ALService {
  final ALApi _alApi = locator.get<ALApi>(); // ! init here and add final
  ArtistsService() {
    // ! this._alApi = locator.get<ALApi>();
  }

  Future<List<ArtistModel>> fetchTopArtists() async {
    Response resp = await this._alApi.getRequest("/artists/top", auth: true);
    List<ArtistModel> listData = [];

    var data = this.parseResponse(resp);

    for (var i = 0; i < data.length; i++) {
      listData.add(ArtistModel.fromJson(data[i]));
    }
    listData.sort((a, b) => a.classement!.compareTo(b.classement!));
    return listData;
  }

  Future<ArtistModel> fetchArtistDetails(dynamic id) async {
    Response resp = await this._alApi.getRequest("/artists/$id", auth: true);
    var data = this.parseResponse(resp);
    return ArtistModel.fromJson(data);
  }
}
