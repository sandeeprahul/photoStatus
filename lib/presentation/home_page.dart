import 'package:flutter/material.dart';
import 'package:photostatus/presentation/consumer/my_events_tab_page.dart';
import 'package:photostatus/presentation/consumer/photo_frames_page.dart';
import 'package:photostatus/presentation/widgets/custom_bottom_navigation_bar.dart';

import 'consumer/events_tab_page.dart';
import 'consumer/video_edit_age.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> _tabs = [
    const EventsTab(),
    const VideoEditPage(),
    const PhotoFramesPage(),
    const MyEventsTab(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0
            ? 'Select a design'
            : _selectedIndex == 3
                ? 'My Orders'
                : ''),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabs,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
          onTabTapped: (index) {
            setState(() {
              _selectedIndex = index;
            });
          }),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
