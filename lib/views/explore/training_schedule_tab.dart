import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../common/app_colors.dart';
import '../../routes/app_routes.dart';

class TrainingScheduleTab extends StatefulWidget {
  const TrainingScheduleTab({super.key});

  @override
  State<TrainingScheduleTab> createState() => _TrainingScheduleTabState();
}

class _TrainingScheduleTabState extends State<TrainingScheduleTab> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<Map<String, String>> schedules = [
    {
      'time': '4:00 PM - 6:00 PM',
      'title': 'Basket Ball Training',
      'instructor': 'John Smith',
    },
    {
      'time': '6:30 PM - 8:00 PM',
      'title': 'Football Practice',
      'instructor': 'Alex Johnson',
    },
    {
      'time': '8:00 PM - 9:00 PM',
      'title': 'Yoga Session',
      'instructor': 'Mary Williams',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _calendarWidget(),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              return _scheduleCard(schedule);
            },
          ),
        ),
      ],
    );
  }

  Widget _calendarWidget() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        selectedDecoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.grey.shade300,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }

  Widget _scheduleCard(Map<String, String> schedule) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          color: AppColor.transparent,
          padding: const EdgeInsets.all(12),
          child: Row(
            spacing: 3,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tuesday, Dec 9 - 4:00 PM - 6:00 PM',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      schedule['title']!,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Instructor: ${schedule['instructor']}',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),

              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Get.toNamed(AppRoutes.coachesDetail,arguments: {'from':'basket_schedule'});
                },
                child: Text(
                  'View Detail',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
