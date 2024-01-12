import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'piechart.dart';
import 'package:table_calendar/table_calendar.dart';
import 'addcalories.dart';  // Import the AddCaloriesPage

class CaloriesTrackerPage extends StatefulWidget {
  @override
  _CaloriesTrackerPageState createState() => _CaloriesTrackerPageState();
}

class _CaloriesTrackerPageState extends State<CaloriesTrackerPage> {
  // TODO: Define necessary variables and controllers
  late DateTime _selectedDate;
  late DateTime _firstDay;
  late DateTime _lastDay;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _firstDay = DateTime(2023, 1, 1);  // Replace with your desired start date
    _lastDay = DateTime(2025, 12, 31);  // Replace with your desired end date
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calories Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TODO: Add Pie Chart widget
            DailyPieChart(date: _selectedDate),

            // TODO: Add Total Calories Display
            // TotalCaloriesDisplay(),

            // TODO: Add Table Calendar
            TableCalendar(
              firstDay: _firstDay,
              lastDay: _lastDay,
              focusedDay: _selectedDate,
              calendarFormat: CalendarFormat.month,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                });
              },
            ),

            // TODO: Add Meal Information
            // MealInformationWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddCaloriesPage when the FAB is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCaloriesPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
