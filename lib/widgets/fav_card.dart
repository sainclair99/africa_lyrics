import 'package:afrikalyrics_mobile/favorites_controller.dart';
import 'package:afrikalyrics_mobile/models/favorite_model.dart';
import 'package:afrikalyrics_mobile/widgets/app_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavCard extends StatefulWidget {
  final FavoriteModel fav;

  const FavCard({
    super.key,
    required this.fav,
  });

  @override
  _FavCardState createState() => _FavCardState();
}

class _FavCardState extends State<FavCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  AppCachedImage(
                      imageUrl: "${widget.fav.cover}",
                      imageBuilder: (context, provider) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: provider as ImageProvider<Object>,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${widget.fav.titre}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${widget.fav.artiste}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        var favController = Get.find<FavoritesController>();
                        favController.removeFromFav(widget.fav.idLyric!);
                        print(widget.fav.idLyric);
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
