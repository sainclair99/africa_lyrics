import 'dart:math';

import 'package:afrikalyrics_mobile/ad_manager.dart';
import 'package:afrikalyrics_mobile/misc/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

extension DiacriticsAwareString on String {
  static const diacritics =
      'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
  static const nonDiacritics =
      'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

  String get withoutDiacriticalMarks => this.splitMapJoin('',
      onNonMatch: (char) => char.isNotEmpty && diacritics.contains(char)
          ? nonDiacritics[diacritics.indexOf(char)]
          : char);
}

class AppBarBannerRecipe extends StatelessWidget
    implements PreferredSizeWidget {
  final AppBar appBar;
  final Size size;

  const AppBarBannerRecipe({
    super.key,
    required this.appBar,
    required this.size,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(appBar.preferredSize.height + height);

  double get height => max(size.height * .06, 50.0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        appBar,
        Container(
          width: size.width,
          height: height,
          child: AdWidget(
            ad: BannerAd(
              adUnitId: AdManager.bannerAdUnitId,
              request: AdRequest(),
              size: AdSize(
                width: size.width.toInt(),
                height: height.toInt(),
              ),
              listener: BannerAdListener(),
            ),
          ),
        )
      ],
    );
  }
}

extension AppBarAdmobX on AppBar {
  PreferredSizeWidget withBottomAdmobBanner(BuildContext context) {
    return AppBarBannerRecipe(
      appBar: this,
      size: MediaQuery.of(context).size,
    );
  }
}

class TopBannerAdAppRecipe extends StatelessWidget {
  const TopBannerAdAppRecipe({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MediaQuery(
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
        child: Container(
          color: Colors.blueGrey,
          child: Column(children: [
            SafeArea(
              bottom: false,
              child: Builder(
                builder: (BuildContext context) {
                  final size = MediaQuery.of(context).size;
                  final height = max(size.height * .05, 50.0);
                  return Container(
                    width: size.width,
                    height: height,
                    child: AdWidget(
                      ad: BannerAd(
                        adUnitId: AdManager.bannerAdUnitId,
                        request: AdRequest(),
                        size: AdSize(
                          width: size.width.toInt(),
                          height: height.toInt(),
                        ),
                        listener: BannerAdListener(),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(child: child),
          ]),
        ),
      ),
    );
  }
}

class BottomBannerAdAppRecipe extends StatelessWidget {
  const BottomBannerAdAppRecipe({
    super.key,
    required this.child,
  });

  final MaterialApp child;

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context) ?? TextDirection.ltr;
    return Directionality(
      textDirection: textDirection,
      child: MediaQuery(
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
        child: Container(
          color: Colors.blueGrey,
          child: Column(children: [
            Expanded(child: child),
            SafeArea(
              top: false,
              child: Builder(
                builder: (BuildContext context) {
                  final size = MediaQuery.of(context).size;
                  final height = max(size.height * .05, 50.0);
                  return Container(
                    width: size.width,
                    height: height,
                    child: AdWidget(
                      ad: BannerAd(
                        adUnitId: AdManager.bannerAdUnitId,
                        request: AdRequest(),
                        size: AdSize(
                          width: size.width.toInt(),
                          height: height.toInt(),
                        ),
                        listener: BannerAdListener(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

extension MaterialAppX on MaterialApp {
  Widget withBottomAdmobBanner(BuildContext context) {
    return BottomBannerAdAppRecipe(
      child: this,
    );
  }
}
