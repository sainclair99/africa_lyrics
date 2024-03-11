import 'package:package_info_plus/package_info_plus.dart';

class Config {
  static PackageInfo? infos; // ! added '?'

  static getAppInfos() async {
    Config.infos = await PackageInfo.fromPlatform();
  }
}
