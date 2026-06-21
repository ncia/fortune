class TarotDetailData {
  final String id; // e.g., 'major_00', 'swords_02'
  final TarotDirectionDetail upright;
  final TarotDirectionDetail reversed;

  TarotDetailData({
    required this.id,
    required this.upright,
    required this.reversed,
  });

  factory TarotDetailData.fromJson(Map<String, dynamic> json) {
    return TarotDetailData(
      id: json['id'],
      upright: TarotDirectionDetail.fromJson(json['upright']),
      reversed: TarotDirectionDetail.fromJson(json['reversed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'upright': upright.toJson(),
      'reversed': reversed.toJson(),
    };
  }
}

class TarotDirectionDetail {
  final String keyMeanings;
  final String general;
  final String love;
  final String career;
  final String health;
  final String spirituality;

  TarotDirectionDetail({
    required this.keyMeanings,
    required this.general,
    required this.love,
    required this.career,
    required this.health,
    required this.spirituality,
  });

  factory TarotDirectionDetail.fromJson(Map<String, dynamic> json) {
    return TarotDirectionDetail(
      keyMeanings: json['keyMeanings'] ?? '',
      general: json['general'] ?? '',
      love: json['love'] ?? '',
      career: json['career'] ?? '',
      health: json['health'] ?? '',
      spirituality: json['spirituality'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'keyMeanings': keyMeanings,
      'general': general,
      'love': love,
      'career': career,
      'health': health,
      'spirituality': spirituality,
    };
  }
}
