import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:kanker/HomeScreen.dart';

class Invers extends StatefulWidget {
  final String? grayscaleImagePath;

  const Invers({Key? key, this.grayscaleImagePath}) : super(key: key);

  @override
  State<Invers> createState() => _InversState();
}

class _InversState extends State<Invers> {
  File? imageFile;
  Uint8List? imageBytes;

  Future<void> invertImage() async {
    print("1");
    if (imageFile != null) {
      img.Image image = img.decodeImage(await imageFile!.readAsBytes())!;
      img.invert(image);

      print("2");

      File invertedImageFile =
          File(imageFile!.path.replaceFirst('.png', '_inverted.png'));
      invertedImageFile.writeAsBytesSync(img.encodePng(image));
      print("3");

      Uint8List invertedImageBytes = await invertedImageFile.readAsBytes();

      setState(() {
        imageBytes = invertedImageBytes;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.grayscaleImagePath != null) {
      imageFile = File(widget.grayscaleImagePath!);
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
              const Padding(
                padding: EdgeInsets.only(top: 60, left: 25),
                child: Text(
                  "Invers",
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 40, top: 106),
                height: 316,
                width: 316,
                decoration: BoxDecoration(
                  color: const Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: getImageProvider(),
                    fit: BoxFit.fill,
                  ),
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await invertImage();
                },
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
                      "Invers",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                },
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
                      "Next",
                      style: TextStyle(color: Colors.white),
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

  ImageProvider<Object> getImageProvider() {
    if (imageBytes != null) {
      return Image.memory(imageBytes!).image;
    } else if (widget.grayscaleImagePath != null) {
      return Image.file(File(widget.grayscaleImagePath!)).image;
    } else {
      return const AssetImage('assets/top1.png');
    }
  }
}
