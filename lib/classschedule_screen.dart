import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import 'providers/user_provider.dart';
import 'bookingdetails_screen.dart' as Booking;

class ClassSchedule extends StatefulWidget {
  final String location;

  const ClassSchedule({super.key, required this.location});

  @override
  _ClassScheduleState createState() => _ClassScheduleState();
}

class _ClassScheduleState extends State<ClassSchedule> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _validateUserSession(); // Ensure user session is valid
  }

  Future<void> _validateUserSession() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');

    if (uid != null && uid.isNotEmpty) {
      debugPrint("Session validated: UID=$uid");
      userProvider.setUid(uid); // Sync UID with UserProvider
    } else {
      debugPrint("Session invalid: No UID found.");
      _showErrorDialog("Session expired. Please log in again.");
      Navigator.pushReplacementNamed(context, '/login'); // Redirect to login screen
    }
  }

  Future<List<ClassData>> fetchClassData(DateTime date) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return [
      ClassData(
        imageUrl: 'assets/images/rishika_greencircle.png',
        title: 'Class with Rishika',
        subtitle: 'Beginner Choreography',
        subtitleColor: const Color(0xFF54B872),
        spotsLeft: 31,
        time: '18:00',
        isBooked: false,
      ),
      ClassData(
        imageUrl: 'assets/images/tommy_greencircle.png',
        title: 'Class with Tommy',
        subtitle: 'Beginner Choreography',
        subtitleColor: const Color(0xFF54B872),
        spotsLeft: 21,
        time: '18:00',
        isBooked: false,
      ),
      ClassData(
        imageUrl: 'assets/images/winter_greencircle.png',
        title: 'Class with Winter',
        subtitle: 'Beginner Choreography',
        subtitleColor: const Color(0xFF54B872),
        spotsLeft: 3,
        time: '19:00',
        isBooked: false,
      ),
      ClassData(
        imageUrl: 'assets/images/kurt_redcircle.png',
        title: 'Class with Kurt',
        subtitle: 'Int/Advanced Choreography',
        subtitleColor: const Color(0xFF936B06),
        spotsLeft: 31,
        time: '20:15',
        isBooked: false,
      ),
    ];
  }

  Future<void> storeSelectedClassDetails(
      String className, String time, DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedClassName', className);
      await prefs.setString('selectedTime', time);
      await prefs.setString('selectedDate', date.toIso8601String());
    } catch (e) {
      throw Exception("Failed to store class details.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Text('${widget.location} Class Schedule'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.normal,
          fontFamily: 'SF Pro Display',
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
                Expanded(child: _buildClassList(snapshot.data!, userProvider)),
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
          border: Border.all(color: Color(0xFF4146F5), width: 2),
          shape: BoxShape.circle,
        ),
        todayTextStyle: const TextStyle(
          color: Colors.black,
        ),
        selectedDecoration: const BoxDecoration(
          color: Color(0xFF4146F5),
          shape: BoxShape.circle,
        ),
        selectedTextStyle: const TextStyle(
          color: Colors.white,
        ),
        weekendTextStyle: const TextStyle(color: Colors.grey),
        markersMaxCount: 0,
      ),
      enabledDayPredicate: (date) {
        return date.weekday != DateTime.saturday &&
            date.weekday != DateTime.sunday;
      },
    );
  }

  Widget _buildClassList(List<ClassData> classData, UserProvider userProvider) {
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
          onBookingPressed: () async {
            if (userProvider.uid != null && userProvider.uid!.isNotEmpty) {
              try {
                await storeSelectedClassDetails(data.title, data.time, _selectedDay!);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Booking.BookingDetails(
                      classCard: ClassCard(
                        imageUrl: data.imageUrl,
                        title: data.title,
                        subtitle: data.subtitle,
                        subtitleColor: data.subtitleColor,
                        spotsLeft: data.spotsLeft,
                        time: data.time,
                        price: 22.0,
                        date: _selectedDay!,
                        location: widget.location,
                        onBookingPressed: () {},
                      ),
                    ),
                  ),
                );
              } catch (e) {
                _showErrorDialog("Failed to store class details.");
              }
            } else {
              _showErrorDialog("You need to log in to book a class.");
            }
          },
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
  final VoidCallback onBookingPressed;

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
    required this.onBookingPressed,
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
                      onPressed: onBookingPressed,
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
