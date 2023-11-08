import 'package:flutter/material.dart';
import 'package:kanker/Image_Picker.dart';
import 'package:kanker/api.dart';
import 'package:kanker/app.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  var result;

  Future<void> uploadImage() async {
    if (imageFile == null) {
      // Handle case when no image is selected
      return;
    }

    Uri uri = Uri.parse(
        'http://192.168.1.8:5000/predict'); // Ganti URL sesuai kebutuhan Anda.
    var request = http.MultipartRequest('POST', uri);

    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile!.path));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        final res = await response.stream.bytesToString();
        print(res);
        final jsonResponse = json.decode(res);
        final prediction = jsonResponse['prediction'];
        setState(() {
          result = prediction;
        });
      } else {
        print(
            'Failed to upload image with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error uploading image: $error');
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
          Container(
            margin: EdgeInsets.only(top: 82),
            width: 267,
            height: 48,
            decoration: BoxDecoration(
                color: Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Text(result ?? '', style: TextStyle(fontSize: 16)),
            ),
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
          ElevatedButton(
            onPressed: uploadImage,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 31),
              width: 200,
              height: 42,
              child: Center(
                child: Text("Proses"),
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
