import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import './screens/ImageTranslate.dart';
import './screens/liveTranslate.dart';
import './screens/selectScreen.dart';
import './screens/spalshScreen.dart';

List<CameraDescription>? cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Converse',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      routes: {
        "/": (_) => const SplashScreen(),
        SelectScreen.routeName: (_) => const SelectScreen(),
        LiveTranslate.routeName: (_) => const LiveTranslate(),
        ImageTranslate.routeName: (_) => const ImageTranslate(),
      },
    );
  }
}
