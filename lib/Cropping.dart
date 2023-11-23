import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';


class Cropping extends StatefulWidget {
  const Cropping({Key? key}) : super(key: key);

  @override
  State<Cropping> createState() => _CroppingState();
}

class _CroppingState extends State<Cropping> {
  File? imageFile;
  final ImageCropper _imageCropper = ImageCropper();

  Future<void> _cropImage() async {
    if (imageFile != null) {
      File? croppedFile = await _imageCropper.cropImage(
        sourcePath: imageFile!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        androidUiSettings: const AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );

      if (croppedFile != null) {
        setState(() {
          imageFile = croppedFile;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ... Bagian lain dari tata letak tetap sama

          GestureDetector(
            onTap: _pickImage, // Ganti dengan metode cropping
            child: Container(
              margin: const EdgeInsets.only(top: 96),
              width: 200,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(
                  0xff9BB2EC,
                ),
                borderRadius: BorderRadius.circular(
                  15,
                ),
              ),
              child: const Center(
                child: Text(
                  "Pick Image",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _cropImage, // Ganti dengan metode cropping
            child: Container(
              margin: const EdgeInsets.only(top: 13),
              width: 200,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(
                  0xff9BB2EC,
                ),
                borderRadius: BorderRadius.circular(
                  15,
                ),
              ),
              child: const Center(
                child: Text(
                  "Crop Image",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
