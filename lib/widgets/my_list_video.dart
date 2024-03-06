// ignore_for_file: unnecessary_import

import 'package:cite_phila/widgets/smol_text.dart';
import 'package:cite_phila/widgets/variables.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'my_image.dart';
import 'my_menu.dart';

Widget myListVideo(
  BuildContext context,
  void Function()? onTap,
  String videoUrl,
  String imageUrl,
  String title,
  String duration,
  String date,
  String author,
  bool isPlay,
  bool isLive,
) {
  return Container(
    padding: const EdgeInsets.all(10),
    height: 100,
    decoration: BoxDecoration(
      borderRadius: borderRadius_2,
      color: Theme.of(context).highlightColor,
    ),
    child: Row(
      children: [
        InkWell(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: borderRadius_2,
                child: SizedBox(
                  height: 80,
                  width: 100,
                  child: buildNetworkImage(imageUrl),
                ),
              ),
              Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black54,
                ),
                child: Icon(
                  FluentIcons.play_48_filled,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width -
                        160, // Limite la largeur au maximum de l'écran
                  ),
                  child: Text(
                    title[0].toUpperCase() + title.substring(1),
                    style: TextStyle(
                      color:
                          isPlay ? Theme.of(context).colorScheme.primary : null,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0,
                    ),
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                sizedBox,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SmolText(
                              text:isLive?"${date.toString().substring(0, date.toString().length - 10)} ${translate('live.subtitle_4')} ${date.toString().substring(11, date.toString().length - 4)}"
                                  .toUpperCase(): date,
                            ),
                            sizedBox2,
                            SmolText(
                              text: duration,
                            ),
                          ],
                        ),
                        MyMenu(
                          videoLink: videoUrl,
                          videoTitle: title,
                        ),
                      ],
                    ),
                    SmolText(
                      text: author,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
