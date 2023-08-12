import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

ImageProvider? getImageIo(
    XFile? image,
    String? imageUrl,
    void Function(Object exception, StackTrace? stackTrace)? onImageError,
  ) {
    try {
      if (image != null) {
        return FileImage(
          File(image.path),
        );
      } else if (imageUrl != null) {
        if (Platform.isWindows || Platform.isLinux || Platform.isFuchsia) {
          return NetworkImage(imageUrl);
        } else if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
          return CachedNetworkImageProvider(imageUrl);
        } else {
          onImageError?.call(
            Exception('Platform not supported'),
            StackTrace.current,
          );
        }
      } else {
        return null;
      }
    } catch (e) {
      onImageError?.call(
        e,
        StackTrace.current,
      );
    }
    return null;
  }