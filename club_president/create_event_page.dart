import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iuc_club/data/models/event_model.dart';
import 'package:iuc_club/presentation/controllers/club_president_controller.dart';

class CreateEventPage extends StatefulWidget {
  final String clubId;

  CreateEventPage({required this.clubId});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClubPresidentController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Etkinlik Oluştur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Etkinlik Bilgileri',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Etkinlik Adı
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Etkinlik Adı',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Etkinlik Açıklaması
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Etkinlik Açıklaması',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Tarih Seçici
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate != null ? 'Seçilen Tarih: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}' : 'Tarih Seçilmedi',
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      setState(() {
                        if (pickedDate != null) {
                          selectedDate = pickedDate;
                        }
                      });
                    },
                    child: const Text('Tarih Seç'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Saat Seçici
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedTime != null ? 'Seçilen Saat: ${selectedTime!.format(context)}' : 'Saat Seçilmedi',
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      setState(() {
                        if (pickedTime != null) {
                          selectedTime = pickedTime;
                        }
                      });
                    },
                    child: const Text('Saat Seç'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Kaydet Butonu
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty || descriptionController.text.isEmpty || selectedDate == null || selectedTime == null) {
                      Get.snackbar(
                        'Hata',
                        'Lütfen tüm alanları doldurun ve tarih/saat seçin.',
                      );
                      return;
                    }

                    //event model oluştur
                    EventModel eventData = EventModel(
                      name: nameController.text,
                      description: descriptionController.text,
                      date: DateTime(
                        selectedDate!.year,
                        selectedDate!.month,
                        selectedDate!.day,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      ),
                      participants: [],
                      clubId: widget.clubId,
                      id: "0",
                    );

                    // Yeni etkinlik oluşturma
                    await controller.createEvent(eventData);

                    // Geri dön
                    // Get.back();
                    Navigator.pop(context);
                  },
                  child: const Text('Etkinlik Oluştur'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
