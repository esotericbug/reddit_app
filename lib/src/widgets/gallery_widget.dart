import 'dart:math';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:reddit_app/src/helpers/general.dart';
import 'package:rxdart/rxdart.dart';

class GalleryWidget extends StatefulWidget {
  final List<Widget> children;
  const GalleryWidget({this.children = const [], super.key});

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  final photoScaleController = PhotoViewScaleStateController();

  final BehaviorSubject<int> indexController = BehaviorSubject<int>.seeded(0);

  void onPageChanged(int index) => indexController.add(index);

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
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              PhotoViewGallery.builder(
                backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                itemCount: widget.children.length,
                gaplessPlayback: true,
                onPageChanged: onPageChanged,
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions.customChild(
                    tightMode: true,
                    gestureDetectorBehavior: HitTestBehavior.opaque,
                    scaleStateController: photoScaleController,
                    child: widget.children[index],
                    initialScale: PhotoViewComputedScale.contained,
                    onScaleEnd: (context, scale, contoller) {
                      if (contoller.scale != null && contoller.scale! < 1) {
                        photoScaleController.reset();
                      }
                    },
                  );
                },
              ),
              if (widget.children.length > 1)
                Positioned(
                  top: 0,
                  right: 5,
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
                            "${snapshot.data != null ? snapshot.data! + 1 : 0} / ${widget.children.length}",
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
                )
            ],
          ),
        ),
      ),
    );
  }
}
