


import 'package:draggable_animation/draggable_animation.dart';
import 'package:draggable_animation/draggable_animation_helper.dart';
import 'package:flutter/material.dart';


void main() async {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Container(
        color: Colors.blueAccent,
        padding: const EdgeInsets.only(left: 40.0,right: 40.0,bottom: 8.0,top: 80),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: DraggableAnimation(
            items: List.generate(4 * 6, (index) => index), 
            displayer: DraggableAnimationGridDisplay(
              columnCount: 4,
              rowHeight: 80,
              spacingX: 20,
              spacingY: 30
            ),
            builder: (data)=> _buildAppIcon(),
            feedbackBuilder: (data) => _buildAppIcon(feedback: true),
          ),
        ),
      ),
    );
  }

  _buildAppIcon({bool feedback = false}){
    return Column(
      children: [
        Container(
          width: 60,
          height: 55,
          decoration: BoxDecoration(
            // color: Colors.amber,
            image: const DecorationImage(
              image: NetworkImage("https://d2ms8rpfqc4h24.cloudfront.net/What_is_Flutter_f648a606af.png"),
              fit: BoxFit.cover
            ),
            borderRadius: BorderRadius.circular(15.0)
          ),
        ),
        const SizedBox(height: 3),
        feedback ? const SizedBox.shrink() : const Text("Flutter App",style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w600))
      ],
    );
  }
}

