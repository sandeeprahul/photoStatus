import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'book_event_page.dart';

class EventsTab extends StatelessWidget {
  const EventsTab({super.key});

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
            final price = documents[index]['price'];

            void navigateToOtherPage() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BookEventPage(
                      imageUrl,price), // Replace with your other page widget
                ),
              );
            }

            // Display the image using Image.network
            return GestureDetector(
              onTap: () {
                navigateToOtherPage();
              },
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),color: Theme.of(context).secondaryHeaderColor),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200, // Adjust the height as needed
                      child: Stack(
                        children: [
                          CachedNetworkImage(imageUrl:imageUrl, width: MediaQuery.of(context)
                              .size
                              .width,
                            fit: BoxFit.cover,
                          ),
                       /*   Image.network(
                            imageUrl,
                            width: MediaQuery.of(context)
                                .size
                                .width, // Adjust the width as needed
                            fit: BoxFit.cover, // Adjust the fit as needed
                          ),*/
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.all(16),
                              width: 85,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Theme.of(context).secondaryHeaderColor),
                              child: Row(
                                children: [
                                  const Text("\u20B9"),

                                  const Text(" 100 ",style: TextStyle(decoration: TextDecoration.lineThrough,),),
                                  Text("$price"),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(8),
                      child:  Center(
                          child: Text(
                        'Get this design $price Rs',
                        style: const TextStyle(fontSize: 16),
                      )),
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
