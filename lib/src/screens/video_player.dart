import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class AppVideoPlayer extends StatefulWidget {
  static const routeName = "/AppVideoPlayer";
  final bool looping = true;
  final bool autoPlay = true;
  const AppVideoPlayer({Key? key}) : super(key: key);

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  // ChewieController? _chewieController;
  VideoPlayerController? videoPlayerController;

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // IMPORTANT to dispose of all the used resources
    videoPlayerController?.dispose();
    //  _chewieController?.dispose();
    //  _chewieController?.pause();
  }

  Widget getCustomChewie(String imageURL) {
    return Chewie(
      controller: ChewieController(
          videoPlayerController: videoPlayerController!,
          aspectRatio: 5 / 8,
          autoInitialize: true,
          autoPlay: widget.autoPlay,
          looping: widget.looping,
          showControls: true,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.white),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageURL = ModalRoute.of(context)!.settings.arguments as String;
    videoPlayerController = VideoPlayerController.network(imageURL);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Video Player"),
        ),
        body: getCustomChewie(imageURL),
      ),
    );
  }
}
