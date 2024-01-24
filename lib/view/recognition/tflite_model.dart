import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

import '../../utils/app_colors.dart';

class TfliteModel extends StatefulWidget {
  const TfliteModel({super.key});

  @override
  State<TfliteModel> createState() => _TfliteModelState();
}

class _TfliteModelState extends State<TfliteModel> {

  late File _image;
  late List _results;
  bool imageSelect=false;

  void initState(){
    super.initState();
    loadModel();
  }

  Future loadModel()
  async {
    Tflite.close();
    String res;
    res = (await Tflite.loadModel(model: "assets/model.tflite" , labels: "assets/labels.txt"))!;
    print("Models loading status: $res");
  }

  Future imageClassification(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _results=recognitions!;
      _image=image;
      imageSelect=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Scanning Your Food !!!",
            style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
      ),
      ),
      body: ListView(
        children: [
          (imageSelect)?Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor1,
              borderRadius: BorderRadius.circular(45),
            ),
            margin: const EdgeInsets.all(15),
            padding: EdgeInsets.all(5),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.file(_image)),
          ):Container(
            margin: const EdgeInsets.all(30),
            child: const Opacity(
              opacity: 0.8,
              child: Center(
                child: Text("No image selected"),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Text("~~ Detected Food ~~",
                  style: TextStyle(
                      color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 8,),
                Column(
                  children: (imageSelect)?_results.map((result) {
                    return Card(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          "${result['label']} -> ${result['confidence'].toStringAsFixed(2)}/1.00",
                          style: TextStyle(
                              color: AppColors.primaryColor1 , fontSize: 18, fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                    );
                  }).toList():[],
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
          tooltip: "Pick Image",
        child: Icon(Icons.image),
      ),
    );
  }
  Future pickImage()
  async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    File image=File(pickedFile!.path);
    imageClassification(image);
  }
}
