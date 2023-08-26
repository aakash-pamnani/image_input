import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_input/widget/getImage/getImage.dart';
import 'package:image_picker/image_picker.dart';

// setstate should be called by user
class ImagePreview extends StatefulWidget {
  const ImagePreview({
    super.key,
    required this.imageNotifier,
    required this.initialIndex,
    required this.isEdit,
    this.onImageDeleted,
  });
  final ValueNotifier<List<XFile>> imageNotifier;
  final int initialIndex;
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
    widget.imageNotifier.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ImagePreview oldWidget) {
    if (widget.initialIndex != oldWidget.initialIndex) {
      currentIndex = widget.initialIndex;
      _pageController = PageController(initialPage: widget.initialIndex);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.imageNotifier,
        builder: (context, images, child) {
          return Scaffold(
            appBar: AppBar(
              // backgroundColor: Colors.grey.shade200,
              title: Text('${currentIndex + 1} / ${images.length}'),
            ),
            backgroundColor: showHeaderFooter ? Colors.white : Colors.black,
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
                  InteractiveViewer(
                    child: PageView.builder(
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
                        ImageProvider<Object>? imageProvider = getImage(
                            images[index],
                            images[index].path,
                            (exception, stackTrace) {});
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Stack(
                            children: [
                              Center(
                                child: imageProvider != null
                                    ? Image(image: imageProvider)
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  AnimatedPositionedDirectional(
                    duration: const Duration(milliseconds: 300),
                    bottom: showHeaderFooter ? 0 : -100,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black.withOpacity(0.5),
                      child: IconButton(
                        onPressed: () async {
                          int deletedIndex = currentIndex;
                          if (currentIndex > 0) {
                            _pageController.animateToPage(currentIndex - 1,
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
                            const Duration(milliseconds: 400),
                            () {
                              widget.onImageDeleted
                                  ?.call(images[deletedIndex], deletedIndex);
                              if (images.isEmpty) {
                                Navigator.pop(context);
                              }
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
