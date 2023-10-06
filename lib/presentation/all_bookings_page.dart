import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AllBookingsPage extends StatefulWidget {
  const AllBookingsPage({super.key});

  @override
  State<AllBookingsPage> createState() => _AllBookingsPageState();
}

class _AllBookingsPageState extends State<AllBookingsPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QueryDocumentSnapshot>>(
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
            final uplodedDate = date.toDate();

            final monthFormat = DateFormat('MMM');

// Format the date to get the 3-letter month name
            final monthName = monthFormat.format(uplodedDate);

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
                    Text('Uploaded date: ${uplodedDate.day}th $monthName'),

                  ],
                ),
              ),
            );
          },
        );
      },
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
          .collection('bookings')
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs);
    } catch (e) {
      print('Error fetching user bookings: $e');
      return Stream.value([]); // Handle errors by returning an empty stream
    }
  }



}
