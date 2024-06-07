part of "image_input.dart";

class ImagePreviewContainer extends StatefulWidget {
  const ImagePreviewContainer({
    super.key,
    required this.image,
    required this.index,
    required this.allowEdit,
    required this.imageSize,
    required this.onImageRemoved,
    required this.imageContainerDecoration,
    required this.removeImageIcon,
    this.onTap,
  });

  final int index;
  final bool allowEdit;
  final Size imageSize;
  final Function(XFile, int)? onImageRemoved;
  final Decoration? imageContainerDecoration;
  final XFile? image;
  final Widget removeImageIcon;
  final Function? onTap;

  @override
  State<ImagePreviewContainer> createState() => _ImagePreviewContainerState();
}

class _ImagePreviewContainerState extends State<ImagePreviewContainer> {
  ImageProvider? imageProvider;

  final defaultDecoration = BoxDecoration(
    color: Colors.grey[300],
    borderRadius: const BorderRadius.all(
      Radius.circular(10),
    ),
  );

  @override
  void initState() {
    imageProvider = getImageProvider(
      widget.image,
      "",
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ImagePreviewContainer oldWidget) {
    if (widget.image != oldWidget.image) {
      imageProvider = getImageProvider(
        widget.image,
        "",
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              widget.onTap?.call();
              // imageChangeNotifier = ValueNotifier(_images);
            },
            child: Container(
              height: widget.imageSize.height,
              width: widget.imageSize.width,
              decoration: widget.imageContainerDecoration ?? defaultDecoration,
              child: imageProvider == null
                  ? const SizedBox.shrink()
                  : OctoImage(
                      image: imageProvider!,
                    ),
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
                  widget.onImageRemoved?.call(widget.image!, widget.index);
                  // setState(() {
                  //   _images.removeAt(i);
                  // });
                },
                child: widget.removeImageIcon,
              ),
            ),
          ),
      ],
    );
  }
}
