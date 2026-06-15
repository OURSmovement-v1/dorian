import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dorian_app/core/api/atmos_api.dart';
import 'package:dorian_app/core/models/dorian_player_state.dart';
import 'package:dorian_app/screens/landing_screen.dart';
import 'package:dorian_app/widgets/artwork_view.dart';

class _FakeAtmosApi extends AtmosApi {
  _FakeAtmosApi(this._state, {this.shouldFail = false});

  final DorianPlayerState? _state;
  final bool shouldFail;

  @override
  Future<DorianPlayerState> fetchPlayerState(
    int dorianId, {
    bool bustCache = false,
  }) async {
    if (shouldFail) {
      throw Exception('network error');
    }
    return _state!;
  }
}

DorianPlayerState _sampleState({String? artworkTitle}) {
  return DorianPlayerState(
    dorian: Dorian(
      id: 1,
      name: 'Living room',
      isConnected: true,
      currentArtwork: artworkTitle == null
          ? null
          : Artwork(
              id: 5,
              title: artworkTitle,
              autorName: 'Artist',
              type: 'still',
              artworkUrl: '/atelier_artworks/sample.jpg',
            ),
    ),
  );
}

void main() {
  testWidgets('Renders artwork when available', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LandingScreen(
          dorianId: 1,
          api: _FakeAtmosApi(_sampleState(artworkTitle: 'Sunset')),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(ArtworkView), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('Shows no artwork placeholder when none assigned', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LandingScreen(
          dorianId: 1,
          api: _FakeAtmosApi(_sampleState()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No artwork'), findsOneWidget);
  });

  testWidgets('Shows offline when API fails', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LandingScreen(
          dorianId: 1,
          api: _FakeAtmosApi(null, shouldFail: true),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Offline'), findsOneWidget);
  });
}
