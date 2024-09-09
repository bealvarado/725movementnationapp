// ignore: file_names
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ClassSchedule extends StatefulWidget {
  const ClassSchedule({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ClassScheduleState createState() => _ClassScheduleState();
}

class _ClassScheduleState extends State<ClassSchedule> {
  DateTime _focusedDay = DateTime.utc(2024, 10, 18); // Default to Wednesday
  DateTime? _selectedDay = DateTime.utc(2024, 10, 18); // Default to Wednesday

  Future<Map<DateTime, List<Event>>> fetchEvents() async {
    // Simulate fetching data from a database or API
    await Future.delayed(const Duration(seconds: 1)); // Reduced loading time to 1 second
    return {
      DateTime.utc(2024, 10, 18): [Event('Event 1')], // Wednesday
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parramatta Class Schedule'),
      ),
      body: FutureBuilder<Map<DateTime, List<Event>>>(
        future: fetchEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE84479), // Pink color for loading indicator
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading events'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found'));
          } else {
            return Column(
              children: [
                _buildCalendar(snapshot.data!, context),
                Expanded(child: _buildClassList()),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildCalendar(Map<DateTime, List<Event>> events, BuildContext context) {
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
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Color(0xFF4146F5), // Blue color for today
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Color(0xFF4146F5), // Blue color for selected day
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(color: Colors.white), // White color for selected date text
        weekendTextStyle: TextStyle(color: Colors.grey), // Grey color for weekends
        markersMaxCount: 0, // Remove the small dot on the calendar date
      ),
      enabledDayPredicate: (date) {
        // Disable weekends
        return date.weekday != DateTime.saturday && date.weekday != DateTime.sunday;
      },
      eventLoader: (day) {
        return events[day] ?? [];
      },
    );
  }

  Widget _buildClassList() {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: const [
        ClassCard(
          imageUrl: 'assets/images/rishika_greencircle.png',
          title: 'Class with Rishika',
          subtitle: 'Beginner Choreography',
          subtitleColor: Color(0xFF54B872), // Green color for subtitle
          spotsLeft: 31,
          time: '6pm',
        ),
        ClassCard(
          imageUrl: 'assets/images/tommy_greencircle.png',
          title: 'Class with Tommy',
          subtitle: 'Beginner Choreography',
          subtitleColor: Color(0xFF54B872), // Green color for subtitle
          spotsLeft: 21,
          time: '6pm',
        ),
        ClassCard(
          imageUrl: 'assets/images/winter_greencircle.png',
          title: 'Class with Winter',
          subtitle: 'Beginner Choreography',
          subtitleColor: Color(0xFF54B872), // Green color for subtitle
          spotsLeft: 3,
          time: '6pm',
          isBooked: true,
        ),
        ClassCard(
          imageUrl: 'assets/images/kurt_redcircle.png',
          title: 'Class with Kurt',
          subtitle: 'Int / Advanced Choreography',
          subtitleColor: Color(0xFF936B06), // Brown color for subtitle
          spotsLeft: 31,
          time: '8:15pm',
        ),
      ],
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

  const ClassCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.subtitleColor,
    required this.spotsLeft,
    required this.time,
    this.isBooked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4), // 4px round border
      ),
      elevation: 0, // Remove shadow
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
                              fontSize: 12, // Subtitle font size
                              fontWeight: FontWeight.normal, // Regular text
                              fontFamily: 'SF Pro Display', // Font family
                            ),
                          ),
                          Text(
                            '$spotsLeft spots left',
                            style: const TextStyle(
                              color: Color(0xFF9CA3AF), // Grey color for spots left
                              fontSize: 12, // Spots left font size
                              fontFamily: 'SF Pro Display', // Font family
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
                              fontSize: 18, // Title font size
                              fontWeight: FontWeight.bold, // Bold text
                              fontFamily: 'SF Pro Display', // Font family
                            ),
                          ),
                          Text(
                            time,
                            style: const TextStyle(
                              fontSize: 16, // Time font size
                              fontWeight: FontWeight.bold, // Bold text
                              fontFamily: 'SF Pro Display', // Font family
                            ),
                          ),
                        ],
                      ),
                      if (isBooked)
                        const Text(
                          'You are booked in this class!',
                          style: TextStyle(
                            color: Color(0xFF9CA3AF), 
                            fontSize: 12, // Spots left font size
                            fontFamily: 'SF Pro Display', // Font family
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
      width: 340.0, // Align button width
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/BookingDetails'); // Navigate to BookingDetails
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: const Color(0xFFE84479), // White font color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4), // 4px round border
          ),
          minimumSize: const Size.fromHeight(44), // Button height 38px
          textStyle: const TextStyle(
            fontSize: 16, // Button text font size
            fontWeight: FontWeight.w500, // Medium weight
            fontFamily: 'SF Pro Display', // Font family
          ),
        ),
        child: const Text('Book Class'),
      ),
    ),
  ),
  ),
          ]
        ),
      ),
    );
  }
}

class Event {
  final String title;

  Event(this.title);
}
