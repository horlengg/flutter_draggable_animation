


import 'package:draggable_animation/draggable_animation.dart';
import 'package:draggable_animation/draggable_animation_helper.dart';
import 'package:flutter/material.dart';



void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final Uri? initialUri;
  const MyApp({super.key, this.initialUri});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List<String> monthList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  
  List<String> applicationList = [
    'Calendar',
    'Email',
    'Camera',
    'Photos',
    'Maps',
    'Messages',
    'Phone',
    'Contacts',
    'Browser',
  ];



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF4B5D4), // Soft pinkish-lavender
                Color(0xFF9E87F2), // Muted purple
                Color(0xFF7E6BF1), // Deep purple/blue
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:12.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text("List Item Disply Grid",style: TextStyle(fontSize: 30,color: Colors.white),),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: DraggableAnimation(
                      items: monthList, 
                      displayer: DraggableAnimationGridDisplay(
                        columnCount: 4,
                        rowHeight: 80,
                        spacingX: 20,
                        spacingY: 20
                      ),
                      // duration: Duration(milliseconds: 100),
                      builder: (data) => _buildCard(data), 
                      feedbackBuilder: (data) => _buildCard(data,feedback: true), //custom style
                      // onChange: (from, to) {},
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  const Text("List Item Disply Row",style: TextStyle(fontSize: 30,color: Colors.white),),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: DraggableAnimation(
                      items: applicationList, 
                      displayer: DraggableAnimationRowDisplay(
                        colWidth: 100,
                        spacingX: 20
                      ),
                      builder: (data) => _buildCard(data),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String data,{bool feedback = false}){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white ,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        child: Text(data),
      ),
    );
  }

}

