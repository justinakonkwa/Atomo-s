import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../widgets/smol_text.dart';
import '../widgets/variables.dart';
import 'language_preferences.dart';


void showDemoActionSheet(
    {required BuildContext context, required Widget child}) {
  showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child).then((String? value) {
    if (value != null) changeLocale(context, value);
  });
}

void onActionSheetPress(BuildContext context) {
  List<String> languageCodes = ['en_US', 'fr'];
  List languageNames = [
    translate('language.name.en'),
    translate('language.name.fr'),
  ];

  showDemoActionSheet(
    context: context,
    child: Dialog(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      surfaceTintColor: Theme.of(context).colorScheme.inversePrimary,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      insetPadding: const EdgeInsets.symmetric(horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: SmolText(text: translate('language.selection.message'))),
            sizedBox,
            sizedBox,
            Wrap(
              direction: Axis.horizontal,
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(
                languageNames.length,
                (index) => GestureDetector(
                  onTap: () {
                    Navigator.pop(context, languageCodes[index]);
                    TranslatePreferences(languageCodes[index]);
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MainPage(selectedIndex: 4),
                    //     maintainState: false,
                    //     allowSnapshotting: false,
                    //   ),
                    //       (route) => false,
                    // );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: borderRadius_2,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: SmolText(
                      text: languageNames[index],
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: SmolText(
                    text: translate('button.cancel'),
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
