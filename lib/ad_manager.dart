import 'dart:io';

import 'package:afrikalyrics_mobile/api/al_api.dart';
import 'package:afrikalyrics_mobile/models/advert_model.dart';
import 'package:afrikalyrics_mobile/service_locator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'misc/screen_utils.dart';
import 'widgets/app_cached_image.dart';

class AdManager {

  static final AdManager _instance = AdManager._init();

  static AdManager get instance => _instance;

  factory AdManager() => _instance;

  late ALApi _alApi;
  static late List<AdvertModel> adverts;
  static Map<String, List<AdvertModel>> advertsMap = new Map();

  late InterstitialAd? _interstitialAd;

  BannerAd? bannerAd;
  bool isBannerAdReady = false;

  AdManager._init() {

    InterstitialAd.load(
      adUnitId: AdManager.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (onAdLoaded) {
          _interstitialAd = onAdLoaded;
          _interstitialAd?.setImmersiveMode(true);
        },
        onAdFailedToLoad: (onAdFailedToLoad) {
          _interstitialAd = null;
          AdManager._init();
        },
      ),
    );

    createBottomBannerAd();

  }

  disposeInterstitialAd() {
    _interstitialAd?.dispose();
  }

  showInstertialAd() {
    _interstitialAd?.show();
  }

  createBottomBannerAd() {
    try {
      bannerAd = BannerAd(
        size: AdSize.banner,
        request: const AdRequest(),
        adUnitId: AdManager.bannerAdUnitId,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            print('Admob banner loaded!');
          },
          onAdOpened: (ad) {
            print('Admob banner opened!');
          },
          onAdClosed: (ad) {
            print('Admob banner closed!');
          },
          onAdFailedToLoad: (ad, error) {
            print('Admob banner failed to load. Error code: ${error.code}');
          },
          onAdClicked: (ad) {
            print('Admob banner clicked!');
          },
          onAdWillDismissScreen: (ad) {
            print('Admob banner left application!');
          },
        ),
      );

      bannerAd!.load();
    }
    catch (e){
      bannerAd = null;
    }
  }

  showBannerAds(BuildContext context, {int? slot}) {
    if (slot != null && advertsMap.containsKey("$slot")) {
      bool hasLarge = advertsMap["$slot"]!.any((ad) => ad.format != "banner");
      return Container(
        height: hasLarge ? 180 : 60,
        child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            enableInfiniteScroll: false,
          ),
          items: advertsMap["$slot"]
              ?.map((ad) => AppCachedImage(
                    imageUrl: '${ad.imageUrl}',
                    imageBuilder: (context, provider) {
                      return Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: provider as ImageProvider<Object>,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ))
              .toList(),
        ),
      );
    }

    if(bannerAd !=null && isBannerAdReady){
      return Container(
        height: 60,
        child: AdWidget(
          ad: bannerAd!,
        ),
      );
    }else{
      return Container();
    }

  }

  @override
  // void dispose() {
  //   bannerAd!.dispose();
  //   isBannerAdReady = false;
  //   super.dispose();
  // }

  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6363498397013332~2795141428";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6363498397013332~4387582743";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6363498397013332/7498737911";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6363498397013332/9990714478";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6363498397013332/4269939344";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6363498397013332/3602960598";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/8673189370";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/7552160883";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  ///Customized Advertissement

  static Future<List<AdvertModel>> loadAdverts() async {
    Response resp = await locator.get<ALApi>().getRequest("/adverts/client");
    List<AdvertModel> listData = [];
    for (var i = 0; i < resp.data.length; i++) {
      var model = AdvertModel.fromJson(resp.data[i]);
      if (advertsMap["${model.spaceId}"] == null) {
        advertsMap["${model.spaceId}"] = [];
      }
      advertsMap["${model.spaceId}"]?.add(model);
      listData.add(model);
    }
    adverts = listData;
    return listData;
  }
}


// class AdManager {
//   static late AdManager _instance;
//   static AdManager get instance => _instance;
//   static void init() => _instance ??= AdManager._init();
//   late ALApi _alApi;
//   static late List<AdvertModel> adverts;
//   static Map<String, List<AdvertModel>> advertsMap = new Map();

