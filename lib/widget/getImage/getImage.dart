import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_input/widget/getImage/getImageIo.dart';
import 'package:image_input/widget/getImage/getImageWeb.dart';
import 'package:image_picker/image_picker.dart';

typedef onError = void Function(Object exception, StackTrace? stackTrace);

ImageProvider<Object>? getImage(
    XFile? image, String? imageUrl, onError? onError) {
  if (kIsWeb) {
    return getImageWeb(image?.path ?? imageUrl, onError);
  } else {
    return getImageIo(image, imageUrl, onError);
  }
}
