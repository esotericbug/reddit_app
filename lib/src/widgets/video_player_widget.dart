import 'dart:io';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reddit_app/src/helpers/general.dart';
import 'package:rxdart/rxdart.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '/src/helpers/enums.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final VideoType type;
  final EdgeInsetsGeometry videoPadding;
  final bool autoPlay;
  final bool muted;
  final bool witchCache;
  const VideoPlayerWidget({
    required this.url,
    this.type = VideoType.network,
    this.videoPadding = const EdgeInsets.all(0),
    this.autoPlay = true,
    this.muted = true,
    this.witchCache = false,
    super.key,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  bool loading = true;
  bool initialized = false;
  bool error = false;
  VideoPlayerController? controller;

  final BehaviorSubject<int?> _progressController = BehaviorSubject<int?>.seeded(0);

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        Dev.log(widget.url);
        controller = await getController();
        await controller?.initialize();
        setState(() {});
        if (widget.autoPlay) await controller?.play();
        if (widget.muted) await controller?.setVolume(0.0);
        controller?.addListener(setProgress);
        setState(() {
          initialized = true;
        });
      } catch (e) {
        setState(() {
          error = true;
          initialized = true;
        });
      }
    });
  }

  Future<VideoPlayerController?> getController() async {
    switch (widget.type) {
      case VideoType.network:
        {
          // if (widget.witchCache) {
          //   return VideoPlayerController.file(await DefaultCacheManager().getSingleFile(widget.url));
          // }
          return VideoPlayerController.network(widget.url);
        }
      case VideoType.asset:
        return VideoPlayerController.asset(widget.url);
      case VideoType.file:
        return VideoPlayerController.file(File(widget.url));
      default:
        return null;
    }
  }

  @override
  void dispose() async {
    controller?.removeListener(setProgress);
    super.dispose();
    await controller?.dispose();
  }

  void setProgress() {
    if (controller == null) return;
    _progressController.add(controller?.value.position.inMicroseconds);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (controller != null) {
          if (controller!.value.isPlaying) {
            controller?.pause();
          } else {
            controller?.play();
          }
          setState(() {});
        }
      },
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return ClipRRect(
          child: Container(
            color: Colors.black,
            width: constraints.maxWidth,
            height: constraints.maxHeight == double.infinity ? constraints.maxWidth : constraints.maxHeight,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                if (initialized && !error) ...[
                  if (controller != null && controller!.value.isInitialized) ...[
                    FittedBox(
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      child: SizedBox(
                        width: controller!.value.size.width,
                        height: controller!.value.size.height,
                        child: Padding(
                          padding: widget.videoPadding,
                          child: VideoPlayer(controller!),
                        ),
                      ),
                    ),
                    if (controller != null && controller!.value.isInitialized) ...[
                      if (controller != null && !controller!.value.isPlaying)
                        Container(
                          alignment: Alignment.center,
                          color: Colors.black45,
                          child: controller != null && !controller!.value.isBuffering
                              ? const Icon(
                                  Icons.play_arrow,
                                  size: 50,
                                )
                              : null,
                        ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (controller != null &&
                                      controller!.value.isInitialized &&
                                      !controller!.value.isBuffering) {
                                    if (!controller!.value.isPlaying) {
                                      controller?.play();
                                    } else {
                                      controller?.pause();
                                    }
                                    setState(() {});
                                  }
                                },
                                child: Icon(
                                  size: 25,
                                  color: Colors.white,
                                  controller != null && !controller!.value.isPlaying ? Icons.play_arrow : Icons.pause,
                                ),
                              ),
                              Expanded(
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: Colors.white,
                                    inactiveTrackColor: Colors.grey,
                                    trackShape: const RoundedRectSliderTrackShape(),
                                    trackHeight: 1.0,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 10,
                                      elevation: 0,
                                      pressedElevation: 0,
                                    ),
                                    thumbColor: Colors.transparent,
                                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                                    tickMarkShape: const RoundSliderTickMarkShape(),
                                    valueIndicatorTextStyle: const TextStyle(color: Colors.white),
                                  ),
                                  child: StreamBuilder<int?>(
                                      stream: _progressController,
                                      builder: (context, snapshot) {
                                        return Slider(
                                          value: snapshot.data?.toDouble() ?? 0,
                                          min: 0,
                                          max: controller!.value.duration.inMicroseconds.toDouble(),
                                          onChanged: (value) {
                                            _progressController.add(value.toInt());
                                          },
                                          onChangeEnd: (value) async {
                                            if (value == controller!.value.duration.inMicroseconds.toDouble()) {
                                              await controller?.seekTo(Duration(microseconds: value.toInt() - 1));
                                            } else {
                                              await controller?.seekTo(Duration(microseconds: value.toInt()));
                                            }
                                            await controller?.play();
                                          },
                                          onChangeStart: (value) async {
                                            await controller?.pause();
                                          },
                                        );
                                      }),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${getFormattedDuration(controller!.value.position)}/${getFormattedDuration(controller!.value.duration)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              // const SizedBox(
                              //   width: 5,
                              // ),
                              // InkWell(
                              //   onTap: () async {
                              //     // await controller.pause();
                              //     if (!mounted) return;
                              //     context.pushTransparentRoute(DismissiblePage(
                              //       onDismissed: () => Navigator.of(context).pop(),
                              //       direction: DismissiblePageDismissDirection.vertical,
                              //       child: _VideoPlayerFullScreenWidget(
                              //         controller: controller!,
                              //         url: widget.url,
                              //       ),
                              //     ));
                              //   },
                              //   child: Ink(
                              //     child: const Icon(
                              //       Icons.fullscreen,
                              //       size: 25,
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              // ),
                              const SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () async {
                                  if (controller?.value.volume == 0) {
                                    await controller?.setVolume(1);
                                  } else {
                                    await controller?.setVolume(0);
                                  }
                                  setState(() {});
                                },
                                child: Ink(
                                  child: Icon(
                                    controller?.value.volume == 0 ? Icons.volume_off : Icons.volume_up,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (controller!.value.isBuffering)
                      const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                  ]
                ] else if (error)
                  Container(
                    color: Colors.black,
                    child: Center(
                      child: Text(
                        '${controller?.value.errorDescription}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                else
                  Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _VideoPlayerFullScreenWidget extends StatefulWidget {
  final String url;
  final VideoPlayerController controller;
  const _VideoPlayerFullScreenWidget({
    required this.controller,
    required this.url,
  });

  @override
  State<_VideoPlayerFullScreenWidget> createState() => _VideoPlayerFullScreenWidgetState();
}

class _VideoPlayerFullScreenWidgetState extends State<_VideoPlayerFullScreenWidget> {
  int progress = 0;
  Orientation orientation = Orientation.portrait;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      setState(() {
        progress = widget.controller.value.position.inMicroseconds;
      });
      widget.controller.addListener(setProgress);
    });
  }

  void setProgress() {
    setState(() {
      progress = widget.controller.value.position.inMicroseconds;
    });
  }

  @override
  void dispose() async {
    widget.controller.removeListener(setProgress);
    super.dispose();
    await restore();
  }

  Future<void> setLandscape() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    setState(() {
      orientation = Orientation.landscape;
    });
  }

  Future<void> restoreLandscape() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    setState(() {
      orientation = Orientation.portrait;
    });
  }

  Future<void> restore() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.top]);
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    setState(() {
      orientation = Orientation.portrait;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => widget.controller.value.isPlaying ? widget.controller.pause() : widget.controller.play(),
          child: ClipRRect(
            child: Container(
              color: Colors.black,
              width: constraints.maxWidth,
              height: constraints.maxHeight == double.infinity ? constraints.maxWidth : constraints.maxHeight,
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: widget.controller.value.size.width,
                      height: widget.controller.value.size.height,
                      child: VideoPlayer(widget.controller),
                    ),
                  ),
                  if (widget.controller.value.isInitialized) ...[
                    if (!widget.controller.value.isPlaying)
                      Container(
                        alignment: Alignment.center,
                        color: Colors.black45,
                        child: !widget.controller.value.isBuffering
                            ? const Icon(
                                Icons.play_arrow,
                                size: 60,
                              )
                            : null,
                      ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (widget.controller.value.isInitialized && !widget.controller.value.isBuffering) {
                                  if (!widget.controller.value.isPlaying) {
                                    widget.controller.play();
                                  } else {
                                    widget.controller.pause();
                                  }
                                }
                              },
                              child: Icon(
                                size: 30,
                                color: Colors.white,
                                !widget.controller.value.isPlaying ? Icons.play_arrow : Icons.pause,
                              ),
                            ),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Colors.white,
                                  inactiveTrackColor: Colors.grey,
                                  trackShape: const RoundedRectSliderTrackShape(),
                                  trackHeight: 1.0,
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 10,
                                    elevation: 0,
                                    pressedElevation: 0,
                                  ),
                                  thumbColor: Colors.transparent,
                                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                                  tickMarkShape: const RoundSliderTickMarkShape(),
                                  valueIndicatorTextStyle: const TextStyle(color: Colors.white),
                                ),
                                child: Slider(
                                  value: progress.toDouble(),
                                  min: 0,
                                  max: widget.controller.value.duration.inMicroseconds.toDouble(),
                                  onChanged: (value) async {
                                    setState(() {
                                      progress = value.toInt();
                                    });
                                  },
                                  onChangeEnd: (value) async {
                                    if (value == widget.controller.value.duration.inMicroseconds.toDouble()) {
                                      await widget.controller.seekTo(Duration(microseconds: value.toInt() - 1));
                                    } else {
                                      await widget.controller.seekTo(Duration(microseconds: value.toInt()));
                                    }
                                    await widget.controller.play();
                                  },
                                  onChangeStart: (value) async {
                                    await widget.controller.pause();
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${getFormattedDuration(widget.controller.value.position)}/${getFormattedDuration(widget.controller.value.duration)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (orientation == Orientation.portrait) {
                                  setLandscape();
                                } else {
                                  restoreLandscape();
                                }
                                // Navigator.of(context).pop();
                              },
                              child: Icon(
                                orientation == Orientation.portrait
                                    ? MdiIcons.phoneRotateLandscape
                                    : MdiIcons.phoneRotatePortrait,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await restoreLandscape();
                                if (!mounted) return;
                                Navigator.of(context).pop();
                              },
                              child: const Icon(
                                Icons.fullscreen_exit,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (widget.controller.value.isBuffering)
                    const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
