import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'database.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  MobileScannerController cameraController = MobileScannerController();
  bool found = false;
  String data = "";
  bool isLoading = false;
  Widget? temp;
  String show = "Data does not match";

  Widget giveMe() {
    temp = temp ??
        MobileScanner(
          allowDuplicates: false,
          controller: cameraController,
          onDetect: (barcode, args) {
            final String code = barcode.rawValue ?? "";
            data = code;
            setState(
              () {
                found = true;
                isLoading = true;
                checkQRCodeData();
              },
            );
          },
        );
    return temp ?? Container();
  }

  void checkQRCodeData() async {
    String key = await Db.getKey();
    String digest1 = data.substring(0, 64);
    String digest2 = data.substring(64, 128);
    String rollNo = "";
    String userName = "";
    bool isSpacePassed = false;
    for (int i = 129; i < data.length; ++i) {
      if (data[i] == " ") {
        isSpacePassed = true;
      }
      if (isSpacePassed) {
        if (data[i] != " ") {
          userName += data[i];
        }
      } else {
        rollNo += data[i];
      }
    }
    var digest3 = sha256.convert(utf8.encode(rollNo + key));
    var digest4 = sha256.convert(utf8.encode(userName + key));
    if (digest1 == digest3.toString() && digest2 == digest4.toString()) {
      show = "Roll No: " + rollNo + "                                                           " + "User Name: "  + userName;
      await Db.verificationRequest(rollNo, "");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Scanner'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state as CameraFacing) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: found
          ? isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Text(show),
                    TextButton(
                      onPressed: () {
                        setState(
                          () {
                            Navigator.pop(context);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const Scanner(),
                              ),
                            );
                          },
                        );
                      },
                      child: const Text('Scan Again'),
                    ),

                  ],
                )
          : giveMe(),
    );
  }
}
