import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:afrikalyrics_mobile/ad_manager.dart';
import 'package:afrikalyrics_mobile/ads_controller.dart';
import 'package:afrikalyrics_mobile/bottom_navigation.dart';
import 'package:afrikalyrics_mobile/config.dart';
import 'package:afrikalyrics_mobile/favorites_controller.dart';
import 'package:afrikalyrics_mobile/home_controller.dart';
import 'package:afrikalyrics_mobile/misc/app_colors.dart';
import 'package:afrikalyrics_mobile/misc/utils.dart';
import 'package:afrikalyrics_mobile/models/favorite_model.dart';
import 'package:afrikalyrics_mobile/payments_controller.dart';
import 'package:afrikalyrics_mobile/player/models/song_lrc.dart';
import 'package:afrikalyrics_mobile/player/player_controller.dart';
import 'package:afrikalyrics_mobile/service_locator.dart';
import 'package:afrikalyrics_mobile/splash_screen.dart';
import 'package:afrikalyrics_mobile/theme_service.dart';
import 'package:afrikalyrics_mobile/themes.dart';
import 'package:afrikalyrics_mobile/widgets/app_future_builder.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:permission_handler/permission_handler.dart';

import 'api/token_manager.dart';
import 'auth/auth_controller.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

// ! added interpolations and null safety behaviors
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  _showNotification(
    title: '${message.notification!.title}',
    body: "${message.notification!.body}",
    imageUrl: "${message.notification!.android!.imageUrl}",
  );
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
      );
    }).sendPort);

    await [
      Permission.mediaLibrary,
      Permission.storage,
      Permission.notification,
    ].request();

    //Hive
    Directory directory = await pathProvider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    Hive.registerAdapter(SongLrcAdapter());
    Hive.registerAdapter(FavoriteModelAdapter());
    await Hive.openBox<SongLrc>("songlrcs");
    await Hive.openBox<FavoriteModel>("favorites");
    await Hive.openBox<String>("suggestions");

    await setupLocator();
    // Addmod Inititialization
    // ! Admob.initialize();
    MobileAds.instance.initialize();
    AdManager.init();
    // ! InAppPurchaseConnection.enablePendingPurchases();
    // ! if (Platform.isIOS) {
    //   await Admob.requestTrackingAuthorization();
    // }
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    _createNotificationChannel();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      _showNotification(
        title: "${message.notification!.title}",
        body: "${message.notification!.body}",
        imageUrl: "${message.notification!.android!.imageUrl}",
      );
    });

    print('User granted permission: ${settings.authorizationStatus}');
    initNotifications();

    // Admob.initialize();
    // Admob.requestTrackingAuthorization();

    await GetStorage.init();
    await Config.getAppInfos();
    runApp(ALApp());
  } catch (e, s) {
    print(e);
    FirebaseCrashlytics.instance.recordError(e, s);
  }
}

Future<void> _createNotificationChannel() async {
  var androidNotificationChannel = AndroidNotificationChannel(
    '1AfrikaLyrics', // channel ID
    '1AfrikaLyrics', // channel name
    description: '1AfrikaLyrics', //channel description
    importance: Importance.max,
    enableVibration: true,
    showBadge: true,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);
}

Future<void> _showNotification(
    {String? title, String? body, String? imageUrl}) async {
  BigPictureStyleInformation? bigPictureStyleInformation =
      null; // ! added "?" symbol and null init
  if (imageUrl != null) {
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(imageUrl);
      if (imageId != null) {
        var path = await ImageDownloader.findPath(imageId);
        bigPictureStyleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(path!),
          largeIcon: FilePathAndroidBitmap(path),
          contentTitle: title,
          summaryText: body,
        );
      }
    } on PlatformException catch (error) {
      print(error);
    }
  }
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    '1AfrikaLyrics',
    "$title",
    channelDescription: "$body",
    importance: Importance.max,
    priority: Priority.max,
    ticker: 'ticker',
    enableVibration: true,
    styleInformation: bigPictureStyleInformation != null
        ? bigPictureStyleInformation
        : null, // ! added condition
  );
  NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  FlutterRingtonePlayer.playNotification();

  await flutterLocalNotificationsPlugin.show(
    14,
    "$title",
    "$body",
    platformChannelSpecifics,
  );
}

initNotifications() async {
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails(); // ! added "?" tag

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  // ! final IOSInitializationSettings initializationSettingsIOS =
  //     IOSInitializationSettings(
  //         requestAlertPermission: true,
  //         requestBadgePermission: true,
  //         requestSoundPermission: true,
  //         onDidReceiveLocalNotification:
  //             (int? id, String? title, String? body, String? payload) async {});
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    // ! iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    // ! onSelectNotification: (String? payload) async {
    //   if (payload != null) {
    //     debugPrint('notification payload: $payload');
    //   }
    // },
  );
}

class ALApp extends StatefulWidget {
  @override
  _ALAppState createState() => _ALAppState();
}

class _ALAppState extends State<ALApp> {
  Completer<bool> _appStater = Completer<bool>();
  @override
  void initState() {
    super.initState();

    TokenManager().getToken().whenComplete(() {
      AdManager.loadAdverts().whenComplete(() {
        _appStater.complete(true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          MoveToBackground.moveTaskToBack();
          return false;
        }
        return true;
      },
      child: GetMaterialApp(
        title: 'Afrika Lyrics',
        debugShowCheckedModeBanner: false,
        theme: Themes.light(context),
        darkTheme: Themes.dark(context),
        themeMode: ThemeService().theme,
        home: AppFutureBuilder<bool>(
          future: _appStater.future,
          loadingWidget: SplashScreenPage(),
          onDataWidget: (data) {
            bindControllers();
            return BottomNavigationPage();
          },
          onErrorWidget: (error) {
            print(error);
            bindControllers();
            return BottomNavigationPage();
          },
        ),
      ),
    );
  }

  bindControllers() {
    Get.put<PlayerController>(PlayerController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<AdsController>(AdsController(), permanent: true);
    Get.put<FavoritesController>(FavoritesController(), permanent: true);
    Get.put<PaymentsController>(PaymentsController(), permanent: true);
  }
}
