import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ClassSchedule extends StatefulWidget {
  const ClassSchedule({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ClassScheduleState createState() => _ClassScheduleState();
}

class _ClassScheduleState extends State<ClassSchedule> {
  DateTime _focusedDay = DateTime.now(); // Default to today's date
  DateTime? _selectedDay = DateTime.now(); // Default to today's date

  Future<List<ClassData>> fetchClassData(DateTime date) async {
    // Simulate fetching data from a backend API
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // Example data structure, replace with actual API call
    return [
      ClassData(
        imageUrl: 'assets/images/rishika_greencircle.png',
        title: 'Class with Rishika',
        subtitle: 'Beginner Choreography',
        subtitleColor: const Color(0xFF54B872), // Green color for Beginner Choreography
        spotsLeft: 31,
        time: '6pm',
        isBooked: false,
      ),
      ClassData(
        imageUrl: 'assets/images/tommy_greencircle.png',
        title: 'Class with Tommy',
        subtitle: 'Beginner Choreography',
        subtitleColor: const Color(0xFF54B872), // Green color for Beginner Choreography
        spotsLeft: 21,
        time: '6pm',
        isBooked: false,
      ),
      ClassData(
        imageUrl: 'assets/images/winter_greencircle.png',
        title: 'Class with Winter',
        subtitle: 'Beginner Choreography',
        subtitleColor: const Color(0xFF54B872), // Green color for Beginner Choreography
        spotsLeft: 3,
        time: '6pm',
        isBooked: false,
      ),
      ClassData(
        imageUrl: 'assets/images/kurt_redcircle.png',
        title: 'Class with Kurt',
        subtitle: 'Int / Advanced Choreography',
        subtitleColor: const Color(0xFF936B06), // Brown color for Int / Advanced Choreography
        spotsLeft: 31,
        time: '8:15pm',
        isBooked: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // Set background color to #F8F8F8
      appBar: AppBar(
        title: const Text('Parramatta Class Schedule'),
      ),
      body: FutureBuilder<List<ClassData>>(
        future: fetchClassData(_selectedDay!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE84479), // Pink color for loading indicator
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
          border: Border.all(color: Colors.blue, width: 2), // 2px outlined circle for today
          shape: BoxShape.circle,
        ),
        selectedDecoration: const BoxDecoration(
          color: Color(0xFF4146F5), // Blue color for selected day
          shape: BoxShape.circle,
        ),
        selectedTextStyle: const TextStyle(color: Colors.white), // White color for selected date text
        weekendTextStyle: const TextStyle(color: Colors.grey), // Grey color for weekends
        markersMaxCount: 0, // Remove the small dot on the calendar date
      ),
      enabledDayPredicate: (date) {
        // Disable weekends
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
          price: 22.0, // Fixed price for all classes
          date: _selectedDay.toString(),
          location: 'Parramatta Studio',
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
  final String date;
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
                  alignment: Alignment.centerRight, // Align button to the right
                  child: SizedBox(
                    width: 330, 
                    child: ElevatedButton(
                       onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/BookingDetails',
                          arguments: ClassCard(
                            title: title,
                            price: price,
                            date: '2024-11-19',
                            time: time,
                            location: 'Studio A',
                            imageUrl: imageUrl,
                            subtitle: subtitle,
                            subtitleColor: subtitleColor,
                            spotsLeft: spotsLeft,
                            isBooked: isBooked,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFE84479), // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4), // 4px round border
                        ),
                        minimumSize: const Size.fromHeight(38), // Button height 38px
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
          ],
        ),
      ),
    );
  }
}

void setState(Null Function() param0) {
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
