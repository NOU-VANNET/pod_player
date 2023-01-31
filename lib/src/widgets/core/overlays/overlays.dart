part of 'package:pod_player/src/pod_player.dart';

class _VideoOverlays extends StatelessWidget {
  final List<Widget>? options;
  final String tag;
  final void Function()? toggleVideoFit;
  final void Function()? onBack;

  const _VideoOverlays({
    Key? key,
    required this.tag,
    this.options,
    this.toggleVideoFit,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _podCtr = Get.find<PodGetXVideoController>(tag: tag);
    if (_podCtr.overlayBuilder != null) {
      return GetBuilder<PodGetXVideoController>(
        id: 'update-all',
        tag: tag,
        builder: (_podCtr) {
          ///Custom overlay
          final _progressBar = PodProgressBar(
            tag: tag,
            podProgressBarConfig: _podCtr.podProgressBarConfig,
          );
          final overlayOptions = OverLayOptions(
            podVideoState: _podCtr.podVideoState,
            videoDuration: _podCtr.videoDuration,
            videoPosition: _podCtr.videoPosition,
            isFullScreen: _podCtr.isFullScreen,
            isLooping: _podCtr.isLooping,
            isOverlayVisible: _podCtr.isOverlayVisible,
            isMute: _podCtr.isMute,
            autoPlay: _podCtr.autoPlay,
            currentVideoPlaybackSpeed: _podCtr.currentPaybackSpeed,
            videoPlayBackSpeeds: _podCtr.videoPlaybackSpeeds,
            videoPlayerType: _podCtr.videoPlayerType,
            podProgresssBar: _progressBar,
          );

          /// Returns the custom overlay, otherwise returns the default
          /// overlay with gesture detector
          return _podCtr.overlayBuilder!(overlayOptions);
        },
      );
    } else {
      ///Built in overlay
      return GetBuilder<PodGetXVideoController>(
        tag: tag,
        id: 'overlay',
        builder: (_podCtr) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _podCtr.isOverlayVisible ? 1 : 0,
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                _MobileOverlay(
                  tag: tag, 
                  options: options, 
                  toggleVideoFit: toggleVideoFit, 
                  onBack: onBack,
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
