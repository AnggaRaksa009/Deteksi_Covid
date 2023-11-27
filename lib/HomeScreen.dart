import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:kanker/Image_Picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:file_picker/file_picker.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? imageFile;
  String? downloadLink;
  bool isLoading = false;

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
      result = null;
    });
  }

  var result;

  Future<void> prosesimage() async {
    if (imageFile == null) {
      return;
    }

    Uri uri = Uri.parse('http://192.168.100.195:5000/predict');

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

  Uri uriGlcm = Uri.parse('https://40c2-103-187-117-117.ngrok-free.app/glcm');
  Future<void> prosesglcm() async {
    setState(() {
      isLoading = true;
    });
    if (imageFile == null) {
      return;
    }

    var request = http.MultipartRequest('post', uriGlcm);

    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile!.path));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        print('Image uploaded successfully for GLCM');
        final res = await response.stream.bytesToString();
        print('GLCM response: $res');
        final jsonResponse = json.decode(res);

        if (jsonResponse.containsKey('download_link')) {
          final prediction = jsonResponse['download_link'];
          setState(() {
            result = prediction;
          });
          print('GLCM prediction: $prediction');

          String downladCSVUrl =
              'https://40c2-103-187-117-117.ngrok-free.app$prediction';

          print(downladCSVUrl);

          FileDownloader.downloadFile(
              url: downladCSVUrl,
              onProgress: (String? fileName, double progress) {
                print('FILE $fileName HAS PROGRESS $progress');
              },
              onDownloadCompleted: (String path) {
                print('FILE DOWNLOADED TO PATH: $path');
              },
              onDownloadError: (String error) {
                print('DOWNLOAD ERROR: $error');
              });
        } else {
          print('Response does not contain the "prediction" key.');
        }
      } else {
        print(
            'Failed to upload image with GLCM, status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error uploading image with GLCM: $error');
    }
    setState(() {
      isLoading = false;
    });
    // FilePickerResult? pickGlcm = await FilePicker.platform.pickFiles();

    // if (result != null) {
    //   File ambilGlcm = File(result.files.single.path!);
    // } else {}
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
                  "Hasil",
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
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  prosesimage();
                },
                child: Container(
                  // margin: EdgeInsets.only(top: 96),
                  width: 144,
                  height: 42,
                  child: Center(
                    child: Text(
                      "Proses",
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
                onTap: isLoading ? null : prosesglcm,
                child: Container(
                  // margin: EdgeInsets.only(top: 96),
                  width: 144,
                  height: 42,
                  child: Center(
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Text(
                            "GLCM",
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
