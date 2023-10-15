import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class DownloadButton extends StatefulWidget {
  const DownloadButton({super.key});

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final String appVersion = "1.0.0";

  Future<void> _downloadApk() async {
    // Get a reference to the APK file in Firebase Storage
    final reference = storage.ref('MyPhotoEdit.apk');

    // Get the download URL for the APK file
    final downloadUrl = await reference.getDownloadURL();

    // Convert the download URL to a Uri object
    final uri = Uri.parse(downloadUrl);

    // Launch the download URL in the user's browser
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            width: 300,
            height: 100,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.purple,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: _downloadApk,
                child: const Text('Download Our App Now',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Text('Version $appVersion'),
            ])),
      ),
    );
  }
}
