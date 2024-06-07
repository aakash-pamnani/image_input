import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:image_input/widget/getImage/get_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:octo_image/octo_image.dart';

/// A widget that displays a circle avatar with an image.
///
/// If [image] is not null, it will be used as the image.
///
/// If [imageUrl] is not null, it will be used as the image url, but if [image] is not null [imageUrl] will be ignored.
///
/// If [allowEdit] is true, the user will be able to change the image.
///

class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({
    super.key,
    this.image,
    this.imageUrl,
    this.allowEdit = false,
    this.onImageChanged,
    this.radius = 20,
    this.onImageRemoved,
    this.backgroundColor,
    this.addImageIcon = const Icon(Icons.add_a_photo_outlined),
    this.addImageIconAlignment = Alignment.bottomRight,
    this.removeImageIcon = const Icon(Icons.close),
    this.removeImageIconAlignment = Alignment.topRight,
    this.loadingBuilder,
    this.getImageSource,
    this.getPreferredCameraDevice,
    this.errorBuilder,
  });

  /// The image to display.
  final XFile? image;

  /// The image url to display.
  final String? imageUrl;

  /// Whether the user can add or remove the image.
  final bool allowEdit;

  /// The icon to display when the user can add an image.
  final Widget addImageIcon;

  /// The alignment of the [addImageIcon].
  final Alignment addImageIconAlignment;

  /// The icon to display when the user can remove the image.
  final Widget removeImageIcon;

  /// The alignment of the [removeImageIcon].
  final Alignment removeImageIconAlignment;

  /// The radius of the circle.
  final double radius;

  /// The background color of the circle avatar.
  final Color? backgroundColor;

  /// Called when the image selected by user.
  final void Function(XFile? image)? onImageChanged;

  /// Called when the image is removed.
  final void Function()? onImageRemoved;

  /// This builder will be used to show a widget while the image is loading.
  ///
  /// Example:
  /// ```dart
  /// (context, progress) {
  ///   return CircularProgressIndicator();
  /// }
  /// ```
  final OctoProgressIndicatorBuilder? loadingBuilder;

  /// Called when the user clicks the [addImageIcon].
  ///
  /// If null, the user will be prompted to select an image from the gallery by default.
  ///
  ///Example:
  /// ```dart
  /// getImageSource: () {
  ///     return showDialog<ImageSource>(
  ///       context: context,
  ///       builder: (context) {
  ///         return SimpleDialog(
  ///           children: [
  ///             SimpleDialogOption(
  ///               child: const Text("Camera"),
  ///               onPressed: () {
  ///                 Navigator.of(context).pop(ImageSource.camera);
  ///               },
  ///             ),
  ///             SimpleDialogOption(
  ///                 child: const Text("Gallery"),
  ///                 onPressed: () {
  ///                   Navigator.of(context).pop(ImageSource.gallery);
  ///                 }),
  ///           ],
  ///         );
  ///       },
  ///     ).then((value) {
  ///       return value ?? ImageSource.gallery;
  ///     });
  ///   },
  /// ),
  /// ```
  final Future<ImageSource> Function()? getImageSource;

  /// Called when the user clicks the [addImageIcon] and [getImageSource] is [ImageSource.camera].
  ///
  /// If null by default [CameraDevice.front] will be used.
  ///
  /// Add the required camera permission in your OS files to use Camera
  ///
  /// Example:
  /// ```dart
  /// getPreferredCameraDevice: () {
  ///   return showDialog<CameraDevice>(
  ///     context: context,
  ///     builder: (context) {
  ///       return SimpleDialog(
  ///         children: [
  ///           SimpleDialogOption(
  ///             child: const Text("Rear"),
  ///             onPressed: () {
  ///               Navigator.of(context).pop(CameraDevice.rear);
  ///             },
  ///           ),
  ///           SimpleDialogOption(
  ///               child: const Text("Front"),
  ///               onPressed: () {
  ///                 Navigator.of(context).pop(CameraDevice.front);
  ///               }),
  ///         ],
  ///       );
  ///     },
  ///   ).then(
  ///     (value) {
  ///       return value ?? CameraDevice.rear;
  ///     },
  ///   );
  /// },
  /// ```
  final Future<CameraDevice> Function()? getPreferredCameraDevice;

  /// This widget will be displayed when the image fails to load.
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  late ImageProvider? image;

  @override
  void initState() {
    image = getImageProvider(widget.image, widget.imageUrl);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ProfileAvatar oldWidget) {
    if (widget.image != oldWidget.image ||
        widget.imageUrl != oldWidget.imageUrl) {
      image = getImageProvider(widget.image, widget.imageUrl);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(DiagnosticsProperty<XFile?>('image', widget.image));
    properties.add(DiagnosticsProperty<String?>('imageUrl', widget.imageUrl));
    properties.add(DiagnosticsProperty<bool>('allowEdit', widget.allowEdit));
    properties
        .add(DiagnosticsProperty<Widget>('addImageIcon', widget.addImageIcon));
    properties.add(DiagnosticsProperty<Alignment>(
        'addImageIconAlignment', widget.addImageIconAlignment));
    properties.add(
        DiagnosticsProperty<Widget>('removeImageIcon', widget.removeImageIcon));
    properties.add(DiagnosticsProperty<Alignment>(
        'removeImageIconAlignment', widget.removeImageIconAlignment));
    properties.add(DiagnosticsProperty<double>('radius', widget.radius));
    properties.add(
        DiagnosticsProperty<Color?>('backgroundColor', widget.backgroundColor));
    properties.add(DiagnosticsProperty<OctoProgressIndicatorBuilder?>(
        'loadingBuilder', widget.loadingBuilder));
    properties.add(DiagnosticsProperty<Future<ImageSource> Function()?>(
        'getImageSource', widget.getImageSource));
    properties.add(DiagnosticsProperty<Future<CameraDevice> Function()?>(
        'getPreferredCameraDevice', widget.getPreferredCameraDevice));
    properties.add(DiagnosticsProperty<ImageErrorWidgetBuilder?>(
        'errorBuilder', widget.errorBuilder));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.radius * 2,
      height: widget.radius * 2,
      child: Center(
        child: SizedBox(
          height: widget.radius * 2,
          width: widget.radius * 2,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                duration: kThemeChangeDuration,
                decoration: BoxDecoration(
                  color: widget.backgroundColor ??
                      Theme.of(context).colorScheme.secondaryContainer,
                  // borderRadius: BorderRadius.circular(widget.radius),
                  shape: BoxShape.circle,
                ),
                width: widget.radius * 2,
                height: widget.radius * 2,
                child: ClipOval(
                    // child: getImage(
                    //   widget.image,
                    //   widget.imageUrl,
                    //   errorBuilder: widget.errorBuilder,
                    //   loadingBuilder: widget.loadingBuilder,
                    // ),
                    child: image != null
                        ? OctoImage(
                            image: image!,
                            errorBuilder: widget.errorBuilder,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder: widget.loadingBuilder,
                          )
                        : null),
                // onBackgroundImageError: widget.onImageError,
              ),
              if ((widget.image != null || widget.imageUrl != null) &&
                  widget.allowEdit)
                Align(
                  alignment: widget.removeImageIconAlignment,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        widget.onImageRemoved?.call();
                        // setState(() {
                        //   image = null;
                        // });
                      },
                      child: widget.removeImageIcon,
                    ),
                  ),
                ),
              if (widget.allowEdit)
                Align(
                  alignment: widget.addImageIconAlignment,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final source = await widget.getImageSource?.call() ??
                            ImageSource.gallery;
                        await picker
                            .pickImage(
                          source: source,
                          preferredCameraDevice: source == ImageSource.camera
                              ? await widget.getPreferredCameraDevice?.call() ??
                                  CameraDevice.front
                              : CameraDevice.front,
                        )
                            .then<void>(
                          (XFile? value) {
                            if (value == null) return;
                            widget.onImageChanged?.call(value);
                            // setState(() {
                            //   if (value != null) {
                            //     image = value;
                            //   }
                            // });
                          },
                        );
                      },
                      child: widget.addImageIcon,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
