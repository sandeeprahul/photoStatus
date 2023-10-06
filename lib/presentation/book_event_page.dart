import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photostatus/presentation/widgets/dialogs.dart';

class BookEventPage extends StatefulWidget {
  final String imageUrl; // Declare imageUrl as an instance variable

  BookEventPage(this.imageUrl);
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
    final Reference storageRef = FirebaseStorage.instance.ref().child('images/$fileName.jpg');
    final UploadTask uploadTask = storageRef.putFile(File(_image!.path));

    await uploadTask.whenComplete(() async {
      final imageurlFromstorage = await storageRef.getDownloadURL();
      final name = nameController.text;

      // Upload data to Firestore
      FirebaseFirestore.instance.collection('bookings').add({
        'imageUrl':widget.imageUrl,
        'userImageUrl': imageurlFromstorage,
        'status': 'pending',
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

  void showMyDialog(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () => Future.value(false),
        child: AlertDialog(
          title: const Text("Success!"),
          content: const Text("Thanks for the order"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
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
            width: MediaQuery.of(context).size.width, // Adjust the width as needed
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
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Enter Name'),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: (){
                    if(_image!=null){
                      _uploadData();
                  }else if(nameController.text.isEmpty){
                      Get.snackbar(
                        "Alert!",
                        "Please enter name",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }else{
                      Get.snackbar(
                        "Alert!",
                        "Please upload photo",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }

                  },
                  child: const Text('Submit'),
                ),
                // Add other content here
              ],
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Every photo edit will be given after 48 hour\'s from booking date',textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: Colors.grey), ),
              )),

        ],
      ),
    );
  }
}
