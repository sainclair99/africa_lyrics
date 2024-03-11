import 'package:dio/dio.dart';

class ALService {
  dynamic parseResponse(Response resp) {
    return resp.data["data"];
  }
}
