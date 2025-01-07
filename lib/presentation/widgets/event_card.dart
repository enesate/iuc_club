import 'package:flutter/material.dart';
import 'package:iuc_club/data/models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onJoin;

  const EventCard({super.key, required this.event, this.onJoin});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: const Color.fromARGB(255, 200, 200, 200),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage('assets/images/bg2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: InkWell(
          onTap: () => _showEventDetails(context),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(height: 8),
                Text(event.date.toString(), style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 8),
                Text(event.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Text('Katılımcılar: ${event.participants!.length}'),
                const SizedBox(height: 8),
                Text('Kulüp ID: ${event.clubId}'),
                onJoin == null
                    ? const SizedBox.shrink()
                    : Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: onJoin,
                          child: const Text('Katıl'),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEventDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(event.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tarih: ${event.date}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(event.description),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Kapat')),
          ],
        );
      },
    );
  }
}
