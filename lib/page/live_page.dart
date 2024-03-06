// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages, must_be_immutable, unnecessary_import

import 'dart:developer';

import 'package:cite_phila/widgets/Smol_text_animated.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';
import '../widgets/lign.dart';
import '../widgets/my_list_video.dart';
import '../widgets/smol_text.dart';
import '../widgets/variables.dart';
import 'home_page.dart';

bool isUser = false;
List _videos2 = [];
List liveVideos = [];

class LivePage extends StatefulWidget {
  LivePage({Key? key, required this.videoUrl, required this.videoTitle})
      : super(key: key);
  String videoUrl;
  String videoTitle;

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  AppOpenAd? openAd;
  late YoutubePlayerController _controller;
  bool isError = false;
  bool isLive = false;
  bool isLoading = true;
  String titre = '';
  bool isVideos = false;

  Future<void> _scrapeYouTube() async {
    setState(() {
      if (mounted) {
        isLoading = true;
      }
    });
    try {
      final videoResponse = await http.get(Uri.parse(
          'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&maxResults=100&order=date&type=video&key=$apiKey'));

      final videoItems = json.decode(videoResponse.body)['items'];
      final videos = videoItems
          .map((item) => Video(
              item['snippet']['title'],
              item['snippet']['channelTitle'],
              item['snippet']['publishedAt'],
              item['snippet']['thumbnails']['default']['url'],
              'https://www.youtube.com/watch?v=${item['id']['videoId']}',
              item['snippet']['liveBroadcastContent'] == 'live'))
          .toList();
      setState(() {
        setState(() => isError = false);
        _videos2 = [];
        _videos2.addAll(videos);
        liveVideos = _videos2.where((video) => video.isLive).toList();
      });
      if (liveVideos.isNotEmpty) {
        titre = liveVideos[0].title;
        _controller = YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(liveVideos[0].url)!,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );
        setState(() {
          isLoading = true;
          titre;
          isLive = true;
        });
        // view();
      } else {
        setState(() {
          if (mounted) {
            isLoading = false;
          }
        });
      }
    } catch (e) {
      setState(() {
        if (mounted) {
          isLoading = false;
          isError = true;
        }
      });
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  void initState() {
    _scrapeYouTube();
    if (widget.videoUrl != '') {
      titre = widget.videoTitle;
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
      );
      isVideos = true;
    }

    super.initState();
  }

  @override
  void dispose() {
    if (widget.videoUrl != '') {
      _controller.dispose();
    }
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
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            largeTitle: SmolText(
              text: translate('menu.menu_2'),
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
                text: translate("menu.menu_0").toUpperCase(),
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
              preferredSize: const Size.fromHeight(280.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          isLive || isVideos
                              ? YoutubePlayer(
                                  controller: _controller,
                                  showVideoProgressIndicator: true,
                                  progressIndicatorColor:
                                      Theme.of(context).colorScheme.primary,
                                  onReady: () {
                                    isLive ? _controller.pause() : null;
                                  },
                                )
                              : Container(
                                  color: Theme.of(context).highlightColor,
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Center(
                                      child: !isLoading
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  FluentIcons
                                                      .cloud_off_48_filled,
                                                  size: 30,
                                                ),
                                                SmolText(
                                                  text: translate(
                                                      'live.subtitle_2'),
                                                ),
                                                sizedBox,
                                                GestureDetector(
                                                  onTap: () {
                                                    _scrapeYouTube();
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      borderRadius:
                                                          borderRadius_2,
                                                    ),
                                                    child: SmolText(
                                                      text: translate(
                                                          'live.button'),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          : const Icon(
                                              FluentIcons.arrow_sync_24_regular,
                                              size: 30,
                                            ),
                                    ),
                                  ),
                                ),
                          Positioned(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(),
                                isLive && widget.videoUrl == ''
                                    ? Container(
                                        padding: const EdgeInsets.all(4),
                                        margin: const EdgeInsets.only(
                                            right: 10, top: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.red),
                                        child: SmolText(
                                          text: translate('live.subtitle_1'),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                      )
                                    : const SizedBox()
                              ],
                            ),
                          ),
                        ],
                      ),
                      sizedBox,
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: isLive || isVideos
                            ? SmolTextAnimated(
                                text:
                                    titre[0].toUpperCase() + titre.substring(1),
                              )
                            : SmolText(
                                text: translate('live.subtitle_3'),
                              ),
                      ),
                      sizedBox,
                      const Lign(indent: 0, endIndent: 0),
                      sizedBox,
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: _videos2.isEmpty
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Theme.of(context).focusColor,
                        period: const Duration(milliseconds: 2000),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: borderRadius_2,
                            color: Theme.of(context).highlightColor,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Builder(builder: (context) {
                                return Container(
                                  height: 80,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: borderRadius_2,
                                    color: Theme.of(context).focusColor,
                                  ),
                                );
                              }),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          160,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: borderRadius_2,
                                        color: Theme.of(context).focusColor,
                                      ),
                                    ),
                                    sizedBox,
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          230,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: borderRadius_2,
                                        color: Theme.of(context).focusColor,
                                      ),
                                    ),
                                    sizedBox,
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          260,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: borderRadius_2,
                                        color: Theme.of(context).focusColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : myListVideo(
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
                                return HomePage(
                                  selectedIndex: 1,
                                  videoUrlLive: _videos2[index].url,
                                  videoTitleLive: _videos2[index].title,
                                );
                              }),
                              (route) => false,
                            );
                          });
                        },
                        _videos2[index].url,
                        _videos2[index].image,
                        _videos2[index].title,
                        '',
                        _videos2[index].date,
                        _videos2[index].author,
                        titre == _videos2[index].title,
                        true,
                      ),
              ),
              childCount: _videos2.isEmpty ? 5 : _videos2.length,
            ),
          ),
        ],
      ),
    );
  }
}

class Video {
  final String title;
  final String author;
  final String date;
  final String image;
  final String url;
  final bool isLive;

  Video(this.title, this.author, this.date, this.image, this.url, this.isLive);
}
