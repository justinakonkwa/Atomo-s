// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unnecessary_null_comparison

import 'dart:io';

import 'package:cite_phila/pages/home_page.dart';
import 'package:cite_phila/pages/movie_page.dart';
import 'package:cite_phila/widgets/app_text.dart';
import 'package:cite_phila/widgets/colors.dart';
import 'package:cite_phila/widgets/lign.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerPage extends StatefulWidget {
  PlayerPage({Key? key, required this.videoLink, required this.videoTitre})
      : super(key: key);
  String videoLink;
  String videoTitre;
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late YoutubePlayerController _controller;

  String? getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2698138965577450/2875923278';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2698138965577450/2875923278';
    }
    return null;
  } 

  @override
  void initState() {
    super.initState();
    if (videoItems != null) {
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.videoLink)!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext contex) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                              ),
                              child: YoutubePlayer(
                                controller: _controller,
                                showVideoProgressIndicator: true,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0.050 * MediaQuery.of(context).size.width,
                            right: 0.88 * MediaQuery.of(context).size.width,
                            child: GestureDetector(
                              onTap: () => Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(
                                    currentIndex: 0,
                                  ),
                                ),
                                (route) => false,
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: AppColors.activColor,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                      sizedbox,
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: AppText(
                            text: widget.videoTitre[0].toUpperCase() +
                                widget.videoTitre.substring(1).toLowerCase(),
                            color: Theme.of(context).cardColor),
                      ),
                      Lign(
                        indent: MediaQuery.of(context).size.width * 0.15,
                        endIndent: MediaQuery.of(context).size.width * 0.15,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: videoItems.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flex(
                                          direction: Axis.horizontal,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                setState(() {
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                      return PlayerPage(
                                                        videoLink:
                                                            videoItems[index]
                                                                .videoId,
                                                        videoTitre:
                                                            videoItems[index]
                                                                .title,
                                                      );
                                                    }),
                                                    (route) => false,
                                                  );
                                                });
                                              },
                                              child: SizedBox(
                                                height: 100,
                                                width: MediaQuery.of(contex)
                                                        .size
                                                        .width *
                                                    0.35,
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          videoItems[index]
                                                              .imageUrl),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]),
                                      SizedBox(
                                        height: 80.0,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              height: 40,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              child: Text(
                                                videoItems[index].title,
                                                style: const TextStyle(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.bottomRight,
                                              child: AppText(
                                                text: videoItems[index]
                                                    .uploadDate
                                                    .substring(
                                                        0,
                                                        videoItems[index]
                                                                .uploadDate
                                                                .length -
                                                            4),
                                                color: Theme.of(context)
                                                    .focusColor,
                                                size: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          setState(() {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                return PlayerPage(
                                                  videoLink:
                                                      videoItems[index].videoId,
                                                  videoTitre:
                                                      videoItems[index].title,
                                                );
                                              }),
                                              (route) => false,
                                            );
                                          });
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: AppColors.activColor,
                                              ),
                                              shape: BoxShape.circle,
                                              color: Colors.transparent),
                                          child: const Icon(
                                            Icons.play_arrow,
                                            size: 25,
                                            color: AppColors.activColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Lign(
                                    indent: MediaQuery.of(context).size.width *
                                        0.15,
                                    endIndent:
                                        MediaQuery.of(context).size.width *
                                            0.15,
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  // AdmobBanner(
                  //   adUnitId: getBannerAdUnitId()!,
                  //   adSize: AdmobBannerSize.BANNER,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
