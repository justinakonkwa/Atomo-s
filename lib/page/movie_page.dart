// ignore_for_file: avoid_print, duplicate_ignore, use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cite_phila/models/fonction.dart';
import 'package:cite_phila/screens/play.dart';
import 'package:cite_phila/screens/search_screen.dart';
import 'package:cite_phila/widgets/lign.dart';
import 'package:cite_phila/widgets/my_button.dart';
import 'package:cite_phila/widgets/my_image.dart';
import 'package:cite_phila/widgets/my_menu.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../models/classe_manager/video_model.dart';
import '../widgets/smol_text.dart';
import '../widgets/variables.dart';

List<VideoItem> videoItems = [];

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> with WidgetsBindingObserver {
  bool isLoading = true;
  AppOpenAd? openAd;

  @override
  void initState() {
    super.initState();
    checkInternetConnectivity();
    getChannelVideos();
  }

  Future<void> loadAd() async {
    await AppOpenAd.load(
      adUnitId: getAppOpenAd()!,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: (ad) {
        log('ad is loaded');
        openAd = ad;
        openAd!.show();
      }, onAdFailedToLoad: (error) {
        log('ad failed to load $error');
      }),
      orientation: AppOpenAd.orientationPortrait,
    );
  }

  // Fonction pour récupérer les vidéos
  void getChannelVideos() async {
    var youtube = YoutubeExplode();
    try {
      await for (var video
          in youtube.channels.getUploads(ChannelId(channelId))) {
        String videoDuration = video.duration?.toString() ?? '';
        String duration = videoDuration != ''
            ? AllFonction().arrondirDuree(videoDuration)
            : '';
        String date =
            "${video.uploadDate?.year}-${video.uploadDate?.month.toString().padLeft(2, '0')}-${video.uploadDate?.day.toString().padLeft(2, '0')}";
        VideoItem videoItem = VideoItem(
          videoId: video.id.toString(),
          imageUrl: video.thumbnails.highResUrl,
          videoLink: video.url,
          title: video.title,
          duration: duration,
          author: video.author,
          uploadDate: date,
        );
        setState(() {
          videoItems.add(videoItem);
        });
      }
      youtube.close();
    } catch (e) {
      print(e);
      youtube.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(slivers: [
        CupertinoSliverNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          largeTitle: SmolText(
            text: translate('menu.menu_0'),
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          stretch: true,
          border: const Border(),
          automaticallyImplyLeading: false,
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          sliver: SliverToBoxAdapter(
            child: SmolText(
              text: translate("home_page.subtitle_1").toUpperCase(),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
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
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(videoItems),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                padding: const EdgeInsets.only(left: 10, right: 10),
                height: 35,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: borderRadius_2,
                  color: Theme.of(context).focusColor,
                ),
                child: Row(
                  children: [
                    const Icon(FluentIcons.search_48_regular),
                    sizedBox2,
                    SmolText(
                      text: translate('home_page.subtitle_2'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => videoItems.isEmpty
                ? Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Theme.of(context).focusColor,
                    period: const Duration(milliseconds: 2000),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).focusColor,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Theme.of(context).focusColor,
                              ),
                              sizedBox2,
                              Container(
                                width: 300.0,
                                height: 15,
                                decoration: BoxDecoration(
                                    borderRadius: borderRadius_2,
                                    color: Theme.of(context).focusColor),
                              )
                            ],
                          ),
                        ),
                        sizedBox,
                        Lign(
                          indent: MediaQuery.of(context).size.width * 0.15,
                          endIndent: MediaQuery.of(context).size.width * 0.15,
                        ),
                        sizedBox,
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child:
                                  buildNetworkImage(videoItems[index].imageUrl),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (openAd == null) {
                                log('trying tto show before loading');
                                loadAd();
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoPlayerPage(
                                    videoUrl: videoItems[index].videoLink,
                                    videoTitle: videoItems[index].title,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: const BoxDecoration(
                                  color: Colors.black54, shape: BoxShape.circle),
                              child: Icon(
                                FluentIcons.play_48_filled,
                                size: 35,
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                margin:
                                    const EdgeInsets.only(left: 8.0, top: 8.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).focusColor,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      videoItems[index].imageUrl,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              sizedBox2,
                              SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Text(
                                  videoItems[index].title[0].toUpperCase() +
                                      videoItems[index]
                                          .title
                                          .substring(1)
                                          .toLowerCase(),
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    letterSpacing: 0,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: MyMenu(
                              videoLink: videoItems[index].videoLink,
                              videoTitle: videoItems[index].title,
                            ),
                          ),
                        ],
                      ),
                      sizedBox,
                      Lign(
                        indent: MediaQuery.of(context).size.width * 0.15,
                        endIndent: MediaQuery.of(context).size.width * 0.15,
                      ),
                      sizedBox,
                    ],
                  ),
            childCount: videoItems.isEmpty ? 5 : videoItems.length,
          ),
        ),
      ]),
    );
  }

  void checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // ignore: use_build_context_synchronously
      showBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                sizedBox,
                sizedBox,
                const Icon(FluentIcons.wifi_off_24_regular),
                sizedBox,
                SmolText(
                  text: translate('home_page.subtitle_3'),
                  textAlign: TextAlign.center,
                ),
                sizedBox,
                sizedBox,
                MyButton(
                  onTap: () {
                    Navigator.pop(context);
                    getChannelVideos();
                  },
                  child: SmolText(
                    text: translate('home_page.button_4'),
                  ),
                ),
                sizedBox,
                sizedBox,
              ],
            ),
          );
        },
      );

      // ignore: avoid_print
      log('Pas de connexion Internet.');
    } else if (connectivityResult == ConnectivityResult.wifi) {
      log('Connecté à Internet via Wi-Fi.');
    } else if (connectivityResult == ConnectivityResult.mobile) {
      log('Connecté à Internet via données mobiles.');
    }
  }
}
