import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'addcalories.dart';
import 'mealinfo.dart';
import 'piechart.dart';

class CaloriesTrackerPage extends StatefulWidget {
  @override
  _CaloriesTrackerPageState createState() => _CaloriesTrackerPageState();
}

class _CaloriesTrackerPageState extends State<CaloriesTrackerPage> {
  late DateTime _selectedDate;
  late DateTime _firstDay;
  late DateTime _lastDay;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _firstDay = DateTime(2023, 1, 1);
    _lastDay = DateTime(2050, 12, 31);
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
            DailyPieChart(date: _selectedDate),

            TableCalendar(
              firstDay: _firstDay,
              lastDay: _lastDay,
              focusedDay: _selectedDate,
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (DateTime day) {
                return isSameDay(_selectedDate, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                });
              },
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondaryColor2,
                ),
              ),
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: true,
                formatButtonShowsNext: false,
                titleTextStyle: TextStyle(fontSize: 16),
              ),
              headerVisible: true,
              startingDayOfWeek: StartingDayOfWeek.sunday,
            ),

            MealInformationWidget(selectedDate: _selectedDate),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final selectedDate = await showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return AddCaloriesPage(selectedDate: _selectedDate);
            },
          );

          // Handle any callbacks or updates when AddCaloriesPage is dismissed
          if (selectedDate != null && selectedDate is DateTime) {
            setState(() {
              _selectedDate = selectedDate;
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
