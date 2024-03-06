// ignore_for_file: unused_local_variable, deprecated_member_use, unnecessary_import

import 'dart:developer';

import 'package:cite_phila/page/home_page.dart';
import 'package:cite_phila/screens/play.dart';
import 'package:cite_phila/widgets/my_list_video.dart';
import 'package:cite_phila/widgets/smol_text.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../generated/assets.dart';
import '../models/classe_manager/video_model.dart';
import '../widgets/variables.dart';

class SearchPage extends StatefulWidget {
  final List<VideoItem> videoItems;

  const SearchPage(this.videoItems, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  AppOpenAd? openAd;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  TextEditingController textSearch = TextEditingController();
  String searchQuery = '';
  List<VideoItem> searchResults = [];
  bool issearch = true;
  bool isssearch = false;

  searchVideo(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        searchResults.clear(); // Efface les résultats de recherche précédents
      } else {
        searchResults = widget.videoItems
            .where((video) =>
                video.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      issearch = false;
    });
  }

  List<VideoItem> getVideosByLetter(String letter) {
    return widget.videoItems
        .where((video) => video.title.toLowerCase().contains(letter))
        .toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat(reverse: true);

    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
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
    bool hasSearchResults = searchResults.isNotEmpty;
    List<VideoItem> filteredVideos =
        getVideosByLetter(searchQuery.toLowerCase());
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        title: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: CupertinoSearchTextField(
            placeholder: translate('home_page.subtitle_2'),
            controller: textSearch,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontFamily: 'Montserrat',
            ),
            placeholderStyle: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 14,
              fontFamily: 'Montserrat',
              decoration: TextDecoration.none,
              letterSpacing: 0,
            ),
            onSuffixTap: () => setState(() {
              textSearch.text = '';
              searchResults = [];
            }),
            onChanged: (String value) {
              if (value != '') {
                searchVideo(value);
              }
            },
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
            (route) => false,
          ),
          icon: Icon(
            FluentIcons.ios_arrow_24_regular,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          issearch
              ? Container(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _opacityAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _opacityAnimation.value,
                            child: const Icon(
                              FluentIcons.search_48_regular,
                              size: 150,
                            ),
                          );
                        },
                      ),
                      SmolText(
                        text: translate('home_page.subtitle_2'),
                      ),
                    ],
                  ),
                )
              : (hasSearchResults)
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final video = searchResults[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 10.0),
                            child: myListVideo(
                              context,
                              () {
                                if (openAd == null) {
                                  log('trying tto show before loading');
                                  loadAd();
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VideoPlayerPage(
                                      videoUrl: video.videoLink,
                                      videoTitle: video.title,
                                    ),
                                  ),
                                );
                              },
                              video.videoLink,
                              video.imageUrl,
                              video.title,
                              video.duration,
                              video.uploadDate,
                              video.author,
                              false,
                              false,
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Image.asset(
                        Assets.assetsNoData,
                        height: 230,
                        width: double.maxFinite,
                      ),
                    ),
        ],
      ),
    );
  }
}
