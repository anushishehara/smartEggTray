import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'egg_detail_page.dart';

class DashboardPage extends StatelessWidget 
{
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar
      (
        title: const Text('Smart Egg Tray Dashboard'),
        backgroundColor: Colors.lightBlue,
      ),
      backgroundColor: Colors.lightBlue[50],
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('egg_slots').snapshots(),
        builder: (context, snapshot) 
        {
          if (snapshot.hasError) 
          {
            return const Center(child: Text('Error loading slots'));
          }
          if (!snapshot.hasData) 
          {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) 
            {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              final String slotId = doc.id;
              final bool isOccupied = data['isOccupied'] ?? false;

              final dynamic addedDateRaw = data['addedDate'];
              DateTime? storedDate;

              if (addedDateRaw != null) 
              {
                if (addedDateRaw is Timestamp) 
                {
                  storedDate = addedDateRaw.toDate();
                } 
                else if (addedDateRaw is String)
                {
                  storedDate = DateTime.tryParse(addedDateRaw);
                }
              }

              bool isExpired = false;
              if (isOccupied && storedDate != null) 
              {
                final expiry = storedDate.add(const Duration(days: 7));
                isExpired = DateTime.now().isAfter(expiry);
              }

              Color cardColor;
              String statusText;

              if (!isOccupied) 
              {
                cardColor = Colors.grey[300]!;
                statusText = 'Available Slot';
              } else if (isExpired) {
                cardColor = Colors.red[300]!;
                statusText = 'Expired Egg';
              } else {
                cardColor = Colors.green[300]!;
                statusText = 'Fresh Egg';
              }

              return Card(
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    'Slot: $slotId',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(statusText),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EggDetailPage(
                          slotId: slotId,
                          isOccupied: isOccupied,
                          storedDate: storedDate,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
