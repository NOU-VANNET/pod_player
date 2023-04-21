part of 'package:pod_player/src/pod_player.dart';

class _PodCoreVideoPlayer extends StatelessWidget {
  final VideoPlayerController videoPlayerCtr;
  final double videoAspectRatio;
  final String tag;
  final List<Widget>? options;
  final VideoFit fit;
  final Widget? videoOverlay;
  final void Function()? toggleVideoFit;
  final void Function()? onBack;
  final Widget? backButton;

  final void Function(Duration)? onDragSeek;
  final void Function(PodVideoState)? onPlayPause;

  final bool showOptions;

  const _PodCoreVideoPlayer({
    Key? key,
    required this.videoPlayerCtr,
    required this.videoAspectRatio,
    required this.tag,
    this.options,
    this.fit = VideoFit.contain,
    this.toggleVideoFit,
    this.videoOverlay,
    this.onBack,
    this.onDragSeek,
    this.onPlayPause,
    this.showOptions = true,
    this.backButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _podCtr = Get.find<PodGetXVideoController>(tag: tag);
    return Builder(
      builder: (ctr) {
        return RawKeyboardListener(
          autofocus: true,
          focusNode:
              (_podCtr.isFullScreen ? FocusNode() : _podCtr.keyboardFocusWeb) ??
                  FocusNode(),
          onKey: (value) => _podCtr.onKeyBoardEvents(
            event: value,
            appContext: ctr,
            tag: tag,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (fit == VideoFit.contain)
                Center(
                  child: AspectRatio(
                    aspectRatio: videoAspectRatio,
                    child: VideoPlayer(videoPlayerCtr),
                  ),
              ),
              if (fit == VideoFit.cover)
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      height: videoPlayerCtr.value.size.height,
                      width: videoPlayerCtr.value.size.width,
                      child: VideoPlayer(videoPlayerCtr),
                    ),
                  ),
                ),
              GetBuilder<PodGetXVideoController>(
                tag: tag,
                id: 'podVideoState',
                builder: (_) => GetBuilder<PodGetXVideoController>(
                  tag: tag,
                  id: 'video-progress',
                  builder: (_podCtr) {
                    if (_podCtr.videoThumbnail == null) {
                      return const SizedBox();
                    }

                    if (_podCtr.podVideoState == PodVideoState.paused &&
                        _podCtr.videoPosition == Duration.zero) {
                      return SizedBox.expand(
                        child: TweenAnimationBuilder<double>(
                          builder: (context, value, child) => Opacity(
                            opacity: value,
                            child: child,
                          ),
                          tween: Tween<double>(begin: 0.7, end: 1),
                          duration: const Duration(milliseconds: 400),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              image: _podCtr.videoThumbnail,
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              videoOverlay ?? const SizedBox.shrink(),
              _VideoOverlays(
                tag: tag,
                options: options,
                toggleVideoFit: toggleVideoFit,
                onBack: onBack,
                onPlayPause: onPlayPause,
                onDragSeek: onDragSeek,
                showOptions: showOptions,
                backButton: backButton,
              ),
              IgnorePointer(
                child: GetBuilder<PodGetXVideoController>(
                  tag: tag,
                  id: 'podVideoState',
                  builder: (_podCtr) {
                    final loadingWidget = _podCtr.onLoading?.call(context) ??
                        const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.transparent,
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        );

                    if (kIsWeb) {
                      switch (_podCtr.podVideoState) {
                        case PodVideoState.loading:
                          return loadingWidget;
                        case PodVideoState.paused:
                          return const Center(
                            child: Icon(
                              Icons.play_arrow,
                              size: 45,
                              color: Colors.white,
                            ),
                          );
                        case PodVideoState.playing:
                          return Center(
                            child: TweenAnimationBuilder<double>(
                              builder: (context, value, child) => Opacity(
                                opacity: value,
                                child: child,
                              ),
                              tween: Tween<double>(begin: 1, end: 0),
                              duration: const Duration(seconds: 1),
                              child: const Icon(
                                Icons.pause,
                                size: 45,
                                color: Colors.white,
                              ),
                            ),
                          );
                        case PodVideoState.error:
                          return const SizedBox();
                      }
                    } else {
                      if (_podCtr.podVideoState == PodVideoState.loading) {
                        return loadingWidget;
                      }
                      return const SizedBox();
                    }
                  },
                ),
              ),
              if (!kIsWeb)
                GetBuilder<PodGetXVideoController>(
                  tag: tag,
                  id: 'full-screen',
                  builder: (_podCtr) => _podCtr.isFullScreen
                      ? const SizedBox()
                      : GetBuilder<PodGetXVideoController>(
                          tag: tag,
                          id: 'overlay',
                          builder: (_podCtr) => _podCtr.isOverlayVisible ||
                                  !_podCtr.alwaysShowProgressBar
                              ? const SizedBox()
                              : Align(
                                  alignment: Alignment.bottomCenter,
                                  child: PodProgressBar(
                                    tag: tag,
                                    alignment: Alignment.bottomCenter,
                                    podProgressBarConfig:
                                        _podCtr.podProgressBarConfig,
                                  ),
                                ),
                        ),
                ),
            ],
          ),
        );
      },
    );
  }
}
