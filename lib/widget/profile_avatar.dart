import 'package:flutter/material.dart';
import 'package:image_input/widget/getImage/getImage.dart';
import 'package:image_picker/image_picker.dart';

/// A widget that displays a circle avatar with an image.
///
/// If [image] is not null, it will be used as the image.
///
/// If [imageUrl] is not null, it will be used as the image url.
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
    this.onImageError,
    this.getImageSource,
    this.getPreferredCameraDevice,
  }) : assert(!((image != null) && (imageUrl != null)),
            'You must provide either image or imageUrl');

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

  /// The radius of the circle avatar.
  final double radius;

  /// The background color of the circle avatar.
  final Color? backgroundColor;

  /// Called when the image selected by user.
  final void Function(XFile? image)? onImageChanged;

  /// Called when the image is removed.
  final void Function()? onImageRemoved;

  /// Called when the image fails to load.
  final onError? onImageError;

  /// Called when the user clicks the [addImageIcon].
  ///
  /// If null, the user will be prompted to select an image from the gallery.
  ///
  final Future<ImageSource> Function()? getImageSource;

  /// Called when the user clicks the [addImageIcon] and [getImageSource] is [ImageSource.camera].
  ///
  /// If null by default [CameraDevice.front] will be used.
  final Future<CameraDevice> Function()? getPreferredCameraDevice;

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  XFile? image;
  @override
  void initState() {
    image = widget.image;
    super.initState();
  }

  @override
  void didUpdateWidget(ProfileAvatar oldWidget) {
    if (oldWidget.image != widget.image) {
      image = widget.image;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    image = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: SizedBox(
        width: widget.radius * 2,
        height: widget.radius * 2,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              backgroundColor: widget.backgroundColor ??
                  Theme.of(context).colorScheme.secondaryContainer,
              radius: widget.radius,
              backgroundImage:
                  getImage(image, widget.imageUrl, widget.onImageError),
              onBackgroundImageError: widget.onImageError,
            ),
            if (image != null && widget.allowEdit)
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
                      await picker
                          .pickImage(
                        source: await widget.getImageSource?.call() ??
                            ImageSource.gallery,
                        preferredCameraDevice:
                            await widget.getPreferredCameraDevice?.call() ??
                                CameraDevice.front,
                        imageQuality: 50,
                      )
                          .then<void>(
                        (XFile? value) {
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
    );
  }
}
