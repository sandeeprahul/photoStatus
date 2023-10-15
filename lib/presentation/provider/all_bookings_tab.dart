import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:photostatus/main.dart';
import 'package:photostatus/presentation/PhoneVerificationPage.dart';

class AllBookingsPage extends StatefulWidget {
  const AllBookingsPage({super.key});

  @override
  State<AllBookingsPage> createState() => _AllBookingsPageState();
}

class _AllBookingsPageState extends State<AllBookingsPage> {
  Future<void> signOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
  void _handleLogout(BuildContext context) async {
    await signOutUser(); // Call the signOutUser function to log out

    // Navigate to the login page and clear all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => PhoneVerificationPage()), // Replace with your login page
          (Route<dynamic> route) => false, // Clears all previous routes
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CircleAvatar(
        radius: 28,
        child: IconButton(
          icon: const Icon(Icons.logout),onPressed: (){
          _handleLogout(context);
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
            return const Text('No bookings found for the current user.');
          }

          return ListView.builder(
            itemCount: userBookings.length,
            itemBuilder: (context, index) {
              final bookingData = userBookings[index].data() as Map<String, dynamic>;
              final imageUrl = bookingData['imageUrl'] as String;
              final userImageUrl = bookingData['userImageUrl'] as String;
              final status = bookingData['status'] as String;
              final name = bookingData['name'] as String;
              final date = bookingData['timeStamp'] as Timestamp;
              final uploadedDate = date.toDate();

              final monthFormat = DateFormat('MMM');

// Format the date to get the 3-letter month name
              final monthName = monthFormat.format(uploadedDate);

              return Container(
                alignment: Alignment.center,
                color: Colors.white,
                margin: const EdgeInsets.only(left: 16,right: 16,bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(userImageUrl)),
                  trailing: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Name: $name'),
                      Row(
                        children: [
                          Text(status=="pending"?"Status: ":'Status: '),
                          Text(status=="pending"?"Pending":status,style: TextStyle(color:status=="pending"?Colors.red:Colors.green ),),
                        ],
                      ),
                      Text('Uploaded date: ${uploadedDate.day}th $monthName'),
                      SelectableText(userImageUrl),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  void downloadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        // Image downloaded successfully
        final bytes = response.bodyBytes;

        // Now you can use the 'bytes' to display the image or save it as needed
        final imageWidget = Image.memory(Uint8List.fromList(bytes));

        // Display the downloaded image
        showDialog(
          context:context,
          builder: (context) {
            return AlertDialog(
              title: Text('Downloaded Image'),
              content: imageWidget,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );

        print('Image downloaded.');
      } else {
        print('Failed to download image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading image: $e');
    }
  }

  Stream<List<QueryDocumentSnapshot>> getUserBookingsStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Stream.value([]); // User is not logged in
    }

    final uid = currentUser.uid;

    try {
      return FirebaseFirestore.instance
          .collection('bookings')
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs);
    } catch (e) {
      print('Error fetching user bookings: $e');
      return Stream.value([]); // Handle errors by returning an empty stream
    }
  }



}
