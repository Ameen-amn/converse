import '../screens/ImageTranslate.dart';

import '../screens/liveTranslate.dart';
import 'package:flutter/material.dart';

class SelectScreen extends StatelessWidget {
  static const routeName = '/SelectScreen';
 const SelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Converse'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
               Navigator.of(context).pushNamed(ImageTranslate.routeName);
              },
              child:const Text("Transalate Image"),
            ),
            ElevatedButton(
              onPressed: () {
                   Navigator.of(context).pushNamed(LiveTranslate.routeName);
              },
              child:const Text("Transalate Live"),
            ),
          ],
        ),
      ),
    );
  }
}
