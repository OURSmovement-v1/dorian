import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../core/config/api_config.dart';
import '../core/models/dorian_player_state.dart';

class ArtworkView extends StatelessWidget {
  const ArtworkView({super.key, required this.artwork});

  final Artwork artwork;

  @override
  Widget build(BuildContext context) {
    final url = ApiConfig.mediaUrl(artwork.artworkUrl);

    if (artwork.type == 'motion') {
      return MotionArtworkView(url: url);
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      gaplessPlayback: true,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(
          child: CircularProgressIndicator(color: Colors.white54, strokeWidth: 2),
        );
      },
      errorBuilder: (_, __, ___) => const _ArtworkError(),
    );
  }
}

class MotionArtworkView extends StatefulWidget {
  const MotionArtworkView({super.key, required this.url});

  final String url;

  @override
  State<MotionArtworkView> createState() => _MotionArtworkViewState();
}

class _MotionArtworkViewState extends State<MotionArtworkView> {
  late final VideoPlayerController _controller;
  bool _ready = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _ready = true);
        _controller
          ..setLooping(true)
          ..play();
      }).catchError((_) {
        if (!mounted) return;
        setState(() => _failed = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) return const _ArtworkError();

    if (!_ready) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white54, strokeWidth: 2),
      );
    }

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: _controller.value.size.width,
        height: _controller.value.size.height,
        child: VideoPlayer(_controller),
      ),
    );
  }
}

class _ArtworkError extends StatelessWidget {
  const _ArtworkError();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.broken_image_outlined, color: Colors.white24, size: 48),
    );
  }
}
