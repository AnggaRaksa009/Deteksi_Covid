import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImage() async {
  final imagePicker = ImagePicker();
  final XFile? pickedImage =
      await imagePicker.pickImage(source: ImageSource.gallery);

  return pickedImage;
}
