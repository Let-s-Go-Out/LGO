import 'package:flutter/material.dart';
import 'package:nagaja_app/View/widgets/theme.dart';

class MyInputFieldMessage extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const MyInputFieldMessage({Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
            padding: EdgeInsets.only(left: 10),
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
                        keyboardType: TextInputType.multiline,
                        minLines: 2,
                        maxLines: 4,
                        textAlign: TextAlign.start,
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
