import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_input/widget/getImage/get_image.dart';
import 'package:image_input/widget/image_input/image_preview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:octo_image/octo_image.dart';

part "image_preview_container.dart";

/// A widget that allows the user to select multiple images.
///
/// If [images] is not null, it will be used as the initial images.
///
/// If [allowEdit] is true, the user will be able to change the images.
///
class ImageInput extends StatefulWidget {
  const ImageInput({
    super.key,
    this.allowMaxImage = 1,
    this.imageSize = const Size(100, 100),
    this.spacing = 10,
    this.runSpacing = 10,
    this.addImageIcon = const Icon(Icons.camera_alt_outlined),
    this.addImageContainerDecoration,
    this.removeImageIcon = const Icon(Icons.close),
    this.imageContainerDecoration,
    this.onImageSelected,
    this.onImageRemoved,
    this.images,
    // this.imagesFromNetwork,
    this.allowEdit = true,
    this.getImageSource,
    this.getPreferredCameraDevice,
    this.errorBuilder,
  });

  /// The images to display.
  final List<XFile>? images;

  /// The images to display from network.
  // final List<String>? imagesFromNetwork;

  /// The maximum number of images that can be selected.
  final int allowMaxImage;

  /// Whether the user can add or remove the images.
  final bool allowEdit;

  /// The size of the image to display.
  final Size imageSize;

  /// The spacing between the images.
  final double spacing;

  /// How much space to place between the runs themselves in the cross axis.
  ///
  ///For example, if [runSpacing] is 10.0, the runs will be spaced at least 10.0 logical pixels apart in the cross axis.
  final double runSpacing;

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
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  List<XFile> _images = [];
  List<String> _imagesFromNetwork = [];

  late ValueNotifier<List<XFile>> imageChangeNotifier;
  late ValueNotifier<List<String>> imageChangeNotifierFromNetwork;

  final defaultDecoration = BoxDecoration(
    color: Colors.grey[300],
    borderRadius: const BorderRadius.all(
      Radius.circular(10),
    ),
  );

  @override
  void initState() {
    _images = widget.images?.toList() ?? [];
    // _imagesFromNetwork = widget.imagesFromNetwork?.toList() ?? [];
    imageChangeNotifier = ValueNotifier(_images);
    imageChangeNotifierFromNetwork = ValueNotifier(_imagesFromNetwork);
    super.initState();
  }

  @override
  void didUpdateWidget(ImageInput oldWidget) {
    if (!listEquals(oldWidget.images, _images)) {
      _images = widget.images?.toList() ?? [];
      // imageChangeNotifier.value = _images;
    }
    // if (!listEquals(oldWidget.imagesFromNetwork, _imagesFromNetwork)) {
    //   _imagesFromNetwork = widget.imagesFromNetwork?.toList() ?? [];
    // }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    imageChangeNotifier.dispose();
    imageChangeNotifierFromNetwork.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert((widget.images?.length ?? 0) <= widget.allowMaxImage,
        "The images.length should be less than or equal to widget.allowMaxImage");
    Future.delayed(Duration.zero, () {
      imageChangeNotifier.value = _images;
      imageChangeNotifierFromNetwork.value = _imagesFromNetwork;
    });
    return Wrap(
      spacing: widget.spacing,
      runSpacing: widget.runSpacing,
      children: [
        // ..._getImageContainerList(),
        for (int i = 0; i < _images.length; i++) ...[
          ImagePreviewContainer(
            index: i,
            allowEdit: widget.allowEdit,
            removeImageIcon: widget.removeImageIcon,
            onImageRemoved: widget.onImageRemoved,
            imageContainerDecoration: widget.imageContainerDecoration,
            imageSize: widget.imageSize,
            image: _images[i],
            onTap: () {
              Navigator.push<List<XFile>>(
                context,
                MaterialPageRoute(
                  maintainState: false,
                  builder: (context) {
                    return ImagePreview(
                      images: imageChangeNotifier,
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
                // imageChangeNotifier = null;
              });
            },
          ),
        ],
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
                await widget.getPreferredCameraDevice?.call() ??
                    CameraDevice.rear,
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
}
