class Artikel {
  final String id;
  final String title;
  final String content;
  final String imageUrl;

  Artikel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
  });

  factory Artikel.fromJson(Map<String, dynamic> json) {
    return Artikel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
