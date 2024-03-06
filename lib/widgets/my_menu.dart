// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:cite_phila/page/home_page.dart';
import 'package:cite_phila/widgets/smol_text.dart';
import 'package:cite_phila/widgets/variables.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:share_plus/share_plus.dart';

import '../models/preferences_manager/shared_preferences.dart';
import '../models/classe_manager/video_download_model.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class MyMenu extends StatefulWidget {
  const MyMenu({
    super.key,
    required this.videoLink,
    required this.videoTitle,
  });

  final String videoLink;
  final String videoTitle;

  @override
  State<MyMenu> createState() => _MyMenuState();
}

class _MyMenuState extends State<MyMenu> {
  // Fonction pour vérifier si une vidéo a déjà été téléchargée
  bool isVideoDownloaded(String videoName) {
    List<VideoDownload> downloadedVideos =
        DownloadedVideosPreferences.getDownloadedVideos();
    return downloadedVideos.any((video) => video.name == videoName);
  }

// Utilisez cette fonction avant d'appeler la fonction de téléchargement
  void checkAndDownloadVideo(String videoUrl, String videoName) async {
    if (isVideoDownloaded(videoName)) {
      log('===========>La vidéo $videoName a déjà été téléchargée.');
      showDialogReDownload(videoUrl, videoName);
    } else {
      // La vidéo n'a pas encore été téléchargée, appelez la fonction de téléchargement
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            videoUrlDownload: videoUrl,
            videoTitleDownload: videoName,
            currentPageIndex: 1,
            selectedIndex: 2,
            isDownload: true,
          ),
        ),
        (route) => false,
      );
    }
  }

  showDialogReDownload(String videoUrl, String videoName) {
    //show a dialog box to ask user to confirm to remove from cart
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        surfaceTintColor: Theme.of(context).colorScheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        content: SmolText(
          text: translate('history.show_message_3'),
          textAlign: TextAlign.center,
        ),
        actions: [
          //cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: SmolText(
              text: translate('button.cancel'),
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),

          //yes button
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      videoUrlDownload: videoUrl,
                      videoTitleDownload: videoName,
                      currentPageIndex: 1,
                      selectedIndex: 2,
                      isDownload: true,
                    ),
                  ),
                  (route) => false);
            },
            child: SmolText(
              text: translate('history.button_3'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SampleItem? selectedMenu;
    return MenuAnchor(
        style: MenuStyle(
          backgroundColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.inversePrimary),
          surfaceTintColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.inversePrimary),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: borderRadius, // Set your desired border radius
            ),
          ),
          padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
          alignment: Alignment.centerRight,
        ),
        builder:
            (BuildContext context, MenuController controller, Widget? child) {
          return GestureDetector(
            onTap: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            child: const Icon(FluentIcons.more_vertical_48_regular),
          );
        },
        menuChildren: [
          MenuItemButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: borderRadius, // Set your desired border radius
                ),
              ),
            ),
            onPressed: () async {
              setState(() {
                selectedMenu = SampleItem.itemOne;
              });
              try {
                await Share.share(
                  widget.videoLink,
                  subject: translate('menu.menu_0'),
                  sharePositionOrigin: Rect.fromPoints(
                    Offset.zero,
                    const Offset(10, 10),
                  ),
                );
              } catch (e) {
                log('===========>Erreur lors du partage de la vidéo : $e');
              }

              // Ajoutez votre logique pour "Download video" ici
            },
            child: Row(
              children: [
                const Icon(FluentIcons.share_48_regular),
                sizedBox2,
                SmolText(text: translate('home_page.button_1')),
              ],
            ),
          ),
          MenuItemButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: borderRadius, // Set your desired border radius
                ),
              ),
            ),
            onPressed: () async {
              setState(() {
                checkAndDownloadVideo(widget.videoLink, widget.videoTitle);
              });
              // Ajoutez votre logique pour "Share video" ici
            },
            child: Row(
              children: [
                const Icon(CupertinoIcons.tray_arrow_down, size: 20),
                sizedBox2,
                SmolText(text: translate('home_page.button_2')),
              ],
            ),
          ),
          MenuItemButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: borderRadius, // Set your desired border radius
                ),
              ),
            ),
            onPressed: () {
              setState(() {
                selectedMenu = SampleItem.itemThree;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      currentPageIndex: 0,
                      selectedIndex: 2,
                    ),
                  ),
                  (route) => false,
                );
              });
              // Ajoutez votre logique pour "Historique de téléchargement" ici
            },
            child: Row(
              children: [
                const Icon(FluentIcons.history_48_regular),
                sizedBox2,
                SmolText(text: translate('home_page.button_3')),
              ],
            ),
          ),
        ]);
  }
}
