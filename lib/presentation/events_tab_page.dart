import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photostatus/presentation/PhoneVerificationPage.dart';

import 'book_event_page.dart';

class EventsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('photos').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // If data is available, build the list of images
        final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final imageUrl = documents[index]['image'];

            void navigateToOtherPage() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      BookEventPage (imageUrl), // Replace with your other page widget
                ),
              );
            }

            // Display the image using Image.network
            return GestureDetector(
              onTap: (){
                navigateToOtherPage();

              },
              child: Card(
                child: Column(
                  children: [
                    Image.network(
                      imageUrl,
                      width: MediaQuery.of(context)
                          .size
                          .width, // Adjust the width as needed
                      height: 200, // Adjust the height as needed
                      fit: BoxFit.cover, // Adjust the fit as needed
                    ),
                    Container(
                      width: MediaQuery.of(context)
                          .size
                          .width,
                      padding: const EdgeInsets.all(8),

                      child: const Center(child: Text('Get this design',style: TextStyle(fontSize: 16),)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}