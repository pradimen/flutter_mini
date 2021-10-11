import 'package:flutter/material.dart';

import 'package:pinch_zoom/pinch_zoom.dart';

class FullScreenImage extends StatefulWidget {
  static const routeName = "/fullScreenImage";
  const FullScreenImage({Key? key}) : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final imageURL = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: PinchZoom(
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
                    fit: BoxFit.contain,
                    imageErrorBuilder: (context, error, stacktrace) {
                      return Image.asset(
                        'petfit_logo.png',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      );
                    },
                  )),
      ),
    );
  }
}
