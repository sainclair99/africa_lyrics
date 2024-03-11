import 'package:afrikalyrics_mobile/misc/app_strings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppCachedImage extends StatelessWidget {
  String imageUrl;
  Widget Function(BuildContext, ImageProvider<dynamic>) imageBuilder;
  Widget Function(BuildContext, ImageProvider<dynamic>)? errorImageBuilder;
  ImageProvider<dynamic>? defaultImageProvider;
  String baseUrl;

  AppCachedImage({
    super.key,
    required this.imageUrl,
    required this.imageBuilder,
    this.defaultImageProvider,
    this.errorImageBuilder,
    this.baseUrl = AppStrings.lyricImageBaseUrl,
  });

  @override
  Widget build(BuildContext context) {
    String defaultImage = "assets/images/logo-circle.jpg";
    if (imageUrl == null || imageUrl == "") {
      return errorImageBuilder != null
          ? errorImageBuilder!(
              context,
              defaultImageProvider ??
                  Image.asset(
                    defaultImage,
                  ).image,
            )
          : imageBuilder.call(
              context,
              defaultImageProvider ??
                  Image.asset(
                    defaultImage,
                  ).image,
            );
    }
    return CachedNetworkImage(
        imageUrl: baseUrl + imageUrl,
        imageBuilder: imageBuilder,
        placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: imageBuilder.call(
                context,
                Image.asset(
                  defaultImage,
                ).image,
              ),
            ),
        errorWidget: (context, url, error) {
          return imageBuilder.call(
            context,
            defaultImageProvider ??
                Image.asset(
                  defaultImage,
                ).image,
          );
        });
  }
}
