import 'package:flutter/material.dart';
import 'package:image_input/image_input.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Image Input'),
        ),
        body: const AddPerson(),
      ),
    );
  }
}

class AddPerson extends StatefulWidget {
  const AddPerson({super.key});

  @override
  State<AddPerson> createState() => _AddPersonState();
}

class _AddPersonState extends State<AddPerson> {
  List<XFile> images = [];
  XFile? profileImage = XFile('path/to/your/file');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Person'),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          ProfileAvatar(
            radius: 100,
            allowEdit: true,
            backgroundColor: Colors.grey,
            image: profileImage,
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
              setState(() {
                profileImage = image!;
              });
            },
            onImageRemoved: () {
              setState(() {
                profileImage = null;
              });
            },
          ),
          Center(
            child: ImageInput(
              allowEdit: true,
              allowMaxImage: 5,
              initialImages: images,
              onImageSelected: (image, index) {
                //save image to cloud and get the url
                //or
                //save image to local storage and get the path
                String? tempPath = image.path;
                print(tempPath);
                setState(() {
                  images.add(image);
                });
              },
              onImageRemoved: (image, index) {
                setState(() {
                  images.removeAt(index);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
