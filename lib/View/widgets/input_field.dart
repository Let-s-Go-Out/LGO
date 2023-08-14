import 'package:flutter/material.dart';
import 'package:nagaja_app/View/widgets/theme.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const MyInputField({Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            height: 40,
            margin: EdgeInsets.only(top: 5.0),
            padding: EdgeInsets.only(left: 10, bottom: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0
              ),
              borderRadius: BorderRadius.circular(12)
            ),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                      readOnly: widget==null?false:true,
                      autofocus: false,
                      cursorColor: Colors.grey,
                      style: subTitleStyle,
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: subTitleStyle,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 0
                          )
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 0
                            )
                        ),
                      )
                  )
                ),
                widget==null?Container():Container(child:widget)
              ],
            ),
          )
        ],
      ),
    );
  }
}
