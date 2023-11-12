import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class Invers extends StatefulWidget {
  const Invers({Key? key}) : super(key: key);

  @override
  State<Invers> createState() => _InversState();
}

class _InversState extends State<Invers> {
  File? imageFile;

  Future<void> selectImage() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);

      List<int> imageBytes = await imageFile.readAsBytes();
      img.Image image = img.decodeImage(Uint8List.fromList(imageBytes))!;

      img.invert(image);

      File invertedImageFile =
          File(imageFile.path.replaceFirst('.png', '_inverted.png'));
      invertedImageFile.writeAsBytesSync(img.encodePng(image));

      setState(() {
        this.imageFile = invertedImageFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 244,
                    decoration: const BoxDecoration(
                      color: Color(0xff5D79C2),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset('assets/top1.png'),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60, left: 25),
                child: Text(
                  "Invers",
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 40, top: 106),
                height: 316,
                width: 316,
                decoration: BoxDecoration(
                  color: Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: imageFile != null
                        ? FileImage(imageFile!)
                        : AssetImage('assets/top1.png')
                            as ImageProvider, // Gunakan AssetImage untuk gambar dari aset
                    fit: BoxFit.fill, // Atur sesuai kebutuhan Anda
                  ),
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: selectImage,
                child: Container(
                  margin: EdgeInsets.only(top: 96),
                  width: 200,
                  height: 42,
                  child: Center(
                    child: Text(
                      "Upload",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xff9BB2EC,
                    ),
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(top: 13),
                  width: 200,
                  height: 42,
                  child: Center(
                    child: Text(
                      "Next",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xff9BB2EC,
                    ),
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
