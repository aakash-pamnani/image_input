import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_input/util/get_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:octo_image/octo_image.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview({
    super.key,
    required this.images,
    required this.initialIndex,
    required this.isEdit,
    this.loadingBuilder,
    this.onImageDeleted,
  });
  final ValueNotifier<List<XFile>> images;
  final int initialIndex;
  final OctoProgressIndicatorBuilder? loadingBuilder;
  final bool isEdit;
  final void Function(XFile image, int index)? onImageDeleted;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late PageController _pageController;
  bool showHeaderFooter = true;
  int currentIndex = 0;

  @override
  void initState() {
    // images = widget.images.value;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.images,
        builder: (context, images, child) {
          if (images.isEmpty) {
            Future.delayed(Duration.zero, () {
              Navigator.pop(context);
            });
          }
          if (currentIndex > images.length - 1) {
            currentIndex -= 1;
          }
          return Scaffold(
            appBar: AppBar(
              // backgroundColor: Colors.grey.shade200,
              // toolbarHeight: showHeaderFooter ? kToolbarHeight : 0,
              title: Text('${currentIndex + 1} / ${images.length}'),
            ),
            // backgroundColor: showHeaderFooter ? Colors.white : Colors.black,
            body: GestureDetector(
              onTap: () {
                setState(() {
                  showHeaderFooter = !showHeaderFooter;
                  if (!showHeaderFooter) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }
                });
              },
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: images.length,
                    scrollDirection: Axis.horizontal,
                    dragStartBehavior: DragStartBehavior.down,
                    onPageChanged: (value) {
                      setState(() {
                        currentIndex = value;
                      });
                    },
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      ImageProvider? imageProvider = getImageProvider(
                        images[index],
                        images[index].path,
                      );
                      return Center(
                        child: imageProvider != null
                            ? InteractiveViewer(
                                clipBehavior: Clip.none,
                                child: OctoImage(
                                  image: imageProvider,
                                  memCacheWidth: 1000,
                                  progressIndicatorBuilder:
                                      widget.loadingBuilder,
                                  // fit: BoxFit.fitWidth,
                                ),
                              )
                            : const SizedBox(),
                      );
                    },
                  ),
                  AnimatedPositionedDirectional(
                    duration: const Duration(milliseconds: 300),
                    bottom: showHeaderFooter ? 0 : -100,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black.withOpacity(0.5),
                      child: images.isNotEmpty
                          ? IconButton(
                              onPressed: () async {
                                int deletedIndex = currentIndex;
                                if (currentIndex > 0) {
                                  _pageController.animateToPage(
                                      currentIndex - 1,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeIn);
                                }
                                // else if (widget.images.length > 1) {
                                //   _pageController.animateToPage(currentIndex - 1,
                                //       duration: const Duration(
                                //         milliseconds: 300,
                                //       ),
                                //       curve: Curves.easeIn);
                                // }
                                await Future.delayed(
                                  const Duration(milliseconds: 0),
                                  () {
                                    if (images.isNotEmpty) {
                                      widget.onImageDeleted?.call(
                                          images[deletedIndex], deletedIndex);
                                    }
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
