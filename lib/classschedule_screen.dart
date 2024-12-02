import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ClassSchedule extends StatefulWidget {
  final String location;

  const ClassSchedule({super.key, required this.location});

  @override
  _ClassScheduleState createState() => _ClassScheduleState();
}

class _ClassScheduleState extends State<ClassSchedule> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  Future<List<ClassData>> fetchClassData(DateTime date) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      ClassData(
        imageUrl: 'assets/images/rishika_greencircle.png',
        title: 'Class with Rishika',
        subtitle: 'Beginner Choreography',
        subtitleColor: const Color(0xFF54B872),
        spotsLeft: 31,
        time: '18:00', // 24-hour format
        isBooked: false,
      ),
      ClassData(
        imageUrl: 'assets/images/tommy_greencircle.png',
        title: 'Class with Tommy',
        subtitle: 'Beginner Choreography',
        subtitleColor: const Color(0xFF54B872),
        spotsLeft: 21,
        time: '18:00', // 24-hour format
        isBooked: false,
      ),
      ClassData(
        imageUrl: 'assets/images/winter_greencircle.png',
        title: 'Class with Winter',
        subtitle: 'Beginner Choreography',
        subtitleColor: const Color(0xFF54B872),
        spotsLeft: 3,
        time: '18:00', // 24-hour format
        isBooked: false,
      ),
      ClassData(
        imageUrl: 'assets/images/kurt_redcircle.png',
        title: 'Class with Kurt',
        subtitle: 'Int / Advanced Choreography',
        subtitleColor: const Color(0xFF936B06),
        spotsLeft: 31,
        time: '20:15', // 24-hour format
        isBooked: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text('${widget.location} Class Schedule'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18, // Change this to your desired font size
          fontWeight: FontWeight.normal,
          fontFamily: 'SF Pro Display', // Ensure this font is available
        ),
      ),
      body: FutureBuilder<List<ClassData>>(
        future: fetchClassData(_selectedDay!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE84479),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading class data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No classes available'));
          } else {
            return Column(
              children: [
                _buildCalendar(context),
                Expanded(child: _buildClassList(snapshot.data!)),
              ],
            );
          }
        },
      ),
    );
  }

Widget _buildCalendar(BuildContext context) {
  return TableCalendar(
    locale: Localizations.localeOf(context).languageCode,
    firstDay: DateTime.utc(2020, 10, 16),
    lastDay: DateTime.utc(2030, 3, 14),
    focusedDay: _focusedDay,
    selectedDayPredicate: (day) {
      return isSameDay(_selectedDay, day);
    },
    onDaySelected: (selectedDay, focusedDay) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    },
    calendarFormat: CalendarFormat.week,
    headerStyle: const HeaderStyle(
      formatButtonVisible: false,
      titleCentered: true,
    ),
    calendarStyle: CalendarStyle(
      todayDecoration: BoxDecoration(
        border: Border.all(color: Color(0xFF4146F5), width: 2), // Blue border
        shape: BoxShape.circle,
      ),
      todayTextStyle: const TextStyle(
        color: Colors.black, // Black text for today's date
      ),
      selectedDecoration: const BoxDecoration(
        color: Color(0xFF4146F5), // Blue background for selected date
        shape: BoxShape.circle,
      ),
      selectedTextStyle: const TextStyle(
        color: Colors.white, // White text for selected date
      ),
      weekendTextStyle: const TextStyle(color: Colors.grey),
      markersMaxCount: 0,
    ),
    enabledDayPredicate: (date) {
      return date.weekday != DateTime.saturday && date.weekday != DateTime.sunday;
    },
  );
}

  Widget _buildClassList(List<ClassData> classData) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: classData.length,
      itemBuilder: (context, index) {
        final data = classData[index];
        return ClassCard(
          imageUrl: data.imageUrl,
          title: data.title,
          subtitle: data.subtitle,
          subtitleColor: data.subtitleColor,
          spotsLeft: data.spotsLeft,
          time: data.time,
          isBooked: data.isBooked,
          price: 22.0,
          date: _selectedDay!,
          location: widget.location,
        );
      },
    );
  }
}

class ClassCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final Color subtitleColor;
  final int spotsLeft;
  final String time;
  final bool isBooked;
  final double price;
  final DateTime date;
  final String location;

  const ClassCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.subtitleColor,
    required this.spotsLeft,
    required this.time,
    this.isBooked = false,
    required this.price,
    required this.date,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: subtitleColor,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                          Text(
                            '$spotsLeft spots left',
                            style: const TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 12,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                          Text(
                            _formatTimeTo12Hour(time),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                        ],
                      ),
                      if (isBooked)
                        const Text(
                          'You are booked in this class!',
                          style: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 12,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (!isBooked)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 330,
                    child: ElevatedButton(
                      onPressed: () {
                        _bookClass(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFE84479),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        minimumSize: const Size.fromHeight(38),
                        textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                    child: const Text('Book Class'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _bookClass(BuildContext context) async {
    // Combine date and time into a single DateTime object
    final DateTime dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(time.split(':')[0]), // Hour
      int.parse(time.split(':')[1]), // Minute
    );

    // Format the DateTime to a string in 24-hour format
    final String formattedDateTime = DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime);

    // Prepare booking data
    final bookingData = {
      'name': 'Your Name', // Replace with actual user name
      'location': location,
      'time': formattedDateTime,
    };

    // Send booking data to the backend
    final url = Uri.parse('http://<your-server-ip>:5000/add-booking');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bookingData),
      );

      if (response.statusCode == 200) {
        // Handle success
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Booking added successfully!')),
          );
        }
      } else {
        // Handle error
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add booking: ${response.body}')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  String _formatTimeTo12Hour(String time24) {
    final timeParts = time24.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;

    return '$hour12:${minute.toString().padLeft(2, '0')} $period';
  }
}




class ClassData {
  final String imageUrl;
  final String title;
  final String subtitle;
  final Color subtitleColor;
  final int spotsLeft;
  final String time;
  final bool isBooked;

  ClassData({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.subtitleColor,
    required this.spotsLeft,
    required this.time,
    this.isBooked = false,
  });
}