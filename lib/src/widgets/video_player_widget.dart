import 'dart:io';
import 'package:flutter/material.dart';
import 'package:reddit_app/src/helpers/general.dart';
import 'package:rxdart/rxdart.dart';
import '/src/helpers/enums.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final VideoType type;
  final EdgeInsetsGeometry videoPadding;
  final bool autoPlay;
  final bool muted;
  final bool looping;
  final bool witchCache;
  final VideoPlayerController controller;
  const VideoPlayerWidget({
    required this.url,
    required this.controller,
    this.type = VideoType.network,
    this.videoPadding = const EdgeInsets.all(0),
    this.autoPlay = true,
    this.muted = true,
    this.looping = true,
    this.witchCache = false,
    super.key,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  // bool initialized = false;
  bool error = false;
  // VideoPlayerController? controller;

  final BehaviorSubject<int> progressController = BehaviorSubject<int>.seeded(0);
  final BehaviorSubject<bool> isInitializedController = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> isPlayingController = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> isBufferingController = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<double> volumeController = BehaviorSubject<double>.seeded(0);

  VideoPlayerController? get controller => widget.controller;

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
        // controller = await getController();
        await controller?.initialize();
        if (widget.muted) await controller?.setVolume(volumeController.value);
        if (widget.autoPlay) await controller?.play();
        if (widget.looping) await controller?.setLooping(widget.looping);
        controller?.addListener(controllerListener);
      } catch (e) {
        setState(() {
          error = true;
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
          return VideoPlayerController.network(
            widget.url,
            videoPlayerOptions: VideoPlayerOptions(
              allowBackgroundPlayback: true,
              mixWithOthers: true,
            ),
          );
        }
      case VideoType.asset:
        return VideoPlayerController.asset(
          widget.url,
          videoPlayerOptions: VideoPlayerOptions(
            allowBackgroundPlayback: true,
            mixWithOthers: true,
          ),
        );
      case VideoType.file:
        return VideoPlayerController.file(
          File(
            widget.url,
          ),
          videoPlayerOptions: VideoPlayerOptions(
            allowBackgroundPlayback: true,
            mixWithOthers: true,
          ),
        );
      default:
        return null;
    }
  }

  @override
  void dispose() async {
    controller?.removeListener(controllerListener);
    super.dispose();
    await controller?.dispose();
  }

  void controllerListener() {
    if (controller == null) return;
    progressController.add(controller!.value.position.inMicroseconds);
    isInitializedController.add(controller!.value.isInitialized);
    isPlayingController.add(controller!.value.isPlaying);
    isBufferingController.add(controller!.value.isBuffering);
    volumeController.add(controller!.value.volume);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (controller != null) {
          if (controller!.value.isPlaying) {
            await controller?.pause();
          } else {
            await controller?.play();
          }
        }
      },
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return ClipRRect(
          child: Container(
            color: Colors.transparent,
            width: constraints.maxWidth,
            height: constraints.maxHeight == double.infinity ? constraints.maxWidth : constraints.maxHeight,
            child: StreamBuilder<bool>(
                stream: isInitializedController,
                builder: (context, isInitialized) {
                  return Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      if ((isInitialized.data ?? false) && !error) ...[
                        if (isInitialized.data ?? true) ...[
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
                          // if (isInitialized.data ?? true) ...[
                          //   StreamBuilder<bool>(
                          //       stream: isPlayingController,
                          //       builder: (context, isPlayingData) {
                          //         return StreamBuilder<bool>(
                          //             stream: isBufferingController,
                          //             builder: (context, isBufferingData) {
                          //               return Container(
                          //                 alignment: Alignment.center,
                          //                 color: !(isPlayingData.data ?? true) && !(isBufferingData.data ?? true)
                          //                     ? Colors.black45
                          //                     : null,
                          //                 child: !(isPlayingData.data ?? true) && !(isBufferingData.data ?? true)
                          //                     ? const Icon(
                          //                         Icons.play_arrow,
                          //                         size: 50,
                          //                       )
                          //                     : null,
                          //               );
                          //             });
                          //       }),
                          // ],
                          if (controller!.value.isBuffering)
                            const Center(
                              child: CircularProgressIndicator(),
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
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  );
                }),
          ),
        );
      }),
    );
  }
}

class VideoControls extends StatefulWidget {
  final VideoPlayerController? controller;
  const VideoControls(this.controller, {super.key});

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  final BehaviorSubject<int> progressController = BehaviorSubject<int>.seeded(0);
  final BehaviorSubject<bool> isInitializedController = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> isPlayingController = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> isBufferingController = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<double> volumeController = BehaviorSubject<double>.seeded(0);

  VideoPlayerController? get controller => widget.controller;

  @override
  void initState() {
    controller?.addListener(controllerListener);
    super.initState();
  }

  @override
  void dispose() async {
    controller?.removeListener(controllerListener);
    super.dispose();
    // await controller?.dispose();
  }

  void controllerListener() {
    if (controller == null) return;
    progressController.add(controller!.value.position.inMicroseconds);
    isInitializedController.add(controller!.value.isInitialized);
    isPlayingController.add(controller!.value.isPlaying);
    isBufferingController.add(controller!.value.isBuffering);
    volumeController.add(controller!.value.volume);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 5,
      left: 0,
      right: 0,
      child: StreamBuilder<bool>(
          stream: isInitializedController,
          initialData: false,
          builder: (context, isInitialized) {
            if (isInitialized.data == false) {
              return const SizedBox.shrink();
            }
            return Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () async {
                    if (controller != null && controller!.value.isInitialized && !controller!.value.isBuffering) {
                      if (!controller!.value.isPlaying) {
                        await controller?.play();
                      } else {
                        await controller?.pause();
                      }
                    }
                  },
                  child: StreamBuilder<bool>(
                      stream: isPlayingController,
                      builder: (context, isPlayingData) {
                        return Icon(
                          size: 30,
                          color: Colors.white,
                          !(isPlayingData.data ?? false) ? Icons.play_arrow : Icons.pause,
                        );
                      }),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.grey,
                      trackShape: const RoundedRectSliderTrackShape(),
                      trackHeight: 1.5,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 18,
                        elevation: 0,
                        pressedElevation: 0,
                      ),
                      thumbColor: Colors.transparent,
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                      tickMarkShape: const RoundSliderTickMarkShape(),
                      valueIndicatorTextStyle: const TextStyle(color: Colors.white),
                    ),
                    child: StreamBuilder<int>(
                        stream: progressController,
                        builder: (context, snapshot) {
                          return Slider(
                            value: (snapshot.data ?? 0).toDouble(),
                            min: 0,
                            max: controller!.value.duration.inMicroseconds.toDouble(),
                            onChanged: (value) {
                              progressController.add(value.toInt());
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
                  },
                  child: StreamBuilder<double>(
                      stream: volumeController,
                      builder: (context, volume) {
                        return Ink(
                          child: Icon(
                            volume.data == 0 ? Icons.volume_off : Icons.volume_up,
                            size: 23,
                            color: Colors.white,
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            );
          }),
    );
  }
}
