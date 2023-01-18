part of 'package:pod_player/src/pod_player.dart';

class _WebSettingsDropdown extends StatefulWidget {
  final String tag;
  final List<OptionTile>? options;

  const _WebSettingsDropdown({
    Key? key,
    required this.tag,
    this.options,
  }) : super(key: key);

  @override
  State<_WebSettingsDropdown> createState() => _WebSettingsDropdownState();
}

class _WebSettingsDropdownState extends State<_WebSettingsDropdown> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        focusColor: Colors.white,
        selectedRowColor: Colors.white,
      ),
      child: GetBuilder<PodGetXVideoController>(
        tag: widget.tag,
        builder: (_podCtr) {
          return MaterialIconButton(
            toolTipMesg: _podCtr.podPlayerLabels.settings,
            color: Colors.white,
            child: const Icon(Icons.settings),
            onPressed: () => _podCtr.isFullScreen
                ? _podCtr.isWebPopupOverlayOpen = true
                : _podCtr.isWebPopupOverlayOpen = false,
            onTapDown: (details) async {
              final _settingsMenu = await showMenu<String>(
                context: context,
                items: widget.options != null ?
                List.generate(widget.options!.length, (idx) {
                  return PopupMenuItem(
                    value: widget.options![idx].title,
                    child: widget.options![idx],
                  );
                }) : [
                  if (_podCtr.vimeoOrVideoUrls.isNotEmpty)
                    PopupMenuItem(
                      value: 'OUALITY',
                      child: OptionTile(
                        title: _podCtr.podPlayerLabels.quality,
                        icon: Icons.video_settings_rounded,
                        subText: '${_podCtr.vimeoPlayingVideoQuality}p',
                      ),
                    ),
                  PopupMenuItem(
                    value: 'LOOP',
                    child: OptionTile(
                      title: _podCtr.podPlayerLabels.loopVideo,
                      icon: Icons.loop_rounded,
                      subText: _podCtr.isLooping
                          ? _podCtr.podPlayerLabels.optionEnabled
                          : _podCtr.podPlayerLabels.optionDisabled,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'SPEED',
                    child: OptionTile(
                      title: _podCtr.podPlayerLabels.playbackSpeed,
                      icon: Icons.slow_motion_video_rounded,
                      subText: _podCtr.currentPaybackSpeed,
                    ),
                  ),
                ],
                position: RelativeRect.fromSize(
                  details.globalPosition & Size.zero,
                  MediaQuery.of(context).size,
                ),
              );
              switch (_settingsMenu) {
                case 'OUALITY':
                  await _onVimeoQualitySelect(details, _podCtr);
                  break;
                case 'SPEED':
                  await _onPlaybackSpeedSelect(details, _podCtr);
                  break;
                case 'LOOP':
                  _podCtr.isWebPopupOverlayOpen = false;
                  await _podCtr.toggleLooping();
                  break;
                default:
                  _podCtr.isWebPopupOverlayOpen = false;
              }
            },
          );
        },
      ),
    );
  }

  Future<void> _onPlaybackSpeedSelect(
    TapDownDetails details,
    PodGetXVideoController _podCtr,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 400),
    );
    await showMenu(
      context: context,
      items: _podCtr.videoPlaybackSpeeds
          .map(
            (e) => PopupMenuItem(
              child: ListTile(
                title: Text(e),
              ),
              onTap: () {
                _podCtr.setVideoPlayBack(e);
              },
            ),
          )
          .toList(),
      position: RelativeRect.fromSize(
        details.globalPosition & Size.zero,
        // ignore: use_build_context_synchronously
        MediaQuery.of(context).size,
      ),
    );
    _podCtr.isWebPopupOverlayOpen = false;
  }

  Future<void> _onVimeoQualitySelect(
    TapDownDetails details,
    PodGetXVideoController _podCtr,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 400),
    );
    await showMenu(
      context: context,
      items: _podCtr.vimeoOrVideoUrls
          .map(
            (e) => PopupMenuItem(
              child: ListTile(
                title: Text('${e.quality}p'),
              ),
              onTap: () {
                _podCtr.changeVideoQuality(
                  e.quality,
                );
              },
            ),
          )
          .toList(),
      position: RelativeRect.fromSize(
        details.globalPosition & Size.zero,
        // ignore: use_build_context_synchronously
        MediaQuery.of(context).size,
      ),
    );
    _podCtr.isWebPopupOverlayOpen = false;
  }

}
