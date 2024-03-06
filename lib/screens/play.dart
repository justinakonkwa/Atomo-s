// ignore_for_file: must_be_immutable, unnecessary_null_comparison, library_private_types_in_public_api, unnecessary_import

import 'dart:developer';


import 'package:cite_phila/page/home_page.dart';
import 'package:cite_phila/widgets/lign.dart';
import 'package:cite_phila/widgets/my_list_video.dart';
import 'package:cite_phila/widgets/variables.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../page/movie_page.dart';
import '../widgets/Smol_text_animated.dart';

class VideoPlayerPage extends StatefulWidget {
  VideoPlayerPage({Key? key, required this.videoUrl, required this.videoTitle})
      : super(key: key);
  String videoUrl;
  String videoTitle;

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late BannerAd bannerAd;
  AppOpenAd? openAd;
  late YoutubePlayerController _controller;
  String title = '';

  @override
  void initState() {
    super.initState();
    bannerAd = BannerAd(
      adUnitId: getBannerAdUnitId()!,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          // Ad is loaded successfully
          log('Ad loaded: ${ad.adUnitId}');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Ad failed to load
          log('Ad failed to load: $error');
        },
        // Add other listener methods as needed
      ),
    );
    bannerAd.load();
    title = widget.videoTitle;
    if (videoItems != null) {
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    bannerAd.dispose();
    _controller.pause();
    _controller.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    children: [
                      Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).focusColor,
                              ),
                              child: YoutubePlayer(
                                controller: _controller,
                                showVideoProgressIndicator: true,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  selectedIndex: 0,
                                ),
                              ),
                              (route) => false,
                            ),
                            icon: Icon(
                              FluentIcons.ios_arrow_24_regular,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      sizedBox,
                      Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: SmolTextAnimated(
                            text: widget.videoTitle[0].toUpperCase() +
                                widget.videoTitle.substring(1),
                          )),
                      sizedBox,
                      const Lign(indent: 0, endIndent: 0),
                      sizedBox,
                      Expanded(
                        child: ListView.builder(
                          itemCount: videoItems.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: myListVideo(
                                context,
                                () async {
                                  if (openAd == null) {
                                    log('trying tto show before loading');
                                    loadAd();
                                  }
                                  setState(() {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return VideoPlayerPage(
                                          videoUrl: videoItems[index].videoId,
                                          videoTitle: videoItems[index].title,
                                        );
                                      }),
                                      (route) => false,
                                    );
                                  });
                                },
                                videoItems[index].videoLink,
                                videoItems[index].imageUrl,
                                videoItems[index].title,
                                videoItems[index].duration,
                                videoItems[index].uploadDate,
                                videoItems[index].author,
                                title == videoItems[index].title,
                                false,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    width: bannerAd.size.width.toDouble(),
                    height: bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: bannerAd),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
