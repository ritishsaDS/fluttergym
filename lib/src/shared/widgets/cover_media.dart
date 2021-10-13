import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CoverMedia extends StatefulWidget {
  const CoverMedia({
    required this.data,
    Key? key,
  }) : super(key: key);

  final List<String> data;

  @override
  State<CoverMedia> createState() => _CoverMediaState();
}

class _CoverMediaState extends State<CoverMedia> {
  final _controllers = <String, VideoPlayerController>{};

  @override
  void initState() {
    super.initState();
    for (var item in widget.data) {
      if (!item.endsWith('.jpg') && !item.endsWith('.png')) {
        _controllers[item] = VideoPlayerController.network(item)
          ..initialize().then((value) => setState(() {}));
      }
    }
  }

  @override
  void dispose() {
    _controllers.forEach((key, value) => value.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: PageView.builder(
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          var item = widget.data[index];

          if (_controllers.containsKey(item)) {
            return Stack(
              children: [
                VideoPlayer(_controllers[item]!),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      child: IconButton(
                        onPressed: () {
                          var controller = _controllers[item]!;
                          setState(() {
                            controller.value.isPlaying
                                ? controller.pause()
                                : controller.play();
                          });
                        },
                        iconSize: 64,
                        color: _controllers[item]!.value.isPlaying
                            ? Colors.transparent
                            : Colors.white,
                        icon: Icon(
                          _controllers[item]!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Image.network(
            item,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
