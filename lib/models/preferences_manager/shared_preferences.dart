import 'dart:convert';


import 'package:cite_phila/models/preferences_manager/shared.dart';

import '../classe_manager/video_download_model.dart';



class DownloadedVideosPreferences {

  static const _keyDownloadedVideos = 'downloaded_videos';

  static Future addDownloadedVideo(VideoDownload video) async {
    final List<String> downloadedVideosJson = PreferencesService.instance.getStringList(_keyDownloadedVideos) ?? [];

    // Ajouter la nouvelle vidéo à la liste
    downloadedVideosJson.add(jsonEncode(video.toMap()));

    // Mettre à jour la liste dans les préférences
    await PreferencesService.instance.setStringList(_keyDownloadedVideos, downloadedVideosJson);
  }

  static List<VideoDownload> getDownloadedVideos() {
    final List<String> downloadedVideosJson = PreferencesService.instance.getStringList(_keyDownloadedVideos) ?? [];

    // Convertir la liste de chaînes JSON en liste d'objets VideoDownload
    return downloadedVideosJson.map((json) => VideoDownload.fromMap(jsonDecode(json))).toList();
  }
  static Future removeDownloadedVideo(VideoDownload video) async {
    List<String> downloadedVideosJson = PreferencesService.instance
        .getStringList(_keyDownloadedVideos) ?? [];

    // Supprimer la vidéo de la liste
    downloadedVideosJson.removeWhere((json) {
      VideoDownload downloadedVideo = VideoDownload.fromMap(jsonDecode(json));
      return downloadedVideo.path == video.path;
    });
    // Mettre à jour la liste dans les préférences
    await PreferencesService.instance.setStringList(_keyDownloadedVideos, downloadedVideosJson);
  }
  static Future nullDownloadedVideos() async {
    await PreferencesService.instance.remove(_keyDownloadedVideos);
  }

}
