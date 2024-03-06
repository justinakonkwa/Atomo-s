
import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../language/choose_language.dart';
import '../models/utils.dart';
import '../theme/theme_provider.dart';
import '../widgets/my_card.dart';
import '../widgets/show_message.dart';
import '../widgets/smol_text.dart';
import '../widgets/variables.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            largeTitle: SmolText(
              text: translate('menu.menu_4'),
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            stretch: true,
            border: const Border(),
            automaticallyImplyLeading: false,
          ),
          SliverPadding(
            padding:
                const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  SmolText(
                    text: translate("settings.general").toUpperCase(),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).highlightColor,
                      borderRadius: borderRadius,
                    ),
                    child: Column(
                      children: [
                        myCard(
                          ontap: () => onActionSheetPress(context),
                          context: context,
                          fistWidget:
                              const Icon(FluentIcons.translate_24_regular),
                          title: translate('language.change_language'),
                          secondWidget:
                              const Icon(FluentIcons.arrow_fit_20_regular),
                          showLast: false,
                        ),
                        Consumer<ThemeProvider>(
                          builder: (context, provider, child) {
                            bool theme = provider.currentTheme;
                            return myCard(
                              ontap: () => provider.changeTheme(!theme),
                              context: context,
                              fistWidget: const Icon(
                                  FluentIcons.brightness_high_48_filled),
                              title: theme
                                  ? translate('theme.light')
                                  : translate('theme.dark'),
                              secondWidget:
                                  const Icon(FluentIcons.arrow_fit_20_regular),
                              showLast: true,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  sizedBox,
                  sizedBox,
                  SmolText(
                    text: translate("settings.support_and_feedback")
                        .toUpperCase(),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).highlightColor,
                      borderRadius: borderRadius,
                    ),
                    child: Column(
                      children: [
                        myCard(
                          ontap: () {
                            showMessageDialog(context,
                                title: translate("settings.contactUs"),
                                widget: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SmolText(text: 'pacomecuma2.0@gmail.com'),
                                    SmolText(text: 'jazakon3.0@gmail.com'),
                                  ],
                                ));
                          },
                          context: context,
                          fistWidget: const Icon(FluentIcons.call_48_regular),
                          title: translate("settings.contactUs"),
                          showLast: false,
                        ),
                        myCard(
                          ontap: () {
                            // donner les avis
                            storeRedirect;
                          },
                          context: context,
                          fistWidget:
                              const Icon(FluentIcons.star_half_28_regular),
                          title: translate("settings.leaveReview"),
                          showLast: false,
                        ),
                        myCard(
                          ontap: () async {
                            String link = '';
                            if (Platform.isIOS) {
                            } else if (Platform.isAndroid) {
                              link = playStoreUrl;
                            }
                            if (link.isNotEmpty) {
                              await Share.share(
                                link,
                                subject: translate('menu.menu_0'),
                                sharePositionOrigin: Rect.fromPoints(
                                  Offset.zero,
                                  const Offset(10, 10),
                                ),
                              );
                            }
                          },
                          context: context,
                          fistWidget:
                              const Icon(FluentIcons.share_android_32_regular),
                          title: translate("settings.shareApp"),
                          showLast: true,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SmolText(
                    text: translate("settings.app").toUpperCase(),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).highlightColor,
                      borderRadius: borderRadius,
                    ),
                    child: Column(
                      children: [
                        myCard(
                          ontap: () {
                            showMessageDialog(
                              context,
                              title: translate("settings.app"),
                              widget: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: SmolText(
                                  text: translate('settings.sub_app'),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                          context: context,
                          fistWidget: const Icon(FluentIcons.phone_48_regular),
                          title: translate("settings.app"),
                          showLast: false,
                        ),
                        myCard(
                          ontap: () {
                            myLaunchUrl(privacyUrl);
                          },
                          context: context,
                          fistWidget:
                              const Icon(FluentIcons.shield_error_24_regular),
                          title: translate("settings.privacy_policy"),
                          showLast: false,
                        ),
                        myCard(
                          ontap: () {
                            myLaunchUrl(termsAndConditions);
                          },
                          context: context,
                          fistWidget: const Icon(
                              FluentIcons.book_question_mark_24_regular),
                          title: translate("settings.terms_and_conditions"),
                          showLast: true,
                        ),
                      ],
                    ),
                  ),
                  sizedBox,
                  sizedBox,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
