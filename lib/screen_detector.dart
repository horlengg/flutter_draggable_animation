
import 'dart:async';

import 'package:flutter/material.dart';

class ScreenDetector extends StatefulWidget {

  final Function(PointerMoveEvent)? onLongPressAndMove;
  final Widget child;
  final Duration duration;
  final Function? destroy;
  final Function? onLongPress;

  const ScreenDetector({
    Key? key,
    // super.key,
    required this.child,
    this.onLongPressAndMove,
    this.duration = const Duration(milliseconds: 500),
    this.destroy,
    this.onLongPress,
  }) : super(key: key);

  @override
  State<ScreenDetector> createState() => ScreenDetectorState();
}

class ScreenDetectorState extends State<ScreenDetector> {
  Timer? _pressTimer;
  bool _isDragable = false;

  void _startTimer() {
    _pressTimer = Timer(widget.duration, (){
      _isDragable = true;
      widget.onLongPress?.call();
    });
  }

  void _cancelTimer() {
    _pressTimer?.cancel();
    _pressTimer = null;
    _isDragable = false;
    widget.destroy?.call();
  }

  void disposeAllEvent(){
    _cancelTimer();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _startTimer(),
      onPointerUp: (_) => _cancelTimer(),
      onPointerCancel: (_) => _cancelTimer(),
      onPointerMove: (details){
        if(_isDragable){
          widget.onLongPressAndMove?.call(details);
        }
      },
      child: widget.child,
    );
  }
}
