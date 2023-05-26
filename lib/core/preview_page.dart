
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class PreviewPage extends StatelessWidget {

  const PreviewPage({Key? key, required this.picture,required this.cameraPage}) : super(key: key);
  final bool? cameraPage;

  final  picture;

  @override
  Widget build(BuildContext context) {
    double widthMedia=MediaQuery.of(context).size.width;
    double heightMedia=MediaQuery.of(context).size.height;
    return Scaffold(

      body:Align(
        widthFactor: double.infinity,
        child: cameraPage!?Image.file(File(picture.path), fit: BoxFit.cover, width: 250)
        : Image.network(picture),
      )
    );
  }
}