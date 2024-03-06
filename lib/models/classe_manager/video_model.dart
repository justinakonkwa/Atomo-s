class VideoItem {
  final String videoId;
  final String imageUrl;
  final String videoLink;
  final String title;
  final String duration;
  final String author;
  final String uploadDate;

  VideoItem({
    required this.videoId,
    required this.imageUrl,
    required this.videoLink,
    required this.title,
    required this.duration,
    required this.author,
    required this.uploadDate,
  });

  // Méthode pour convertir l'objet en Map
  Map<String, dynamic> toMap() {
    return {
      'videoId': videoId,
      'imageUrl': imageUrl,
      'videoLink': videoLink,
      'title': title,
      'duration':duration,
      'author':author,
      'uploadDate': uploadDate,
    };
  }
}
