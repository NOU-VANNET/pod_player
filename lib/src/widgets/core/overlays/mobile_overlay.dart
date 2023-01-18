part of 'package:pod_player/src/pod_player.dart';

class _MobileOverlay extends StatelessWidget {
  final List<OptionTile>? options;
  final String tag;
  final void Function()? toggleVideoFit;
  final void Function()? onBack;

  const _MobileOverlay({
    Key? key,
    required this.tag,
    this.options,
    this.toggleVideoFit,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const overlayColor = Colors.black38;
    const itemColor = Colors.white;
    final _podCtr = Get.find<PodGetXVideoController>(tag: tag);
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: _VideoGestureDetector(
                  tag: tag,
                  onDoubleTap: _isRtl()
                      ? _podCtr.onRightDoubleTap
                      : _podCtr.onLeftDoubleTap,
                  child: ColoredBox(
                    color: overlayColor,
                    child: _LeftRightDoubleTapBox(
                      tag: tag,
                      isLeft: true,
                    ),
                  ),
                ),
              ),
              _VideoGestureDetector(
                tag: tag,
                child: ColoredBox(
                  color: overlayColor,
                  child: SizedBox(
                    height: double.infinity,
                    child: Center(
                      child: _AnimatedPlayPauseIcon(tag: tag, size: 42),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _VideoGestureDetector(
                  tag: tag,
                  onDoubleTap: _isRtl()
                      ? _podCtr.onLeftDoubleTap
                      : _podCtr.onRightDoubleTap,
                  child: ColoredBox(
                    color: overlayColor,
                    child: _LeftRightDoubleTapBox(
                      tag: tag,
                      isLeft: false,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialIconButton(
                    toolTipMesg: _podCtr.podPlayerLabels.settings,
                    color: itemColor,
                    onPressed: () {
                      if (onBack != null) {
                        onBack!();
                      }
                    },
                    child: const Icon(
                      Icons.arrow_back,
                    ),
                  ),
                  Expanded(
                    child: IgnorePointer(
                      child: _podCtr.videoTitle ?? const SizedBox(),
                    ),
                  ),
                  MaterialIconButton(
                    toolTipMesg: _podCtr.podPlayerLabels.settings,
                    color: itemColor,
                    onPressed: () {
                      if (_podCtr.isOverlayVisible) {
                        _bottomSheet(context, ops: options);
                      } else {
                        _podCtr.toggleVideoOverlay();
                      }
                    },
                    child: const Icon(
                      Icons.more_vert_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: _MobileOverlayBottomController(
                tag: tag,
                toggleVideoFit: toggleVideoFit,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isRtl() {
    return false;
  }

  void _bottomSheet(BuildContext context, {List<OptionTile>? ops}) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _MobileBottomSheet(tag: tag, options: ops),
    );
  }
}

class _LeftRightDoubleTapBox extends StatelessWidget {
  final String tag;
  final bool isLeft;
  const _LeftRightDoubleTapBox({
    Key? key,
    required this.tag,
    required this.isLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PodGetXVideoController>(
      tag: tag,
      id: 'double-tap',
      builder: (_podCtr) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _podCtr.isLeftDbTapIconVisible && isLeft
                ? 1
                : _podCtr.isRightDbTapIconVisible && !isLeft
                    ? 1
                    : 0,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Lottie.asset(
                    isLeft
                        ? 'packages/pod_player/assets/forward_left.json'
                        : 'packages/pod_player/assets/forward_right.json',
                  ),
                  if (isLeft
                      ? _podCtr.isLeftDbTapIconVisible
                      : _podCtr.isRightDbTapIconVisible)
                    Transform.translate(
                      offset: const Offset(0, 40),
                      child: Text(
                        '${_podCtr.isLeftDbTapIconVisible ? _podCtr.leftDoubleTapduration : _podCtr.rightDubleTapduration} Sec',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
