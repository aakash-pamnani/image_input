import 'package:image_picker/image_picker.dart';

typedef GetImageSource = Future<ImageSource?> Function();
typedef GetPreferredCameraDevice = Future<CameraDevice?> Function();
typedef OnImageChanged = void Function(XFile value);

Future<void> pickImage(
    GetImageSource? getImageSource,
    GetPreferredCameraDevice? getPreferredCameraDevice,
    OnImageChanged? onImageChanged) async {
  final ImagePicker picker = ImagePicker();
  ImageSource? source = ImageSource.gallery;
  if (getImageSource != null) {
    source = await getImageSource();
    if (source == null) return;
  }
  CameraDevice? preferredCameraDevice = CameraDevice.rear;
  if (source == ImageSource.camera) {
    preferredCameraDevice = await getPreferredCameraDevice?.call();
    if (preferredCameraDevice == null) {
      return;
    }
  }
  await picker
      .pickImage(
    source: source,
    preferredCameraDevice: preferredCameraDevice,
  )
      .then<void>(
    (XFile? value) {
      if (value == null) return;
      onImageChanged?.call(value);
    },
  );
}
