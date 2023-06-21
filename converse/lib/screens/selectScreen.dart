import 'package:flutter/material.dart';

import '../screens/ImageTranslate.dart';
import '../screens/liveTranslate.dart';

class SelectScreen extends StatelessWidget {
  static const routeName = '/SelectScreen';
  const SelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff9cb5de),
        title: const Text('Converse'),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xffe4edfe),
      body: Container(),
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
    );
  }
}
