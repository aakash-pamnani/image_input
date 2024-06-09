import 'package:flutter/material.dart';
import 'package:image_input/image_input.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileAvatar'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _index = value;
          });
        },
        currentIndex: _index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Profile Avatar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Image Input',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: [
          const ProfileAvatarExample(),
          const ImageInputExample(),
          const PersonList(),
        ],
      ),
    );
  }
}

class ProfileAvatarExample extends StatefulWidget {
  const ProfileAvatarExample({super.key});

  @override
  State<ProfileAvatarExample> createState() => _ProfileAvatarExampleState();
}

class _ProfileAvatarExampleState extends State<ProfileAvatarExample> {
  XFile? profileAvatarCurrentImage;
  bool allowEdit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                shape: const RoundedRectangleBorder(),
                title: const Text("Options"),
                children: [
                  Row(
                    children: [
                      const Text("Allow Edit"),
                      const SizedBox(
                        width: 20,
                      ),
                      Switch(
                        value: allowEdit,
                        onChanged: (value) {
                          setState(() {
                            allowEdit = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              "Profile Avatar",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
            getImageSource: () async => await getImageSource(context),
            getPreferredCameraDevice: () async =>
                await getPrefferedCameraDevice(context),
          ),
        ],
      ),
    );
  }
}

class ImageInputExample extends StatefulWidget {
  const ImageInputExample({super.key});

  @override
  State<ImageInputExample> createState() => _ImageInputExampleState();
}

class _ImageInputExampleState extends State<ImageInputExample> {
  List<XFile> imageInputImages = [];
  bool allowEditImageInput = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                shape: const RoundedRectangleBorder(),
                title: const Text("Options"),
                children: [
                  Row(
                    children: [
                      const Text("Allow Edit"),
                      const SizedBox(
                        width: 20,
                      ),
                      Switch(
                        value: allowEditImageInput,
                        onChanged: (value) {
                          setState(() {
                            allowEditImageInput = value;
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const Center(
            child: Text(
              "Image Input",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: ImageInput(
              images: imageInputImages,
              allowEdit: allowEditImageInput,
              allowMaxImage: 5,
              getPreferredCameraDevice: () async =>
                  await getPrefferedCameraDevice(context),
              getImageSource: () async => await getImageSource(context),
              onImageSelected: (image) {
                setState(() {
                  imageInputImages.add(image);
                });
              },
              onImageRemoved: (image, index) {
                setState(() {
                  imageInputImages.remove(image);
                });
              },
              loadingBuilder: (context, progress) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PersonList extends StatefulWidget {
  const PersonList({super.key});

  @override
  State<PersonList> createState() => _PersonListState();
}

class _PersonListState extends State<PersonList> {
  List<Person> persons = personsDummyData;

  bool showLoading = false;
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text("Show Error"),
                  const SizedBox(
                    width: 20,
                  ),
                  Switch(
                    value: showError,
                    onChanged: (value) {
                      setState(() {
                        showError = value;
                        showLoading != value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: ListView.builder(
              itemCount: persons.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ProfileAvatar(
                          radius: 40,
                          allowEdit: false,
                          imageUrl:
                              "${showError ? "error" : ""}https://source.unsplash.com/random/?index=${index + 1}",
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                          loadingBuilder: (context, progress) {
                            return const CircularProgressIndicator();
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(persons[index].name),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Person {
  String name;
  String image;
  Person({
    required this.name,
    required this.image,
  });
}

List<Person> personsDummyData = [
  Person(name: "Aakash", image: "https://i.imgur.com/EuYpGcx.jpg"),
  Person(name: "Bella", image: "https://i.imgur.com/iOeUBV7.jpg"),
  Person(name: "Chris", image: "https://i.imgur.com/mC6IFoV.jpg"),
  Person(name: "Diana", image: "https://i.imgur.com/GWfzDwK.jpg"),
  Person(name: "Elijah", image: "https://i.imgur.com/7Gk1W1z.jpg"),
  Person(name: "Fiona", image: "https://i.imgur.com/CeIbtpv.jpg"),
  Person(name: "George", image: "https://i.imgur.com/cDLuYI6.jpg"),
  Person(name: "Hannah", image: "https://i.imgur.com/zGBuOYM.jpg"),
  Person(name: "Isaac", image: "https://i.imgur.com/PrS3Rq9.jpg"),
  Person(name: "Julia", image: "https://i.imgur.com/4BaA60n.jpg"),
];

var getImageSource = (BuildContext context) {
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
};

var getPrefferedCameraDevice = (BuildContext context) async {
  var status = await Permission.camera.request();
  if (status.isDenied) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Allow Camera Permission"),
      ),
    );
    return null;
  }
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
};
