import 'package:flutter/material.dart';

import '../core/api/atmos_api.dart';
import '../core/config/device_config.dart';
import '../core/models/dorian_player_state.dart';
import '../widgets/artwork_view.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({
    super.key,
    AtmosApi? api,
    int? dorianId,
  })  : _api = api,
        _dorianId = dorianId;

  final AtmosApi? _api;
  final int? _dorianId;

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late final AtmosApi _api = widget._api ?? AtmosApi();
  bool _loading = true;
  DorianPlayerState? _state;
  bool _offline = false;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    try {
      final dorianId = widget._dorianId ?? (await DeviceConfig.load()).dorianId;
      final state = await _api.fetchPlayerState(dorianId);

      if (!mounted) return;
      setState(() {
        _loading = false;
        _state = state;
        _offline = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _state = null;
        _offline = true;
      });
    }
  }

  @override
  void dispose() {
    if (widget._api == null) {
      _api.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final artwork = _state?.dorian.currentArtwork;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (artwork != null)
            ArtworkView(key: ValueKey(artwork.id), artwork: artwork)
          else if (_loading)
            const Center(
              child: CircularProgressIndicator(color: Colors.white54, strokeWidth: 2),
            )
          else
            const Center(
              child: Text(
                'No artwork',
                style: TextStyle(color: Colors.white38, fontSize: 16),
              ),
            ),
          if (_offline)
            const Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Text(
                'Offline',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white38, fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }
}
