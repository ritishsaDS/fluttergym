import 'package:flutter/material.dart';
import 'package:powerdope_models/models.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExerciseListTile extends StatefulWidget {
  const ExerciseListTile(
    this.data, {
    this.buttons = const <Widget>[],
    Key? key,
  }) : super(key: key);

  final Exercise data;

  final List<Widget> buttons;

  @override
  State<ExerciseListTile> createState() => _ExerciseListTileState();
}

class _ExerciseListTileState extends State<ExerciseListTile> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    var id = YoutubePlayer.convertUrlToId(widget.data.link ?? '');
    if (id != null) {
      _controller = YoutubePlayerController(initialVideoId: id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _controller != null
                ? YoutubePlayer(
                    controller: _controller!,
                    bottomActions: [
                      CurrentPosition(),
                      ProgressBar(isExpanded: true),
                    ],
                  )
                : const Center(
                    child: Text('Invalid URL'),
                  ),
          ),
          ButtonBar(
            children: [
              IconButton(
                onPressed: () {
                  // TODO(backend): Liking exercise API is not implemented.
                },
                icon: const Icon(Icons.thumb_up_sharp),
              ),
              IconButton(
                onPressed: () {
                  // TODO(backend): Disliking exercise API is not implemented.
                },
                icon: const Icon(Icons.thumb_down_sharp),
              ),
              IconButton(
                onPressed: () {
                  Share.share(
                    'Check out this exercise: ${widget.data.link}',
                    subject: 'Look what I made!',
                  );
                },
                icon: const Icon(Icons.share),
              ),
              ...widget.buttons,
            ],
          ),
        ],
      ),
    );
  }
}
