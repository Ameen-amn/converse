import 'package:carousel_slider/carousel_slider.dart';
import 'package:converse/screens/ImageTranslate.dart';
import 'package:converse/screens/liveTranslate.dart';
import 'package:flutter/material.dart';

class SelectScreen extends StatelessWidget {
  static const routeName = '/SelectScreen';
  SelectScreen({super.key});

  List<String> imageList = [
    'assets/images/A.jpg',
    'assets/images/B.jpg',
    'assets/images/C.png',
    'assets/images/V.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff9cb5de),
        title: const Text('Converse'),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xffe4edfe),
      body: Column(
        children: [
          Container(
            /*      color: Colors.black,
            width: 500,
            height: 500, */
            decoration: BoxDecoration(
                border: Border.all(
              width: 5,
              color: Colors.white,
            )),
            margin: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: CarouselSlider(
              items: imageList.map((e) {
                return Builder(builder: (BuildContext ctx) {
                  return Container(
                    width: double.infinity,
                    height: 250,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      e,
                      fit: BoxFit.contain,
                    ),
                  );
                });
              }).toList(),
              options: CarouselOptions(
                height: 250,
                autoPlay: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff9cb5de),
                minimumSize: Size(double.infinity, 60),
                fixedSize: Size(double.infinity, 60),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(ImageTranslate.routeName);
              },
              child: const Text("Transalate Image"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff9cb5de),
                minimumSize: Size(double.infinity, 60),
                fixedSize: Size(double.infinity, 60),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(LiveTranslate.routeName);
              },
              child: const Text("Transalate Live"),
            ),
          ),
        ],
      ),
      /*   bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [],
      ), */
    );
  }
}
