import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget buildNetworkImage(String imageUrl) {
  return
    CachedNetworkImage(
    imageUrl: imageUrl,
    width: double.maxFinite,
    fit: BoxFit.cover,
    placeholder: (context, url) => AspectRatio(
      aspectRatio: 1 / 1,
      child: Container(
        color: Theme.of(context).focusColor,
      ),
    ),
      errorWidget: (context, e,___)=> AspectRatio(
        aspectRatio: 1 / 1,
        child: Container(
          color: Theme.of(context).focusColor,
        ),
      ),
  );
}
