// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:octo_image/octo_image.dart';

// Widget? getImageWeb(
//   String? imageUrl,
//   OctoProgressIndicatorBuilder? loadingBuilder,
//   ImageErrorWidgetBuilder? errorBuilder,
// ) {
//   try {
//     if (imageUrl != null) {
//       return OctoImage(
//         image: CachedNetworkImageProvider(
//           imageUrl,
//         ),
//         errorBuilder: errorBuilder,
//         fit: BoxFit.cover,
//         progressIndicatorBuilder: loadingBuilder,
//       );
//     } else {
//       return null;
//     }
//   } catch (e) {
//     rethrow;
//   }
// }
