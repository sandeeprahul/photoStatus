import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:photostatus/presentation/widgets/dialogs.dart';

class UploadDesignsPage extends StatefulWidget {
  const UploadDesignsPage({super.key});


  @override
  State<UploadDesignsPage> createState() => _UploadDesignsPageState();
}

class _UploadDesignsPageState extends State<UploadDesignsPage> {
  // Constructor to receive imageUrl
  final picker = ImagePicker();


  XFile? _image;

  TextEditingController nameController = TextEditingController();

  Future<void> _getImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = pickedImage;
    });
    if(_image!=null){
      _uploadData();
    }
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
    final Reference storageRef = FirebaseStorage.instance.ref().child('designs/$fileName.jpg');
    final UploadTask uploadTask = storageRef.putFile(File(_image!.path));

    await uploadTask.whenComplete(() async {
      final imageurlFromstorage = await storageRef.getDownloadURL();

      // Upload data to Firestore
      FirebaseFirestore.instance.collection('photos').add({
        'image':imageurlFromstorage,
        'price':"100",
        // Add other fields as needed
      });

      // Clear the fields
      setState(() {
        _image = null;
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
          content: const Text("Upload success"),
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
        // title: const Text('Upload your Designs'),
      ),
      floatingActionButton: CircleAvatar(
        child: IconButton(
          icon: const Icon(Icons.upload),onPressed: (){
          _getImage();
        },),
      ),
      body: StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: getUserBookingsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Display a loading indicator
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final userBookings = snapshot.data;

          if (userBookings == null || userBookings.isEmpty) {
            return const Text('No designs found for the current user.');
          }

          return ListView.builder(
            itemCount: userBookings.length,
            itemBuilder: (context, index) {
              final bookingData = userBookings[index].data() as Map<String, dynamic>;
              final imageUrl = bookingData['image'] as String;

              return Container(
                alignment: Alignment.center,
                color: Colors.white,
                margin: const EdgeInsets.only(left: 16,right: 16,bottom: 12),
                child:Image.network(
                  imageUrl,
                  width: MediaQuery.of(context)
                      .size
                      .width, // Adjust the width as needed
                  height: 200, // Adjust the height as needed
                  fit: BoxFit.cover, // Adjust the fit as needed
                ),
              );
            },
          );
        },
      )
    );
  }

  Stream<List<QueryDocumentSnapshot>> getUserBookingsStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Stream.value([]); // User is not logged in
    }

    final uid = currentUser.uid;

    try {
      return FirebaseFirestore.instance
          .collection('photos')
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs);
    } catch (e) {
      print('Error fetching user bookings: $e');
      return Stream.value([]); // Handle errors by returning an empty stream
    }
  }

}
