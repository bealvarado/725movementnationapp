import 'package:flutter/material.dart';
import 'package:dance_studio/classschedule_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final bool _isButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: AppBar(
          automaticallyImplyLeading: false, // Remove the back button if any
          elevation: 0, // Remove the shadow
          backgroundColor: Colors.white, // TabBar background color
          flexibleSpace: SafeArea(
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF4146F5), // Selected tab color
              unselectedLabelColor: Colors.black, // Unselected tab color
              indicatorColor: const Color(0xFF4146F5), // Indicator color
              tabs: const [
                Tab(text: 'Weekday Class'),
                Tab(text: 'Courses'),
                Tab(text: 'Hire Studio'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabContent(context, 'Weekday Class'),
          _buildTabContent(context, 'Courses'),
          _buildTabContent(context, 'Hire Studio'),
        ],
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, String tabName) {
    return Padding(
      padding: const EdgeInsets.only(top: 120.0), // Ensure 60px gap from the TabBar
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              width: 200,
              height: 200,
              child: Center(
                child: Image(
                  image: AssetImage('assets/images/BCempty_state.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Upcoming Booking',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontFamily: 'SF Pro Display',
              ),
            ),
            const Text(
              'Book your first class today!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'SF Pro Display',
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0), // 40px gap above the navigation bar
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9, // Adjust the width as needed
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.pressed)) {
                          return const Color(0xFF4146F5); // Background color when pressed
                        }
                        return _isButtonEnabled
                            ? const Color(0xFF4146F5) // Default background color when enabled
                            : const Color(0xFF93A4C1); // Background color when disabled
                      },
                    ),
                    minimumSize: WidgetStateProperty.all<Size>(
                      const Size(double.infinity, 50),
                    ),
                    foregroundColor: WidgetStateProperty.all<Color>(
                      Colors.white, // Text color
                    ),
                    textStyle: WidgetStateProperty.all<TextStyle>(
                      const TextStyle(
                        fontWeight: FontWeight.w600, // Semibold
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
                      ),
                    ),
                  ),
                  onPressed: _isButtonEnabled
                      ? () {
                          // Replace this with the actual navigation to another page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ClassSchedule()),
                          );
                        }
                      : null,
                  child: const Text('Book a Class'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookClassScreen extends StatelessWidget {
  const BookClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Class'),
      ),
      body: const Center(
        child: Text(
          'Book a Class Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
