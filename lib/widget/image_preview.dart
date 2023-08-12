
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_input/widget/getImage/getImage.dart';
import 'package:image_picker/image_picker.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview({
    super.key,
    required this.images,
    required this.initialIndex,
    required this.isEdit,
  });
  final List<XFile> images;
  final int initialIndex;
  final bool isEdit;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool showHeaderFooter = true;
  int currentIndex = 0;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    currentIndex = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.grey.shade200,
        title: Text('${currentIndex + 1} / ${widget.images.length}'),
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
                itemCount: widget.images.length,
                scrollDirection: Axis.horizontal,
                dragStartBehavior: DragStartBehavior.down,
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                controller: PageController(initialPage: widget.initialIndex),
                itemBuilder: (context, index) {
                  ImageProvider<Object>? imageProvider = getImage(
                      widget.images[index],
                      widget.images[index].path,
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
                  onPressed: () {
                    Navigator.pop(context);
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
  }
}
