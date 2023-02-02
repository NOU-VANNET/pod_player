part of 'package:pod_player/src/pod_player.dart';

class _MobileBottomSheet extends StatelessWidget {
  final List<Widget>? options;
  final String tag;

  const _MobileBottomSheet({
    Key? key,
    required this.tag,
    this.options,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PodGetXVideoController>(
      tag: tag,
      builder: (_podCtr) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: options ??
              [
                if (_podCtr.vimeoOrVideoUrls.isNotEmpty)
                  OptionTile(
                    title: _podCtr.podPlayerLabels.quality,
                    icon: Icons.video_settings_rounded,
                    subText: '${_podCtr.vimeoPlayingVideoQuality}p',
                    onTap: () {
                      Navigator.of(context).pop();
                      Timer(const Duration(milliseconds: 100), () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => _VideoQualitySelectorMob(
                            tag: tag,
                            onTap: null,
                          ),
                        );
                      });
                      // await Future.delayed(
                      //   const Duration(milliseconds: 100),
                      // );
                    },
                  ),
                OptionTile(
                  title: _podCtr.podPlayerLabels.loopVideo,
                  icon: Icons.loop_rounded,
                  subText: _podCtr.isLooping
                      ? _podCtr.podPlayerLabels.optionEnabled
                      : _podCtr.podPlayerLabels.optionDisabled,
                  onTap: () {
                    Navigator.of(context).pop();
                    _podCtr.toggleLooping();
                  },
                ),
                OptionTile(
                  title: _podCtr.podPlayerLabels.playbackSpeed,
                  icon: Icons.slow_motion_video_rounded,
                  subText: _podCtr.currentPaybackSpeed,
                  onTap: () {
                    Navigator.of(context).pop();
                    Timer(const Duration(milliseconds: 100), () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => _VideoPlaybackSelectorMob(
                          tag: tag,
                          onTap: null,
                        ),
                      );
                    });
                  },
                ),
              ],
        ),
      ),
    );
  }
}

class _VideoQualitySelectorMob extends StatelessWidget {
  final void Function()? onTap;
  final String tag;

  const _VideoQualitySelectorMob({
    Key? key,
    required this.onTap,
    required this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _podCtr = Get.find<PodGetXVideoController>(tag: tag);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _podCtr.vimeoOrVideoUrls
            .map(
              (e) => ListTile(
                title: Text('${e.quality}p'),
                onTap: () {
                  onTap != null ? onTap!() : Navigator.of(context).pop();

                  _podCtr.changeVideoQuality(e.quality);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class _VideoPlaybackSelectorMob extends StatelessWidget {
  final void Function()? onTap;
  final String tag;

  const _VideoPlaybackSelectorMob({
    Key? key,
    required this.onTap,
    required this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _podCtr = Get.find<PodGetXVideoController>(tag: tag);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _podCtr.videoPlaybackSpeeds
            .map(
              (e) => ListTile(
                title: Text(e),
                onTap: () {
                  onTap != null ? onTap!() : Navigator.of(context).pop();
                  _podCtr.setVideoPlayBack(e);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class _MobileOverlayBottomController extends StatelessWidget {
  final String tag;
  final void Function()? toggleVideoFit;
  final void Function(Duration)? onDragSeek;

  const _MobileOverlayBottomController({
    Key? key,
    required this.tag,
    this.onDragSeek,
    this.toggleVideoFit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const durationTextStyle = TextStyle(color: Colors.white70);
    const itemColor = Colors.white;

    return GetBuilder<PodGetXVideoController>(
      tag: tag,
      id: 'full-screen',
      builder: (_podCtr) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(width: 12),
              GetBuilder<PodGetXVideoController>(
                tag: tag,
                id: 'video-progress',
                builder: (_podCtr) {
                  return Row(
                    children: [
                      Text(
                        _podCtr.calculateVideoDuration(_podCtr.videoPosition),
                        style: const TextStyle(color: itemColor),
                      ),
                      const Text(
                        ' / ',
                        style: durationTextStyle,
                      ),
                      Text(
                        _podCtr.calculateVideoDuration(_podCtr.videoDuration),
                        style: durationTextStyle,
                      ),
                    ],
                  );
                },
              ),
              const Spacer(),
              if (toggleVideoFit != null)
                MaterialIconButton(
                  toolTipMesg: 'Video Fit', // _podCtr.isFullScreen
                  //     ? _podCtr.podPlayerLabels.exitFullScreen ??
                  //         'Exit full screen${kIsWeb ? ' (f)' : ''}'
                  //     : _podCtr.podPlayerLabels.fullscreen ??
                  //         'Fullscreen${kIsWeb ? ' (f)' : ''}',
                  color: itemColor,
                  onPressed: () {
                    toggleVideoFit!();
                    // if (_podCtr.isOverlayVisible) {
                    //   if (_podCtr.isFullScreen) {
                    //     _podCtr.disableFullScreen(context, tag);
                    //   } else {
                    //     _podCtr.enableFullScreen(tag);
                    //   }
                    // } else {
                    //   _podCtr.toggleVideoOverlay();
                    // }
                  },
                  child: Icon(
                    _podCtr.isFullScreen
                        ? Icons.fullscreen_exit
                        : Icons.fullscreen,
                  ),
                ),
            ],
          ),
          GetBuilder<PodGetXVideoController>(
            tag: tag,
            id: 'overlay',
            builder: (_podCtr) {
              if (_podCtr.isFullScreen) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                  child: Visibility(
                    visible: _podCtr.isOverlayVisible,
                    child: PodProgressBar(
                      tag: tag,
                      alignment: Alignment.topCenter,
                      podProgressBarConfig: _podCtr.podProgressBarConfig,
                      onDragSeek: (position) {
                        onDragSeek?.call(position);
                      },
                    ),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                child: PodProgressBar(
                  tag: tag,
                  alignment: Alignment.bottomCenter,
                  podProgressBarConfig: _podCtr.podProgressBarConfig,
                  onDragSeek: (position) {
                    onDragSeek?.call(position);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
