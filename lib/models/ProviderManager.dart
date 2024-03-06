// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'classe_manager/video_download_model.dart';

class ProviderManager extends ChangeNotifier{

  final List<VideoDownload> _videoDownloads = [];
  final Map<String, bool> _cancelledVideos = {};

  List<VideoDownload> get videoDownloads => _videoDownloads;


  addVideoDownload(VideoDownload record) {
    videoDownloads.add(record);
    notifyListeners();
  }
  void removeVideoDownload(VideoDownload video) {
    _videoDownloads.remove(video);
    notifyListeners();
  }

  bool isCancelled(String videoName) {
    return _cancelledVideos[videoName] ?? false;
  }

  void cancelDownload(String videoName) {
    _cancelledVideos[videoName] = true;
    notifyListeners();
  }
}
