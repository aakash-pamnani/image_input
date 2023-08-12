# Image_input

[![pub package](https://img.shields.io/pub/v/image_input.svg)](https://pub.dev/packages/image_input)

A pacakage to be used for image input in flutter.

<!-- ![image_input_example](./video/image_input.gif/?raw=true) -->

## Getting Started

### Import image_input package

```dart
import 'package:image_input/image_input.dart';
```

## Profile Avatar

```dart
    ProfileAvatar(
        radius: 100,
        allowEdit: true,
        backgroundColor: Colors.grey,
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
            //save image to cloud and get the url
            //or
            //save image to local storage and get the path
            String? tempPath = image?.path;
            print(tempPath);
        },
    )
```

### Usage of Profile Avatar

- Use in listview to show profile images.
- use in creating a new user to take profile image input from user.

## ImageInput

```dart
    ImageInput(
        allowEdit: true,
        allowMaxImage: 5,
        onImageSelected: (image, index) {
        //save image to cloud and get the url
        //or
        //save image to local storage and get the path
        String? tempPath = image?.path;
        print(tempPath);
        },
    ),
```

### Usage of Image Input

- Use to show/preview multiple images from a path
- Use to take input of multiple images from user

## Issues

Please file issues, bugs, or feature requests in [issue tracker](https://github.com/aakash-pamnani/image_input/issues).
