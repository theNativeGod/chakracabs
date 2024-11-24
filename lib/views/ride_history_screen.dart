import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../models/ride_request.dart';
import '../view_models/profile_provider.dart';

class RideHistoryScreen extends StatelessWidget {
  const RideHistoryScreen({Key? key}) : super(key: key);

  Future<List<RideRequest>> fetchRideRequests(String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('rideRequests')
        .where('userId', isEqualTo: userId) // Filter by userId
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      return RideRequest.fromMap(doc.id, doc.data());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Access ProfileProvider to get the current user ID
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final userId = profileProvider.customer?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride History'),
      ),
      body: FutureBuilder<List<RideRequest>>(
        future: fetchRideRequests(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No ride history found.'));
          }

          final rideRequests = snapshot.data!;

          return ListView.separated(
            itemCount: rideRequests.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final ride = rideRequests[index];
              return ListTile(
                title: Text(
                  'From: ${ride.pickup.name} To: ${ride.destination.name}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Type: ${ride.rideType}\nStatus: ${ride.status}\nDate: ${ride.timestamp.toDate()}',
                ),
                isThreeLine: true,
                leading: const Icon(Icons.directions_car),
                trailing: Text(
                  ride.status,
                  style: TextStyle(
                    color: ride.status == 'confirmed'
                        ? Colors.green
                        : ride.status == 'cancelled'
                            ? Colors.red
                            : Colors.orange,
                  ),
                ),
                onTap: () {
                  // Optionally navigate to a detailed screen
                },
              );
            },
          );
        },
      ),
    );
  }
}
