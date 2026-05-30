/// Model untuk Lagu Matan (lagu hafalan)
class LaguMatan {
  final String? audio;
  final String? youtubeId;
  final String? source;
  final List<String>? lirik;

  LaguMatan({
    this.audio,
    this.youtubeId,
    this.source,
    this.lirik,
  });

  bool get hasYoutube => youtubeId != null && youtubeId!.isNotEmpty;

  factory LaguMatan.fromJson(Map<String, dynamic> json) {
    return LaguMatan(
      audio: (json['audio_path'] ?? json['audio']) as String?,
      youtubeId: json['youtube_id'] as String?,
      source: (json['source'] ?? json['sumber']) as String?,
      lirik: json['lirik'] != null
          ? (json['lirik'] as List<dynamic>).map((e) => e.toString()).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'audio': audio,
        'youtube_id': youtubeId,
        'source': source,
        'lirik': lirik,
      };
}
