
import 'package:cite_phila/widgets/smol_text.dart';
import 'package:cite_phila/widgets/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'bold_text.dart';
import 'lign.dart';



/// Message Dialog widget function
/// [context] is the context of the widget
/// [title] is the title of the dialog
/// [message] is the message of the dialog
Future<void> showMessageDialog(BuildContext context,
    {required String title, required Widget widget}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        surfaceTintColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BoldText(text: title),
              const SizedBox(
                height: 10,
              ),
              widget,
              const SizedBox(
                height: 20,
              ),
              const Lign(indent: 0, endIndent: 0),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: SmolText(text: translate('theme.ok')),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<VideoStreamInfo?> showVideoVersionsPopup(
    BuildContext context, List<VideoStreamInfo> videoStreams) {
  List<String> preferredQualities = ['1080p', '720p', '480p', '360p'];
  Set<String> encounteredQualityLabels = <String>{};
  List<VideoStreamInfo> displayedStreams = [];
  videoStreams
      .where(
        (streamInfo) => preferredQualities.contains(streamInfo.qualityLabel),
  )
      .forEach((streamInfo) {
    if (!encounteredQualityLabels.contains(streamInfo.qualityLabel)) {
      encounteredQualityLabels.add(streamInfo.qualityLabel);
      displayedStreams.add(streamInfo);
    }
  });

  displayedStreams.sort((a, b) => b.size.compareTo(a.size));
  displayedStreams = displayedStreams.take(4).toList();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        surfaceTintColor: Theme.of(context).colorScheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SmolText(
              text: 'Choisissez la version de la vidéo',
              textAlign: TextAlign.center,
            ),
            SingleChildScrollView(
              child: ListBody(
                children: displayedStreams.map((streamInfo) {
                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: borderRadius_2,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: ListTile(
                      title: SmolText(
                        text:
                        '${streamInfo.qualityLabel} - size: ${streamInfo.size}',
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      onTap: () => Navigator.of(context).pop(streamInfo),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: SmolText(
              text: translate('button.cancel'),
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ],
      );
    },
  );
}




