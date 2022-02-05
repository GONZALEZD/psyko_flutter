import 'dart:ui';

class Level {
  final String id;
  final String _titleFr;
  final String _titleEn;
  final String location;
  final String puzzle;
  final String thumbnail;

  String getTitle(Locale locale) {
    if (locale.languageCode.toLowerCase().contains("fr")) {
      return _titleFr;
    }
    return _titleEn;
  }

  String fullName(Locale locale) => "$id. ${getTitle(locale)}";

  Level(
      {required this.id,
      required this.location,
      required String titleFr,
      required String titleEn,
      required this.puzzle,
      required this.thumbnail,
      })
      : _titleFr = titleFr,
        _titleEn = titleEn;

  @override
  String toString() {
    final params = {
      'id': id,
      'location': location,
      'titleFR': _titleFr,
      'titleEN': _titleEn,
      'puzzle': puzzle,
      'thumbnail': thumbnail,
    };
    return "$Level($params)";
  }

  @override
  int get hashCode => Object.hash(id, location, puzzle, _titleFr, _titleEn, thumbnail);

  @override
  bool operator ==(Object other) {
    if (other is Level) {
      return id == other.id &&
          location == other.location &&
          puzzle == other.puzzle &&
          _titleFr == other._titleFr &&
          _titleEn == _titleEn &&
          thumbnail == other.thumbnail;
    }
    return false;
  }
}
