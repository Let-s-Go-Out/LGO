import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nagaja_app/View/add_route_page.dart';
import 'package:nagaja_app/View/widgets/theme.dart';
import 'package:get/get.dart';

class SecondDiaryPage extends StatefulWidget {
  const SecondDiaryPage({super.key});

  @override
  State<SecondDiaryPage> createState() => _SecondDiaryPageState();
}

class _SecondDiaryPageState extends State<SecondDiaryPage> {
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          _appRouteBar(),
          _appDateBar(),
        ],
      ),
    );
  }
  _appDateBar(){
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 10),
      child: DatePicker(
        DateTime.now(),
        height: 85,
        width: 65,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        monthTextStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey
        ),
        dateTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.grey
        ),
        dayTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey
        ),
        onDateChange: (date){
          _selectedDate=date;
        },
      ),
    );
  }
  _appRouteBar(){
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text("Today",
                  style: headingStyle,
                )
              ],
            ),
          ),
          ElevatedButton(
            child: Row(
              children: [
                Icon(Icons.add),
                Text("Add Route"),
              ],
            ),
            onPressed: ()=>Get.to(AddRoutePage())
          )
        ],
      ),
    );
  }
}
