class VideoDownload {
  String path;
  String name;
  String duration;
  String fileSize;
  double progress;
  bool downloadCancelled;

  VideoDownload({
    required this.path,
    required this.name,
    required this.duration,
    required this.progress,
    required this.fileSize,
    required this.downloadCancelled,
  });

  // Méthode pour convertir l'objet en Map
  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'name': name,
      'duration': duration,
      'progress': progress,
      'fileSize': fileSize,
      'downloadCancelled': downloadCancelled,
    };
  }

  // Méthode pour créer une instance de VideoDownload à partir d'une Map
  factory VideoDownload.fromMap(Map<String, dynamic> map) {
    return VideoDownload(
      path: map['path'],
      name: map['name'],
      duration: map['duration'],
      progress: map['progress'],
      fileSize: map['fileSize'],
      downloadCancelled: map['downloadCancelled'],
    );
  }
}
