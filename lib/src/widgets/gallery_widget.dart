import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:reddit_app/src/helpers/enums.dart';
import 'package:reddit_app/src/helpers/general.dart';
import 'package:reddit_app/src/models/listing_response_model.dart';
import 'package:reddit_app/src/widgets/photo_view/photo_view.dart';
import 'package:reddit_app/src/widgets/photo_view/photo_view_gallery.dart';
import 'package:reddit_app/src/widgets/video_player_widget.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_player/video_player.dart';

class GalleryWidget extends StatefulWidget {
  final List<RedditMedia> redditMediaList;
  const GalleryWidget({this.redditMediaList = const [], super.key});

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  final photoScaleController = PhotoViewScaleStateController();
  final PageController controller = PageController();

  final BehaviorSubject<int> indexController = BehaviorSubject<int>.seeded(0);

  void onPageChanged(int index) => indexController.add(index);

  PhotoViewGalleryPageOptions photoViewCustomChild(Widget child, {Widget? secondChild}) =>
      PhotoViewGalleryPageOptions.customChild(
        tightMode: true,
        gestureDetectorBehavior: HitTestBehavior.opaque,
        scaleStateController: photoScaleController,
        child: child,
        minScale: 1.0,
        initialScale: PhotoViewComputedScale.contained,
        secondChild: secondChild,
        // onScaleEnd: (context, scale, contoller) {
        //   final scale = contoller.scale;
        //   if (scale == null) return;
        //   if (scale < 1) photoScaleController.reset();
        // },
      );

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () {
        Navigator.of(context).pop();
      },
      minScale: 1,
      startingOpacity: 1,
      maxTransformValue: 1,
      direction: DismissiblePageDismissDirection.vertical,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            PhotoViewGallery.builder(
              backgroundDecoration: const BoxDecoration(color: Colors.transparent),
              itemCount: widget.redditMediaList.length,
              onPageChanged: onPageChanged,
              builder: (BuildContext context, int index) {
                final media = widget.redditMediaList[index];

                if (media.type == MediaType.image && media.url != null) {
                  return photoViewCustomChild(
                    ImageWithLoader(
                      media.url,
                      width: media.width,
                      height: media.height,
                      withCacheHeight: false,
                    ),
                  );
                } else if ((media.type == MediaType.video || media.type == MediaType.gif) && media.url != null) {
                  final controller = VideoPlayerController.network(
                    media.url.toString(),
                    videoPlayerOptions: VideoPlayerOptions(
                      allowBackgroundPlayback: true,
                      mixWithOthers: true,
                    ),
                  );
                  return photoViewCustomChild(
                    VideoPlayerWidget(
                      controller: controller,
                      url: media.url.toString(),
                    ),
                    secondChild: VideoControls(controller),
                  );
                } else {
                  return photoViewCustomChild(
                    InAppWebView(
                      initialUrlRequest: URLRequest(url: Uri.parse('${media.url}')),
                    ),
                  );
                }
              },
            ),
            if (widget.redditMediaList.length > 1)
              Positioned(
                top: 5,
                right: 5,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      child: StreamBuilder<int>(
                        stream: indexController.stream,
                        builder: (context, snapshot) {
                          return Text(
                            "${snapshot.data != null ? snapshot.data! + 1 : 0} / ${widget.redditMediaList.length}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              decoration: null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
