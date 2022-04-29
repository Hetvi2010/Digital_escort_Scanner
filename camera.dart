// import 'dart:html';
import 'dart:io';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'database.dart';

class Camera extends StatefulWidget {
  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  File? imageFile;
  late final cloudinary;
  late String _rollNo;
  bool isverified = false;

  @override
  void initState() {
    super.initState();
    cloudinary = CloudinaryPublic('dm1qkzv8g', 'u2ms8k6j', cache: false);
  }

  
  void _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    setState(() {
      imageFile = File(pickedFile!.path);
    });
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(pickedFile!.path,
            resourceType: CloudinaryResourceType.Image),
      );
      Navigator.pushNamed(context, '/');
      await Db.verificationRequest(_rollNo, response.secureUrl);
      // print(response.secureUrl);
    } on CloudinaryException catch (e) {
      print(e.message);
      print(e.request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Roll No'),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 200,
            width: 20,
            child: Container(
              margin: const EdgeInsets.only(top: 150),
              child: Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Roll No',
                        hintText: 'Enter your roll no of your child'),
                    onChanged: (rollNo) {
                      _rollNo = rollNo;
                    }),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: ElevatedButton(
              child: const Text('Capture image'),
              onPressed: () async {
                String response = await Db.validateRollNo(_rollNo);
                if (response == "\"Valid RollNo\"") {
                  _getFromCamera();
                }
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.indigo[300]),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
                  textStyle:
                      MaterialStateProperty.all(const TextStyle(fontSize: 16))),
            ),
          ),
        ],
      ),
    );
  }
}
