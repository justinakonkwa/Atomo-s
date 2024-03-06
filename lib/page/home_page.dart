// ignore_for_file: must_be_immutable, avoid_print, body_might_complete_normally_catch_error, deprecated_member_use, depend_on_referenced_packages, use_build_context_synchronously

// import 'package:admob_flutter/admob_flutter.dart';
import 'dart:developer';

import 'package:cite_phila/page/download_page.dart';
import 'package:cite_phila/page/live_page.dart';
import 'package:cite_phila/page/movie_page.dart';
import 'package:cite_phila/page/setting_page.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:new_version_plus/new_version_plus.dart';

import '../widgets/variables.dart';

class HomePage extends StatefulWidget {
  HomePage({
    super.key,
    this.selectedIndex = 0,
    this.currentPageIndex = 0,
    this.videoUrlLive = '',
    this.videoTitleLive = '',
    this.videoUrlDownload = '',
    this.videoTitleDownload = '',
    this.videoDuration = '',
    this.isDownload = false,
  });

  int selectedIndex;
  String videoUrlLive;
  String videoTitleLive;
  String videoUrlDownload;
  String videoTitleDownload;
  String videoDuration;
  int currentPageIndex;
  bool isDownload;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedIndex;
  late BannerAd bannerAd;

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    super.initState();
    // Replace 'your_ad_unit_id' with your actual Ad Unit ID
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
    // checkInternetConnectivity();
    //get fonction to verify update
    advancedStatusCheck(newVersion);
  }

  // --------- fonction to verify a update ----------------
  advancedStatusCheck(NewVersionPlus newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      if (status.localVersion != status.storeVersion) {
        // debugPrint(status.releaseNotes);
        // debugPrint(status.appStoreLink);
        debugPrint(status.localVersion);
        debugPrint(status.storeVersion);
        // debugPrint(status.canUpdate.toString());
        if (!context.mounted) return;
        newVersion.showUpdateDialog(
          context: context,
          versionStatus: status,
          updateButtonText: translate('update.button_1'),
          dismissButtonText: translate('update.button_2'),
          dialogTitle: translate('update.title'),
          dialogText:
              "${translate('update.subtitle_1')} ${status.storeVersion} ${translate('update.subtitle_2')} ${status.localVersion})",
          launchModeVersion: LaunchModeVersion.external,
          allowDismissal: true,
        );
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void dispose() {
    bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String videoUrlDownload = '';
    String videoTitleDownload = '';
    if (widget.isDownload) {
      videoUrlDownload = widget.videoUrlDownload;
      videoTitleDownload = widget.videoTitleDownload;
      widget.isDownload = false;
    }else{
      widget.currentPageIndex = 0;
    }
    final List<Widget> pages = [
      const VideoPage(),
      LivePage(
        videoTitle: widget.videoTitleLive,
        videoUrl: widget.videoUrlLive,
      ),
      DownloadPage(
        videoUrl: videoUrlDownload,
        videoTitle: videoTitleDownload,
        videoDuration: widget.videoDuration,
        currentPageIndex: widget.currentPageIndex,
      ),
      const SettingPage(),
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          pages[_selectedIndex],
          Container(
            alignment: Alignment.bottomCenter,
            width: bannerAd.size.width.toDouble(),
            height: bannerAd.size.height.toDouble(),
            child: AdWidget(ad: bannerAd),
          ),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        onTap: (index) => _onItemTapped(index),
        currentIndex: _selectedIndex,
        activeColor: Theme.of(context).colorScheme.primary,
        iconSize: 25,
        items: [
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? const Icon(
                    FluentIcons.home_32_filled,
                  )
                : const Icon(FluentIcons.home_32_regular),
            label: translate('menu.menu_1'),
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? const Icon(FluentIcons.video_48_filled)
                : const Icon(FluentIcons.video_48_regular),
            label: translate('menu.menu_2'),
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? const Icon(CupertinoIcons.tray_arrow_down_fill)
                : const Icon(CupertinoIcons.tray_arrow_down),
            label: translate('menu.menu_3'),
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 3
                ? const Icon(FluentIcons.settings_48_filled)
                : const Icon(FluentIcons.settings_48_regular),
            label: translate('menu.menu_4'),
          ),
        ],
      ),
    );

  }
}
