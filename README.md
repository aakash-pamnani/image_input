<h1 align="center">Image Input</h1>
<p align="center">A flutter package which.</p><br>

<p align="center">
  <a href="https://flutter.dev">
    <img src="https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter"
      alt="Platform" />
  </a>
  <a href="https://pub.dartlang.org/packages/image_input">
    <img src="https://img.shields.io/pub/v/image_input.svg"
      alt="Pub Package" />
  </a>
  <br>
  <a href="https://opensource.org/license/bsd-3-clause">
    <img src="https://img.shields.io/github/license/aakash-pamnani/image_input?color=red"
      alt="License: BSD-3" />
  </a>
  <a href="https://buymeacoffee.com/aakashpp">
    <img height=20 src="https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black"
      alt="Donate" />
  </a>
</p><br>

<table>
<tr>
<td><img src="https://raw.githubusercontent.com/aakash-pamnani/image_input/master/video/profile_avatar.gif" /></td>
      
<td><img src="https://raw.githubusercontent.com/aakash-pamnani/image_input/master/video/image_input.gif" /></td>
      </tr>
      <tr>
<td><img src="https://raw.githubusercontent.com/aakash-pamnani/image_input/master/video/list.gif" /></td>
      <tr>
</table>
<br>

## Getting Started

### Import image_input package

```dart
import 'package:image_input/image_input.dart';
```

## Profile Avatar

```dart
ProfileAvatar(
        image: profileAvatarCurrentImage,
        radius: 100,
        allowEdit: allowEdit,
        addImageIcon: Container(
            decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(100),
            ),
            child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.add_a_photo),
            ),
        ),
        removeImageIcon: Container(
            decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(100),
            ),
            child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.close),
            ),
        ),
        onImageChanged: (XFile? image) {
            setState(() {
            profileAvatarCurrentImage = image;
            });
        },
        onImageRemoved: () {
            setState(() {
            profileAvatarCurrentImage = null;
            });
        },
        getImageSource: () {
            return showDialog<ImageSource>(
            context: context,
            builder: (context) {
                return SimpleDialog(
                children: [
                    SimpleDialogOption(
                    child: const Text("Camera"),
                    onPressed: () {
                        Navigator.of(context).pop(ImageSource.camera);
                    },
                    ),
                    SimpleDialogOption(
                        child: const Text("Gallery"),
                        onPressed: () {
                        Navigator.of(context).pop(ImageSource.gallery);
                        }),
                ],
                );
            },
            ).then((value) {
            return value ?? ImageSource.gallery;
            });
        },
        getPreferredCameraDevice: () {
            return showDialog<CameraDevice>(
            context: context,
            builder: (context) {
                return SimpleDialog(
                children: [
                    SimpleDialogOption(
                    child: const Text("Rear"),
                    onPressed: () {
                        Navigator.of(context).pop(CameraDevice.rear);
                    },
                    ),
                    SimpleDialogOption(
                        child: const Text("Front"),
                        onPressed: () {
                        Navigator.of(context).pop(CameraDevice.front);
                        }),
                ],
                );
            },
            ).then(
            (value) {
                return value ?? CameraDevice.rear;
            },
            );
        },
        ),
```

### Usage of Profile Avatar

- Use in listview to show profile images.
- use in creating a new user to take profile image input from user.

## ImageInput

```dart
ImageInput(
    images: imageInputImages,
    allowEdit: allowEditImageInput,
    allowMaxImage: 5,
    onImageSelected: (image, index) {
    setState(() {
        imageInputImages.add(image);
    });
    },
    onImageRemoved: (image, index) {
    setState(() {
        imageInputImages.remove(image);
    });
    },
),
```

### Usage of Image Input

- Use to show/preview multiple images from a path
- Use to take input of multiple images from user

## Issues

Please file issues, bugs, or feature requests in [issue tracker](https://github.com/aakash-pamnani/image_input/issues).
