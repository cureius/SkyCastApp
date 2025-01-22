import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sky_cast/core/theme/app_pallete.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController queryController;
  final List<String> hintTexts; // List of hint texts
  final Function(String) onSubmitted;

  const SearchBarWidget({
    super.key,
    required this.queryController,
    required this.hintTexts, // Accept a list of hint texts
    required this.onSubmitted,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late Timer _timer;
  int _currentHintIndex = 0;

  @override
  void initState() {
    super.initState();
    _startHintRotation();
  }

  void _startHintRotation() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentHintIndex = (_currentHintIndex + 1) % widget.hintTexts.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppPalette.backgroundColor(context).withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: widget.queryController,
          decoration: InputDecoration(
            hintText: widget.hintTexts[_currentHintIndex],
            // Use dynamic hint text
            prefixIcon: Icon(Icons.search, color: AppPalette.onBackgroundColor(context).withOpacity(0.8),),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          onSubmitted: widget.onSubmitted,
        ),
      ),
    );
  }
}