//   late AdmobInterstitial _interstitialAd;
//   AdManager._init() {
//     _interstitialAd = AdmobInterstitial(
//       adUnitId: AdManager.interstitialAdUnitId,
//       listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
//         if (event == AdmobAdEvent.closed) _interstitialAd.load();
//       },
//     );
//     _interstitialAd.load();
//   }
//   factory AdManager() => _instance;

//   disposeInterstitialAd() {
//     _interstitialAd.dispose();
//   }

//   showInstertialAd() {
//     _interstitialAd.show();
//   }

//   showBannerAds(BuildContext context, {int? slot}) {
//     if (slot != null && advertsMap.containsKey("$slot")) {
//       bool hasLarge = advertsMap["$slot"]!.any((ad) => ad.format != "banner");
//       return Container(
//         height: hasLarge ? 180 : 60,
//         child: CarouselSlider(
//           options: CarouselOptions(
//             autoPlay: true,
//             enableInfiniteScroll: false,
//           ),
//           items: advertsMap["$slot"]
//               ?.map((ad) => AppCachedImage(
//                     imageUrl: '${ad.imageUrl}',
//                     imageBuilder: (context, provider) {
//                       return Container(
//                         height: 60,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                           image: DecorationImage(
//                             image: provider as ImageProvider<Object>,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       );
//                     },
//                   ))
//               .toList(),
//         ),
//       );
//     }
//     return Container(
//       height: 60,
//       child: AdmobBanner(
//         adUnitId: AdManager.bannerAdUnitId,
//         adSize: AdmobBannerSize.ADAPTIVE_BANNER(
//           width: ScreenUtils.getScreenWidth(context).toInt(),
//         ),
//         listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
//           switch (event) {
//             case AdmobAdEvent.loaded:
//               print('Admob banner loaded!');
//               break;

//             case AdmobAdEvent.opened:
//               print('Admob banner opened!');
//               break;

//             case AdmobAdEvent.closed:
//               print('Admob banner closed!');
//               break;

//             case AdmobAdEvent.failedToLoad:
//               print(
//                   'Admob banner failed to load. Error code: ${args?['errorCode']}');
//               break;
//             case AdmobAdEvent.clicked:
//               print('Admob banner clicked!');
//               break;
//             case AdmobAdEvent.impression:
//               print('Admob banner impression!');
//               break;
//             case AdmobAdEvent.leftApplication:
//               print('Admob banner leftApplication!');
//               break;
//             case AdmobAdEvent.completed:
//               print('Admob banner completed!');
//               break;
//             case AdmobAdEvent.rewarded:
//               print('Admob banner rewarded!');
//               break;
//             case AdmobAdEvent.started:
//               print('Admob banner started!');
//               break;
//           }
//         },
//       ),
//     );
//   }

//   static String get appId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-6363498397013332~2795141428";
//     } else if (Platform.isIOS) {
//       return "ca-app-pub-6363498397013332~4387582743";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }

//   static String get bannerAdUnitId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-6363498397013332/7498737911";
//     } else if (Platform.isIOS) {
//       return "ca-app-pub-6363498397013332/9990714478";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }

//   static String get interstitialAdUnitId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-6363498397013332/4269939344";
//     } else if (Platform.isIOS) {
//       return "ca-app-pub-6363498397013332/3602960598";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }

//   static String get rewardedAdUnitId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-3940256099942544/8673189370";
//     } else if (Platform.isIOS) {
//       return "ca-app-pub-3940256099942544/7552160883";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }

//   ///Customized Advertissement

//   static Future<List<AdvertModel>> loadAdverts() async {
//     Response resp = await locator.get<ALApi>().getRequest("/adverts/client");
//     List<AdvertModel> listData = [];
//     for (var i = 0; i < resp.data.length; i++) {
//       var model = AdvertModel.fromJson(resp.data[i]);
//       if (advertsMap["${model.spaceId}"] == null) {
//         advertsMap["${model.spaceId}"] = [];
//       }
//       advertsMap["${model.spaceId}"]?.add(model);
//       listData.add(model);
//     }
//     adverts = listData;
//     return listData;
//   }
// }

