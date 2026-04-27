/// Model untuk Lagu Matan (lagu hafalan)
class LaguMatan {
  final String? audio;
  final String? youtubeId;
  final List<String>? lirik;

  LaguMatan({
    this.audio,
    this.youtubeId,
    this.lirik,
  });

  bool get hasYoutube => youtubeId != null && youtubeId!.isNotEmpty;

  factory LaguMatan.fromJson(Map<String, dynamic> json) {
    return LaguMatan(
      audio: json['audio'] as String?,
      youtubeId: json['youtube_id'] as String?,
      lirik: json['lirik'] != null
          ? (json['lirik'] as List<dynamic>).map((e) => e.toString()).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'audio': audio,
        'youtube_id': youtubeId,
        'lirik': lirik,
      };
}
