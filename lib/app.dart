import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';

class ImageClassificationScreen extends StatefulWidget {
  @override
  _ImageClassificationScreenState createState() =>
      _ImageClassificationScreenState();
}

class _ImageClassificationScreenState extends State<ImageClassificationScreen> {
  late File _image;
  String _prediction = '';

  @override
  void initState() {
    super.initState();
    // Load your KNN model or TFLite model here
    loadModel();
    _image = File('assets/top1.png');
  }

  Future loadModel() async {
  String? modelLoadedMessage = await Tflite.loadModel(model: "model/knn_model.tflite");

  if (modelLoadedMessage != null) {
    print("Model Loaded Successfully: $modelLoadedMessage");
  } else {
    print("Model Loading Failed");
  }
}


  Future getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        predictImage(_image);
      });
    }
  }

  Future predictImage(File image) async {
    if (image == null) return;

    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 3,
      threshold: 0.1,
    );

    if (recognitions != null && recognitions.isNotEmpty) {
      setState(() {
        _prediction = recognitions[0]["label"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          _image == null ? Text('No image selected.') : Image.file(_image),
          ElevatedButton(
            onPressed: getImage,
            child: Text('Select Image and Predict'),
          ),
          Text('Prediction: $_prediction'),
        ],
      ),
    );
  }
}
