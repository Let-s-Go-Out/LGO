import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActionButtons extends StatefulWidget {
  final Function change;
  const ActionButtons({Key? key, required this.change}) : super(key: key);

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  bool isFront = true;

  @override
  Widget build(BuildContext context) {
    var today = DateTime.now(); // 현재 날짜 및 시간 가져오기
    String formattedDate = DateFormat('yyyy/MM/dd').format(today); // 날짜 형식 지정

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          // today chip
          Container(
            width: 180.0,
            height: 50.0,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wb_sunny_rounded),
                const SizedBox(width: 10.0),

                // today details (date, month)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Today',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        formattedDate,
                        //'2023/08/15',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(width: 10.0),
          // 다이어리 작성 페이지 전환 버튼
          GestureDetector(
            onTap: () {
              widget.change();
              setState(() {
                isFront = !isFront;
              });
            },
            child: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: isFront ? Colors.black87 : Color.fromARGB(255, 216, 216, 216),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFront ? Icons.mode_edit_outlined : Icons.book_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}