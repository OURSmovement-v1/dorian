class Artwork {
  Artwork({
    required this.id,
    required this.title,
    required this.autorName,
    required this.type,
    required this.artworkUrl,
  });

  final int id;
  final String title;
  final String autorName;
  final String type;
  final String artworkUrl;

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      autorName: json['autorName'] as String? ?? '',
      type: json['type'] as String? ?? 'still',
      artworkUrl: json['artworkUrl'] as String? ?? '',
    );
  }
}

class Dorian {
  Dorian({
    required this.id,
    required this.name,
    required this.isConnected,
    required this.currentArtwork,
  });

  final int id;
  final String name;
  final bool isConnected;
  final Artwork? currentArtwork;

  factory Dorian.fromJson(Map<String, dynamic> json) {
    final artwork = json['currentArtwork'];

    return Dorian(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      isConnected: json['isConnected'] as bool? ?? false,
      currentArtwork: artwork == null
          ? null
          : Artwork.fromJson(artwork as Map<String, dynamic>),
    );
  }
}

class DorianPlayerState {
  DorianPlayerState({required this.dorian});

  final Dorian dorian;

  factory DorianPlayerState.fromJson(Map<String, dynamic> json) {
    return DorianPlayerState(
      dorian: Dorian.fromJson(json['dorian'] as Map<String, dynamic>),
    );
  }
}
