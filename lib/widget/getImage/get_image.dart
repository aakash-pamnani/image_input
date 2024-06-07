import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:image_input/widget/getImage/get_image_io.dart';
// import 'package:image_input/widget/getImage/getImageWeb.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:octo_image/octo_image.dart';

// Widget? getImage(
//   XFile? image,
//   String? imageUrl, {
//   OctoProgressIndicatorBuilder? loadingBuilder,
//   ImageErrorWidgetBuilder? errorBuilder,
// }) {
//   try {
//     // if (kIsWeb) {
//     //   return getImageWeb(image?.path ?? imageUrl, loadingBuilder, errorBuilder);
//     // } else {
//     return getImageIo(image, imageUrl, loadingBuilder, errorBuilder);
//     // }
//   } catch (e) {
//     return null;
//   }
// }


ImageProvider<Object>? getImageProvider(XFile? image, String? imageUrl) {
  if (image != null) {
    if (kIsWeb) {
      return CachedNetworkImageProvider(image.path);
    }
    return FileImage(File(image.path));
  } else if (imageUrl != null) {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        kIsWeb) {
      return CachedNetworkImageProvider(imageUrl);
    } else {
      return NetworkImage(imageUrl);
    }
  } else {
    return null;
  }
}
