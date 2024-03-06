import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:store_redirect/store_redirect.dart';

BorderRadius borderRadius = BorderRadius.circular(15);
BorderRadius borderRadius_2 = BorderRadius.circular(10);
SizedBox sizedBox = const SizedBox(height: 10);
SizedBox sizedBox2 = const SizedBox(width: 10);

// get BannerAdUnitId to app
String? getBannerAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-2698138965577450/3425404109';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-2698138965577450/8957195369';
  }
  return null;
}

// get AppOpenAd to app
String? getAppOpenAd() {
  if (Platform.isIOS) {
    return 'ca-app-pub-2698138965577450/7945288606';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-2698138965577450/8975067734';
  }
  return null;
}

//get all version to app
final newVersion = NewVersionPlus(
  iOSId: 'com.disney.disneyplus',
  androidId: 'com.naara.cite_phila',
  androidPlayStoreCountry: null,
);
// key for api youtube on live
const String apiKey = 'AIzaSyD-P2V-r6OOqqG1XE7BkyQyhIoa1JP5sDo';
// channelId for channel youtube
const String channelId = 'UCpl-8yOibCjQYPPOU-j3Syg';

// store redirect
final storeRedirect = StoreRedirect.redirect(
  androidAppId: 'com.naara.cite_phila',
  iOSAppId: 'com.naara.cite_phila',
);

// link of playStore
const String playStoreUrl =
    'https://play.google.com/store/apps/details?id=com.naara.cite_phila';
// link of privacy policy
const String privacyUrl =
    'https://raw.githubusercontent.com/Pacome0106/all_chuch/main/README.md';
// link of terms & conditions
const String termsAndConditions =
    'https://raw.githubusercontent.com/Pacome0106/all_chuch/main/terms%20%26%20conditions';
