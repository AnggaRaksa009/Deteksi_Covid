import 'package:flutter/material.dart';
import 'package:kanker/Image_Picker.dart';
import 'package:kanker/app.dart';
import 'package:kanker/test.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? imageFile;

  Future<void> selectImage() async {
    final XFile? pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void clearImage() {
    setState(() {
      imageFile = null;
    });
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
                        : AssetImage('assets/iconSplash.png')
                            as ImageProvider, // Gunakan AssetImage untuk gambar dari aset
                    fit: BoxFit.fill, // Atur sesuai kebutuhan Anda
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 82),
            width: 267,
            height: 48,
            decoration: BoxDecoration(
                color: Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(12)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  selectImage();
                },
                child: Container(
                  margin: EdgeInsets.only(top: 96),
                  width: 144,
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
              const SizedBox(
                width: 28,
              ),
              GestureDetector(
                onTap: clearImage,
                child: Container(
                  margin: EdgeInsets.only(top: 96),
                  width: 144,
                  height: 42,
                  child: Center(
                    child: Text(
                      "Hapus",
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => test(),
                ),
              );
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 31),
              width: 200,
              height: 42,
              child: Column(
                children: [
                  ImageClassificationScreen(),
                ],
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
    );
  }
}
