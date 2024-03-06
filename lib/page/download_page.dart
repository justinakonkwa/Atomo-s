// ignore_for_file: unnecessary_import, use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import '../generated/assets.dart';
import '../models/ProviderManager.dart';
import '../models/fonction.dart';
import '../models/preferences_manager/shared_preferences.dart';
import '../models/classe_manager/video_download_model.dart';
import '../screens/show_video.dart';
import '../widgets/my_button.dart';
import '../widgets/smol_text.dart';
import '../widgets/variables.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({
    super.key,
    required this.videoUrl,
    required this.videoTitle,
    required this.videoDuration,
    required this.currentPageIndex,
  });

  final String videoUrl;
  final String videoTitle;
  final String videoDuration;
  final int currentPageIndex;

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage>
    with TickerProviderStateMixin {
  late ProviderManager providerManager;
  late TabController _tabController;
  late PageController _pageController;
  int _currentPageIndex = 0;
  List<VideoDownload> videoDownloads = [];

  @override
  void initState() {
    providerManager = Provider.of<ProviderManager>(context, listen: false);
    videoDownloads = providerManager.videoDownloads;
    _currentPageIndex = widget.currentPageIndex;
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: _currentPageIndex);
    _pageController = PageController(initialPage: _currentPageIndex);
    // Écouter les changements d'onglets et mettre à jour la page correspondante
    _tabController.addListener(() {
      if (_tabController.index != _currentPageIndex) {
        _pageController.jumpToPage(_tabController.index);
      }
    });

    // Écouter les changements de page et mettre à jour l'index de l'onglet
    _pageController.addListener(() {
      if (_pageController.page!.round() != _currentPageIndex) {
        _tabController.animateTo(
          _pageController.page!.round(),
        );
      }
    });
    if (widget.videoUrl.isNotEmpty) {
      saveVideo();
    }
    super.initState();
  }

  saveVideo() async {
    await AllFonction().saveNetworkVideo(
      widget.videoUrl,
      widget.videoTitle,
      context,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  //remove video from Shared method
  showDialogConfirm(bool isDownloaded) {
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
          text: isDownloaded
              ? translate('history.show_message_1')
              : translate('history.show_message_2'),
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
            onPressed: () async => Navigator.of(context).pop(true),
            child: SmolText(
              text: isDownloaded
                  ? translate('history.button_1')
                  : translate('history.button_2'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    providerManager = Provider.of<ProviderManager>(context);
    videoDownloads = providerManager.videoDownloads;
    videoDownloads = videoDownloads.reversed.toList();
    return SafeArea(
      child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              CupertinoSliverNavigationBar(
                backgroundColor: Theme.of(context).colorScheme.background,
                largeTitle: SmolText(
                  text: translate('menu.menu_3'),
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                stretch: true,
                border: const Border(),
                automaticallyImplyLeading: false,
              ),
              SliverAppBar(
                // expandedHeight: 250.0,
                pinned: true,
                primary: false,
                titleSpacing: 0,
                automaticallyImplyLeading: false,
                centerTitle: false,
                toolbarHeight: 0,
                collapsedHeight: 0,
                backgroundColor: Theme.of(context).colorScheme.background,
                foregroundColor: Theme.of(context).colorScheme.background,
                shadowColor: Theme.of(context).colorScheme.background,
                surfaceTintColor: Theme.of(context).colorScheme.background,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50.0),
                  child: TabBar(
                    controller: _tabController,
                    automaticIndicatorColorAdjustment: false,
                    labelPadding: EdgeInsets.zero,
                    labelStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      letterSpacing: 0,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal,
                    ),
                    onTap: (index) {
                      // Vérifiez si le widget est encore monté avant de mettre à jour l'état
                      if (mounted) {
                        setState(() {
                          _currentPageIndex = index;
                        });
                      }
                    },
                    tabs: [
                      Tab(
                        text: translate('history.subtitle_1').toUpperCase(),
                      ),
                      Tab(text: translate('history.subtitle_2').toUpperCase()),
                    ],
                    dividerColor: Colors.transparent,
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                          width: 3.0,
                          color: Theme.of(context).colorScheme.primary),
                      borderRadius: borderRadius,
                    ),
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors
                              .white; // Couleur de l'indicateur pour l'onglet sélectionné
                        }
                        return Colors
                            .transparent; // Couleur transparente pour l'onglet non sélectionné
                      },
                    ),
                    labelColor: Theme.of(context).colorScheme.primary,
                    unselectedLabelColor: Colors.grey,
                  ),
                ),
              ),
            ];
          },
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              // Vérifiez si le widget est encore monté avant de mettre à jour l'état
              if (mounted) {
                setState(() {
                  _currentPageIndex = index;
                });
              }
            },
            children: [
              Consumer<ProviderManager>(
                builder: (context, providerManager, child) {
                  List<VideoDownload> downloadedVideos =
                      DownloadedVideosPreferences.getDownloadedVideos();
                  downloadedVideos = downloadedVideos.reversed.toList();
                  return downloadedVideos.isNotEmpty
                      ? ListView.builder(
                          itemCount: downloadedVideos.length,
                          itemBuilder: (context, index) {
                            VideoDownload video = downloadedVideos[index];
                            return videoDownloadedOrProgress(
                              true,
                              video,
                              index,
                              providerManager,
                            );
                          },
                        )
                      : Center(
                          child: Image.asset(
                            Assets.assetsNoData,
                            height: 230,
                            width: double.maxFinite,
                          ),
                        );
                },
              ),
              videoDownloads.isNotEmpty
                  ? ListView.builder(
                      itemCount: videoDownloads.length,
                      itemBuilder: (context, index) {
                        VideoDownload video = videoDownloads[index];
                        return videoDownloadedOrProgress(
                          false,
                          video,
                          index,
                          providerManager,
                        );
                      },
                    )
                  : Center(
                      child: Image.asset(
                        Assets.assetsNoData,
                        height: 230,
                        width: double.maxFinite,
                      ),
                    ),
            ],
          )),
    );
  }

  Widget videoDownloadedOrProgress(
    bool isDownloaded,
    VideoDownload video,
    int index,
    ProviderManager providerManager,
  ) {
    return Dismissible(
      key: Key(index.toString() + video.name),
      confirmDismiss: (direction) => showDialogConfirm(isDownloaded),
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          if (isDownloaded) {
            // Supprimer la vidéo de SharedPreferences
            await DownloadedVideosPreferences.removeDownloadedVideo(video);
          } else {
            video.downloadCancelled = true;
            providerManager.removeVideoDownload(video);
          }
        }
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(right: 10.0, top: 10),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: borderRadius,
        ),
        child: const Icon(
          FluentIcons.delete_48_regular,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          top: 10,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                SmolText(
                    text: '${translate('history.subtitle_3')}: '.toUpperCase()),
                Text(
                  video.name[0].toUpperCase() + video.name.substring(1).toLowerCase(),
                  maxLines: 1,
                  // Nombre maximum de lignes pour le texte
                  overflow: TextOverflow.ellipsis,
                  // Ajoute des points de suspension si le texte dépasse
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    letterSpacing: 0,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
            sizedBox,
            !isDownloaded
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SmolText(
                              text: '${translate('history.subtitle_4')}: '
                                  .toUpperCase()),
                          SmolText(text: video.fileSize),
                        ],
                      ),
                      SmolText(text: "${video.progress.toStringAsFixed(1)} %"),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SmolText(
                                  text: '${translate('history.subtitle_4')}: '
                                      .toUpperCase()),
                              SmolText(text: video.fileSize),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SmolText(
                                  text: '${translate('history.subtitle_5')}: '
                                      .toUpperCase()),
                              SmolText(text: video.duration),
                            ],
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: MyButton(
                          onTap: () async {
                            File file = File(video.path);
                            Uint8List bytes = await file.readAsBytes();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowVideo(
                                  videoFile: bytes,
                                  isPaused: false,
                                ),
                              ),
                            );
                          },
                          color: Theme.of(context).colorScheme.secondary,
                          child: IntrinsicWidth(
                            child: Row(
                              children: [
                                Icon(
                                  FluentIcons.play_48_filled,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                const SizedBox(width: 5),
                                SmolText(
                                  text: translate('history.button_4'),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
            if (!isDownloaded) sizedBox,
            if (!isDownloaded)
              LinearProgressIndicator(
                backgroundColor: Colors.black45,
                value: video.progress / 100,
                valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).colorScheme.primary),
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: borderRadius,
              ),
            sizedBox,
          ],
        ),
      ),
    );
  }
}
