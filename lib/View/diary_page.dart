import 'dart:math';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nagaja_app/View/widgets/theme.dart';
import 'package:nagaja_app/View/widgets/diary_view.dart';
import 'package:nagaja_app/View/widgets/diary_edit_view.dart';
import 'package:nagaja_app/View/widgets/action_buttons.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> with TickerProviderStateMixin {
  bool isFrontView = true;

  late AnimationController controller;

  switchView() {
    setState(() {
      if (isFrontView) {
        controller.forward();
      } else {
        controller.reverse();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15.0),
            Text(
              "Diary",
              style: mainPageTitleStyle),
            const SizedBox(height: 5.0),

            // month cards
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 22.0),
                child: PageView.builder(
                  controller: PageController(
                    initialPage: 0,
                    viewportFraction: 0.78,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: 3, // 동적 생성
                  itemBuilder: (_, i) => AnimatedBuilder(
                      animation: controller,
                      builder: (_, child) {
                        if (controller.value >= 0.5) {
                          isFrontView = false;
                        } else {
                          isFrontView = true;
                        }

                        return Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(controller.value * pi),
                          alignment: Alignment.center,
                          child: isFrontView
                              ? DiaryView(monthIndex: i + 1)
                              : Transform(
                            transform: Matrix4.rotationY(pi),
                            alignment: Alignment.center,
                            child: DiaryEditView(
                              monthIndex: i + 1,
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
            const SizedBox(height: 2.0),
            // action buttons
            ActionButtons(change: switchView),
            const SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }
}
