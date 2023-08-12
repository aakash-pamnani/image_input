import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

ImageProvider? getImageWeb(
  String? imageUrl,
  void Function(Object exception, StackTrace? stackTrace)? onImageError,
) {
  try {
 if (imageUrl != null) {
      return CachedNetworkImageProvider(
        imageUrl,
      );
    } else {
      onImageError?.call(
        Exception('Platform not supported'),
        StackTrace.current,
      );
    }
  } catch (e) {
    onImageError?.call(
      e,
      StackTrace.current,
    );
  }
  return null;
}
