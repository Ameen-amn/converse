import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:tflite/tflite.dart';

class LiveTranslate extends StatefulWidget {
  static const routeName = '/LiveTranslate';
  const LiveTranslate({super.key});

  @override
  State<LiveTranslate> createState() => _LiveTranslateState();
}

class _LiveTranslateState extends State<LiveTranslate> {
  String answer = "";
  CameraController? cameraController;
  CameraImage? cameraImage;
  List<String> audioOutList = [];
  String lastOut = '';
  String audioCheck = '';
  TextToSpeech tts = TextToSpeech();
  bool playAudio = false;
  bool translate = false;
  bool display = false;
  String predict = '';
  void loadmodel() async {
    Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  initCamera() {
    cameraController = CameraController(
        CameraDescription(
          name: '0', // 0 for back camera and 1 for front camera
          lensDirection: CameraLensDirection.back,
          sensorOrientation: 0,
        ),
        ResolutionPreset.medium);

    cameraController!.initialize().then(
      (value) {
        if (!mounted) {
          return;
        }
        setState(
          () {
            display = true;
            cameraController!.startImageStream(
              (image) => {
                if (true)
                  {
                    cameraImage = image,
                    if (translate)
                      {
                        applymodelonimages(),
                      }
                    else
                      {
                        answer = '',
                      }
                  }
              },
            );
          },
        );
      },
    );
  }

  bool isModelBusy = false;
  applymodelonimages() async {
    if (cameraImage != null && !isModelBusy) {
      isModelBusy = true;
      var predictions = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map(
            (plane) {
              return plane.bytes;
            },
          ).toList(),
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 1,
          threshold: 0.1,
          asynch: true);
      isModelBusy = false;
      answer = '';

      predictions!.forEach(
        (prediction) {
          predict = (prediction['confidence'] as double)
              .toStringAsFixed(3)
              .toString();
          answer +=
              /* prediction['label'].toString().substring(0, 1).toUpperCase() + */
              prediction['label'].toString().substring(1) +
                  "     " +
                  (prediction['confidence'] as double).toStringAsFixed(3) +
                  '\n';
          if (audioOutList.length > 2) {
            audioOutList.clear();
            lastOut = prediction['label'].toString().split(' ')[1];
            audioOutList.add(prediction['label'].toString().split(' ')[1]);
          } else {
            audioOutList.add(prediction['label'].toString().split(' ')[1]);
            lastOut = prediction['label'].toString().split(' ')[1];
          }
        },
      );

      setState(
        () {
          if (!translate) {
            answer = '';
            lastOut = '';
            predict = '';
          } else {
            answer = answer;
            if (lastOut != audioCheck) {
              audioCheck = lastOut;
            }
          }
        },
      );
    }
  }

  void sound() {
    tts.setVolume(1.0);
    tts.setRate(1.0);
    tts.setPitch(1.0);
    tts.setLanguage('en-US');
    tts.speak(audioCheck);
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
    initCamera();
  }

  @override
  void dispose() async {
    await Tflite.close();
    cameraController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe4edfe),
      appBar: AppBar(
        backgroundColor: Color(0xff85a2d2),
        title: const Text("Live Converse"),
        actions: [
          IconButton(
            onPressed: () {
              sound();
              setState(() {
                playAudio = !playAudio;
              });
            },
            icon: const Icon(Icons.spatial_audio_off),
          )
        ],
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff85a2d2)),
            onPressed: () {
              setState(() {
                translate = !translate;
              });
            },
            child: Text(!translate ? "Translate" : "Stop Translate")),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: display
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      height: MediaQuery.of(context).size.height - 200,
                      width: MediaQuery.of(context).size.width,
                      color: Color(0xffe4edfe),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 5,
                              color: Colors.white,
                            )),
                        height: MediaQuery.of(context).size.height - 250,
                        width: MediaQuery.of(context).size.width - 50,
                        child: AspectRatio(
                          aspectRatio: cameraController!.value.aspectRatio,
                          child: CameraPreview(cameraController!),
                        ),
                      ))
                  : Center(child: CircularProgressIndicator()),
            ),
            Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: Color(0xffe4edfe),
              ),
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: RichText(
                      text: TextSpan(children: [
                TextSpan(
                  text: lastOut,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.w600),
                ),
                TextSpan(text: '      '),
                TextSpan(
                    text: predict,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.black54))
              ]))),
            )
          ],
        ),
      ),
    );
  }
}
