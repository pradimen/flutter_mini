import 'package:flutter/material.dart';
import 'package:petfit/src/screens/full_image_view.dart';
import 'package:petfit/src/screens/video_player.dart';

class AlbumGrid extends StatefulWidget {
  final List<String?> albumData;
  final bool photoFlag;
  AlbumGrid({required this.albumData, required this.photoFlag});

  @override
  State<AlbumGrid> createState() => _AlbumGridState();
}

void pushFullScreenImage() {}

class _AlbumGridState extends State<AlbumGrid> {
  Widget albumCard(String imageURL, bool photoFlag) {
    return InkWell(
      onTap: () {
        if (photoFlag) {
          Navigator.of(context)
              .pushNamed(FullScreenImage.routeName, arguments: imageURL);
        } else {
          Navigator.of(context)
              .pushNamed(AppVideoPlayer.routeName, arguments: imageURL);
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: imageURL.length == 0
            ? Image.asset(
                'petfit_logo.png',
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              )
            : FadeInImage.assetNetwork(
                placeholder: "petfit_logo.png",
                image: imageURL,
                fit: BoxFit.fill,
                imageErrorBuilder: (context, error, stacktrace) {
                  return Image.asset(
                    'petfit_logo.png',
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  );
                },
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      padding: EdgeInsets.all(10),
      children: this
          .widget
          .albumData
          .map((e) => albumCard(e as String, this.widget.photoFlag))
          .toList(),
    );
  }
}
