import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:tflite/tflite.dart';

class ImageTranslate extends StatefulWidget {
  static const routeName = '/ImageTranslate';
  const ImageTranslate({super.key});

  @override
  State<ImageTranslate> createState() => _ImageTranslateState();
}

class _ImageTranslateState extends State<ImageTranslate> {
  final imagePicker = ImagePicker();
  bool _loading = true;
  File? _selectedImage;
  List? _output = [];
  TextToSpeech tts = TextToSpeech();
  loadmodel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
  }

  classifyimage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: _selectedImage!.path,
      numResults: 5,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output;
      print("****************");
      print(_output);
      print("****************");
      _loading = false;
    });
  }

  void testImage() async {
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
  }

  pickImage() async {
    var image = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
      maxHeight: 600,
    );
    if (image == null) {
      return null;
    }
    setState(() {
      _selectedImage = File(image.path);
    });
    classifyimage(_selectedImage!);
  }

  void sound() {
    tts.setVolume(1.0);
    tts.setRate(1.0);
    tts.setPitch(1.0);
    tts.setLanguage('en-US');
    tts.speak(_output![0]['label'].toString().split(' ')[1]);
    /*  while (playAudio) {} */
    /* if (lastOut != audioOut.last) {
      while (true) {
        tts.speak(lastOut);
      }
    } */
  }

  @override
  void initState() {
    super.initState();
    loadmodel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff85a2d2),
        title: const Text("Image Converse"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              sound();
            },
            icon: const Icon(Icons.spatial_audio_off),
          )
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff85a2d2),
            ),
            onPressed: () {
              classifyimage(_selectedImage!);
            },
            child: Text("Translate")),
      ),
      backgroundColor: Color(0xffe4edfe),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _output!.isNotEmpty
              ? RichText(
                  text: TextSpan(children: [
                  TextSpan(
                    text: _output![0]['label'].toString().split(' ')[1],
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: '      '),
                  TextSpan(
                    text: (_output![0]['confidence'] as double)
                        .toStringAsFixed(3)
                        .toString()
                        .split(' ')[0],
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.black54),
                  )
                ]))
              : SizedBox(),
          /* Text(
            _output!.isNotEmpty ? _output.toString() : "",
            style: TextStyle(
              fontSize: 35,
            ),
          ), */
          _selectedImage != null
              ? Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 8,
                        color: Colors.white,
                      )),
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                )
              : Center(
                  child: Container(
                    child: Image.asset("assets/images/empty.png",
                        fit: BoxFit.contain),
                  ),
                ),
          TextButton(
              onPressed: () {
                testImage();
              },
              child:
                  Text(_selectedImage == null ? " Add Image" : "Change Image")),
        ],
      ),
    );
  }
}
