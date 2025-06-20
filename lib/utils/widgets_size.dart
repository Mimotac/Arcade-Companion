import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class WidgetsSize extends StatefulWidget {
  final Widget child;
  final Function onChange;

  const WidgetsSize({super.key, required this.onChange, required this.child});

  @override
  State<WidgetsSize> createState() => _WidgetsSizeState();
}

class _WidgetsSizeState extends State<WidgetsSize> {
  final GlobalKey _widgetKey = GlobalKey();
  Size? _oldSize;

  void postFrameCallback(_) {
    BuildContext? context = _widgetKey.currentContext;
    if (context == null) return;

    Size? newSize = context.size;
    if (_oldSize == newSize) return;

    _oldSize = newSize;
    widget.onChange(newSize);
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    return Container(key: _widgetKey, child: widget.child);
  }
}
