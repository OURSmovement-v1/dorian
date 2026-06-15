import '../models/dorian_player_state.dart';
import 'api_client.dart';

class AtmosApi {
  AtmosApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<DorianPlayerState> fetchPlayerState(
    int dorianId, {
    bool bustCache = false,
  }) async {
    final data = await _client.getJson(
      '/api/player/$dorianId',
      query: bustCache
          ? {'t': DateTime.now().millisecondsSinceEpoch.toString()}
          : null,
    );

    return DorianPlayerState.fromJson(data);
  }

  void dispose() => _client.dispose();
}
