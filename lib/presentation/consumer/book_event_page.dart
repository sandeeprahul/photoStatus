import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photostatus/presentation/upi_payments_page.dart';
import 'package:photostatus/presentation/widgets/dialogs.dart';
import 'package:upi_india/upi_india.dart';

class BookEventPage extends StatefulWidget {
  final String imageUrl; // Declare imageUrl as an instance variable
  final String price; // Declare imageUrl as an instance variable

  BookEventPage(this.imageUrl, this.price);

  @override
  State<BookEventPage> createState() => _BookEventPageState();
}

class _BookEventPageState extends State<BookEventPage> {
  // Constructor to receive imageUrl
  final picker = ImagePicker();

  XFile? _image;

  TextEditingController nameController = TextEditingController();

  Future<void> _getImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = pickedImage;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }



  Future<void> _uploadData() async {
    showLoaderDialog(context);

    if (_image == null) {
      // Handle case where no image is selected

      return;
    }

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference storageRef =
        FirebaseStorage.instance.ref().child('images/$fileName.jpg');
    final UploadTask uploadTask = storageRef.putFile(File(_image!.path));

    await uploadTask.whenComplete(() async {
      final imageurlFromstorage = await storageRef.getDownloadURL();
      final name = nameController.text;

      DateTime now = DateTime.now();
      // Upload data to Firestore
      FirebaseFirestore.instance.collection('bookings').add({
        'imageUrl': widget.imageUrl,
        'userImageUrl': imageurlFromstorage,
        'status': 'Pending',
        'orderId': "MYPDT${now.month}${now.day}${now.hour}${now.second}",
        'name': name,
        'phone': FirebaseAuth.instance.currentUser!.phoneNumber,
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'timeStamp': FieldValue.serverTimestamp(),
        // Add other fields as needed
      });

      // Clear the fields
      setState(() {
        _image = null;
        nameController.clear();
      });
    });

    showMyDialog();
    // Navigator.pop(context);
  }



  void showMyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (contextt) => WillPopScope(
        onWillPop: () => Future.value(false),
        child: AlertDialog(
          title: const Text("Success!"),
          content: const Text("Thanks for the order"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(contextt);
                Navigator.pop(context);
              },
              child: const Text("Okay"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload your photos'),
      ),
      body: Stack(
        children: [
          Image.network(
            widget.imageUrl,
            width:
                MediaQuery.of(context).size.width, // Adjust the width as needed
            height: 200, // Adjust the height as needed
            fit: BoxFit.cover, // Adjust the fit as needed
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _image == null
                    ? const CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.cloud_upload),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(File(_image!.path)),
                      ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _getImage,
                  child: const Text('Upload Photo'),
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Enter Name'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    '*Every photo edit will be delivered after 7days from booking date.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
                // Spacer(),

                // Add other content here
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                onPressed: () {
                  if (nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter name')));
                  } else if(_image==null){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please upload photo')));
                  }else{
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => const UpiPaymentsPage(), // Replace with your other page widget
                    //   ),
                    // );
                    _uploadData();

                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Submit',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
