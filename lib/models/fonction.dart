// ignore_for_file: depend_on_referenced_packages, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cite_phila/models/classe_manager/video_download_model.dart';
import 'package:cite_phila/models/preferences_manager/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../widgets/show_message.dart';
import 'ProviderManager.dart';

class AllFonction {
  // ------------ fonction to arrondi a duration on String date --------------
  String arrondirDuree(String duration) {
    // Split the string by ':' to extract hours, minutes, and seconds
    List<String> parts = duration.split(':');

    // Extract hours, minutes, and seconds
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    double seconds = double.parse(parts[2]);

    // Convert everything to seconds and round
    int totalSeconds = (hours * 3600 + minutes * 60 + seconds).round();

    // Format the result
    String dureeArrondieStr =
        "${totalSeconds ~/ 3600}:${((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0')}:${(totalSeconds % 60).toString().padLeft(2, '0')}";

    return dureeArrondieStr;
  }


  Future<Map<String, dynamic>> downloadAndConvertVideo(
      context, String videoUrl) async {
    var youtube = YoutubeExplode();
    var videoInfo = await youtube.videos.get(VideoId(videoUrl));

    var streamManifest = await youtube.videos.streamsClient.getManifest(
      videoInfo.id,
    );
    var selectedStreamInfo =
        await showVideoVersionsPopup(context, streamManifest.video);

    if (selectedStreamInfo != null) {
      var streamInfo = selectedStreamInfo;
      var result = {
        'duration': AllFonction().arrondirDuree(videoInfo.duration.toString()),
        'videoUrl': streamInfo.url,
        'size': streamInfo.size,
      };
      return result;
    } else {
      log('annulation');
      // Retourner une valeur par défaut ou lancer une exception, selon votre logique
      throw Exception('Téléchargement annulé');
    }
  }

//  --------- fonction to save a videoUb ---------
  Future<void> saveNetworkVideo(
    String videoUrl,
    String videoName,
    BuildContext context,
  ) async {
    final ProviderManager providerManager =
        Provider.of<ProviderManager>(context, listen: false);
    await AllFonction()
        .downloadAndConvertVideo(context, videoUrl)
        .then((result) async {
      // Créer un nouvel enregistrement pour cette vidéo
      VideoDownload videoDownload = VideoDownload(
        path: '',
        name: '',
        duration: '',
        progress: 0.0,
        fileSize: '',
        downloadCancelled: false,
      );
      Future.delayed(Duration.zero, () {
        providerManager.addVideoDownload(videoDownload);
      });
      videoDownload.duration = result['duration'];
      videoDownload.fileSize = result['size'].toString();
      videoDownload.name = videoName;

        // Vérifier et demander la permission d'écrire sur le stockage externe
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }

        Directory appDocumentsDirectory =
            await getApplicationDocumentsDirectory();
        String appDocumentsPath = appDocumentsDirectory.path;
        String videoPath = '$appDocumentsPath/$videoName.mp4';

        // Plus tard, convertir la chaîne en un nouveau CancelToken
        CancelToken deserializedToken = CancelToken();

        await Dio().download(
          result['videoUrl'].toString(),
          videoPath,
          cancelToken: deserializedToken,
          onReceiveProgress: (rec, total) {

            videoDownload.progress = (rec / total) * 100;

            log('Download progress: ${(rec / total) * 100}%');
            // Mettre à jour le progrès dans l'enregistrement de cette vidéo
            if (videoDownload.downloadCancelled) {
              deserializedToken.cancel("Annulation de l'opération.");
            } else {
              providerManager.notifyListeners();
            }
          },
        );
      if (!videoDownload.downloadCancelled) {
        await SaverGallery.saveFile(file: videoPath,androidExistNotSave: true, name: '$videoName.mp4',androidRelativePath: "Pictures");
        videoDownload.path = videoPath;
        // Ajouter la vidéo téléchargée à SharedPreferences
        await DownloadedVideosPreferences.addDownloadedVideo(videoDownload);
        // Supprimer la vidéo du ProviderManager
        providerManager.removeVideoDownload(videoDownload);
        log('Video saved successfully');
      }
    });
  }
}
