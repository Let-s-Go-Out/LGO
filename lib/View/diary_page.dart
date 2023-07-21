import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {

  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();

  Map<DateTime, List<Event>> events = {
    DateTime.utc(2023,7,10) : [ Event('route1')],
    DateTime.utc(2023,7,11) : [ Event('route2')],
  };

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: TableCalendar(
        firstDay: DateTime.utc(2021, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: focusedDay,
        onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
          // 선택된 날짜의 상태 갱신
          setState((){
            this.selectedDay = selectedDay;
            this.focusedDay = focusedDay;
          });
        },
        selectedDayPredicate: (DateTime day) {
          // selectedDay 와 동일한 날짜의 모양 바꿔줌
          return isSameDay(selectedDay, day);
        },
        calendarStyle: CalendarStyle(
          markerSize: 36.9,
          markersAnchor: 1.02,
          markerDecoration: BoxDecoration(
            color: Color.fromRGBO(255, 75, 75, 0.5),
            shape: BoxShape.circle
          ),
        ),
        eventLoader: _getEventsForDay,
      ),
    );
  }
}

class Event {
  String title;

  Event(this.title);
}

