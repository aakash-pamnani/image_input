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
          title: const Text('Image INput'),
        ),
        body: const AddPerson(),
      ),
    );
  }
}

class AddPerson extends StatelessWidget {
  const AddPerson({super.key});

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
          ),
          Center(
            child: ImageInput(
              allowEdit: true,
              allowMaxImage: 5,
              onImageSelected: (image, index) {
                //save image to cloud and get the url
                //or
                //save image to local storage and get the path
                String? tempPath = image.path;
                print(tempPath);
              },
            ),
          ),
        ],
      ),
    );
  }
}
