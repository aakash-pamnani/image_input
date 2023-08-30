import 'package:flutter/material.dart';
import 'package:image_input/widget/getImage/getImage.dart';
import 'package:image_input/widget/image_preview.dart';
import 'package:image_picker/image_picker.dart';

/// A widget that allows the user to select multiple images.
///
/// If [initialImages] is not null, it will be used as the initial images.
///
/// If [allowEdit] is true, the user will be able to change the images.
///
class ImageInput extends StatefulWidget {
  const ImageInput({
    super.key,
    this.allowMaxImage = 1,
    this.imageSize = const Size(100, 100),
    this.imageSpacing = 10,
    this.addImageIcon = const Icon(Icons.camera_alt_outlined),
    this.addImageContainerDecoration,
    this.removeImageIcon = const Icon(Icons.close),
    this.imageContainerDecoration,
    this.onImageSelected,
    this.onImageRemoved,
    this.initialImages,
    this.allowEdit = true,
    this.getImageSource,
    // this.initialImagesFromNetwork,
    this.getPreferredCameraDevice,
    this.onImageError,
  });

  /// The initial images to display.
  final List<XFile>? initialImages;

  /// The maximum number of images that can be selected.
  final int allowMaxImage;

  /// Whether the user can add or remove the images.
  final bool allowEdit;

  /// The size of the image to display.
  final Size imageSize;

  /// The spacing between the images.
  final double imageSpacing;

  /// The icon to display when the user can add an image.
  final Widget addImageIcon;

  /// The decoration of add image container.
  final BoxDecoration? addImageContainerDecoration;

  /// The icon to display when the user can remove the image.
  final Widget removeImageIcon;

  /// The decoration of image container.
  final BoxDecoration? imageContainerDecoration;

  /// Called when the image selected by user.
  final void Function(XFile image, int index)? onImageSelected;

  /// Called when the image is removed.
  final void Function(XFile image, int index)? onImageRemoved;

  // final List<String>? initialImagesFromNetwork;

  /// Called when the user clicks the [addImageIcon].
  ///
  /// If null, the user will be prompted to select an image from the gallery.
  ///
  final Future<ImageSource> Function()? getImageSource;

  /// Called when the user clicks the [addImageIcon] and [getImageSource] is [ImageSource.camera].
  ///
  /// If null by default [CameraDevice.front] will be used.
  final Future<CameraDevice> Function()? getPreferredCameraDevice;

  /// Called when the image fails to load.
  final onError? onImageError;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  List<XFile> _images = [];
  ValueNotifier<List<XFile>>? imageChangeNotifier;

  final defaultDecoration = BoxDecoration(
    color: Colors.grey[300],
    borderRadius: const BorderRadius.all(
      Radius.circular(10),
    ),
  );

  @override
  void initState() {
    _images = widget.initialImages ?? [];
    // widget.initialImagesFromNetwork?.forEach((element) {
    //   _images.add(XFile(element));
    // });

    super.initState();
  }

  @override
  void didUpdateWidget(ImageInput oldWidget) {
    if (oldWidget.initialImages != widget.initialImages) {
      _images = widget.initialImages ?? [];
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      imageChangeNotifier?.value = _images;
    });
    return Wrap(
      spacing: widget.imageSpacing,
      runSpacing: widget.imageSpacing,
      children: [
        ..._getImageContainerList(),
        if (_images.length < widget.allowMaxImage && widget.allowEdit) ...[
          _getAddImageContainer(),
        ]
      ],
    );
  }

  Widget _getAddImageContainer() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          ImagePicker()
              .pickImage(
            source: await widget.getImageSource?.call() ?? ImageSource.gallery,
            preferredCameraDevice:
                await widget.getPreferredCameraDevice?.call() ?? CameraDevice.rear,
          )
              .then((value) {
            if (value != null) {
              // setState(() {
              //   _images.add(value);
              // });
              widget.onImageSelected?.call(value, _images.length - 1);
            }
          });
        },
        child: Container(
          height: widget.imageSize.height,
          width: widget.imageSize.width,
          decoration: widget.addImageContainerDecoration ?? defaultDecoration,
          child: Center(
            child: widget.addImageIcon,
          ),
        ),
      ),
    );
  }

  List<Widget> _getImageContainerList() {
    List<Widget> imagesContainer = [];

    for (var i = 0; i < _images.length; i++) {
      ImageProvider<Object>? imageProvider =
          getImage(_images[i], _images[i].path, widget.onImageError);
      imagesContainer.add(
        Stack(
          children: [
            GestureDetector(
              onTap: () {
                imageChangeNotifier = ValueNotifier(_images);
                Navigator.push<List<XFile>>(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ImagePreview(
                        imageNotifier: imageChangeNotifier!,
                        initialIndex: i,
                        isEdit: widget.allowEdit,
                        onImageDeleted: widget.onImageRemoved,
                        // setState(() {
                        //   _images.removeAt(index);
                        // });
                      );
                    },
                  ),
                ).then((value) {
                  imageChangeNotifier = null;
                });
              },
              child: Container(
                height: widget.imageSize.height,
                width: widget.imageSize.width,
                decoration:
                    widget.imageContainerDecoration ?? defaultDecoration,
                child: Center(
                  child: imageProvider != null
                      ? Image(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        )
                      : const SizedBox(),
                ),
              ),
            ),
            if (widget.allowEdit)
              Positioned(
                top: 5,
                right: 5,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      widget.onImageRemoved?.call(_images[i], i);
                      // setState(() {
                      //   _images.removeAt(i);
                      // });
                    },
                    child: widget.removeImageIcon,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return imagesContainer;
  }
}
