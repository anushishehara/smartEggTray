import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EggDetailPage extends StatelessWidget 
{
  final String slotId;
  final bool isOccupied;
  final DateTime? storedDate;
  final bool isExpired;

  const EggDetailPage(
    {
    super.key,
    required this.slotId,
    required this.isOccupied,
    this.storedDate,
    this.isExpired = false,
  });

  @override
  Widget build(BuildContext context) 
  {
    String statusText;
    Color statusColor;

    if (!isOccupied) 
    {
      statusText = 'Slot is Available';
      statusColor = Colors.grey;
    } else if (isExpired) 
    {
      statusText = 'Egg Expired';
      statusColor = Colors.red;
    } else 
    {
      statusText = 'Egg is Fresh';
      statusColor = Colors.green;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Details: $slotId'),
        backgroundColor: Colors.lightBlue,
      ),
      backgroundColor: Colors.lightBlue[50],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isOccupied
                  ? (isExpired ? Icons.warning : Icons.egg)
                  : Icons.add_circle_outline,
              size: 100,
              color: statusColor,
            ),
            const SizedBox(height: 20),
            Text(
              statusText,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
            const SizedBox(height: 20),
            if (isOccupied && storedDate != null) ...[
              Text(
                'Added: ${storedDate!.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Expires: ${storedDate!.add(const Duration(days: 7)).toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 18),
              ),
            ] else if (isOccupied)
              const Text(
                'Date not set',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                final slotRef = FirebaseFirestore.instance
                    .collection('egg_slots')
                    .doc(slotId);

                if (isOccupied) 
                {
                  await slotRef.update({
                    'isOccupied': false,
                    'addedDate': null,
                  });
                } 
                else 
                {
                  await slotRef.update({
                    'isOccupied': true,
                    'addedDate': DateTime.now(),
                  });
                }

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isOccupied ? 'Remove Egg' : 'Add Egg',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
