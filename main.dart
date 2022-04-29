import 'package:flutter/material.dart';
import 'scanner.dart';
import 'camera.dart';
import 'verification.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const QrCodeScanner(),
    );
  }
}

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({Key? key}) : super(key: key);

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Scanner'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              alignment: Alignment.center,
              width: 300,
              height: 80,
              color: Colors.indigo[300],
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextButton(
                style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
                child: const Text(
                  'Scan',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Scanner(),
                    ),
                  );
                },
              ),
            ),
          ),
          Center(
            child: Container(
              width: 300,
              height: 80,
              alignment: Alignment.center,
              color: Colors.indigo[300],
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: TextButton(
                style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
                child: const Text(
                  'Select Roll No',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Camera(),
                    ),
                  );
                },
              ),
            ),
          ),
          Center(
            child: Container(
              width: 300,
              height: 80,
              alignment: Alignment.center,
              color: Colors.indigo[300],
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: TextButton(
                style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
                child: const Text(
                  'View List',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => VerifyRequest(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
