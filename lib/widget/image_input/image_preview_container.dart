part of "image_input.dart";

class ImagePreviewContainer extends StatefulWidget {
  const ImagePreviewContainer({
    super.key,
    required this.image,
    this.loadingBuilder,
    required this.index,
    required this.fit,
    required this.allowEdit,
    required this.imageSize,
    required this.onImageRemoved,
    required this.imageContainerDecoration,
    required this.removeImageIcon,
    this.onTap,
  });

  final int index;
  final OctoProgressIndicatorBuilder? loadingBuilder;
  final bool allowEdit;
  final Size imageSize;
  final Function(XFile, int)? onImageRemoved;
  final Decoration? imageContainerDecoration;
  final XFile? image;
  final Widget removeImageIcon;
  final Function? onTap;
  final BoxFit fit;

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
      scale: 0.5,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (imageProvider != null) {
        // await precacheImage(imageProvider!, context);
      }
    });

    super.initState();
  }

  @override
  void didUpdateWidget(covariant ImagePreviewContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // precacheImage(imageProvider!, context);

    if (widget.image != oldWidget.image) {
      imageProvider = getImageProvider(widget.image, "", scale: 0.5);
    }
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
                      memCacheWidth: 500,
                      fit: widget.fit,
                      progressIndicatorBuilder: (context, progress) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
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
