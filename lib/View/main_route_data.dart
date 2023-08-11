import 'package:flutter/material.dart';

class MainRouteData extends StatelessWidget {
  const MainRouteData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Container(
                height: size.height*0.1,
                width: size.width,
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              Container(
                height: size.height*0.1,
                width: size.width,
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              Container(
                height: size.height*0.1,
                width: size.width,
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              Container(
                height: size.height*0.1,
                width: size.width,
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              Container(
                height: size.height*0.1,
                width: size.width,
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              Container(
                height: size.height*0.1,
                width: size.width,
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              Container(
                height: size.height*0.1,
                width: size.width,
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ],
          )
        )
      ),
    );
  }
}