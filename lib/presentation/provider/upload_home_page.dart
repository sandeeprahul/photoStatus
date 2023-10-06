import 'package:flutter/material.dart';
import 'package:photostatus/presentation/provider/all_bookings_page.dart';
import 'package:photostatus/presentation/consumer/my_events_tab_page.dart';
import 'package:photostatus/presentation/provider/upload_desings_tab.dart';


class UploadHomePage extends StatefulWidget {
  const UploadHomePage({Key? key}) : super(key: key);

  @override
  _UploadHomePageState createState() => _UploadHomePageState();
}

class _UploadHomePageState extends State<UploadHomePage> {
  final List<Widget> _tabs = [
    const UploadDesignsPage(),
    const AllBookingsPage(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(_selectedIndex==0?'Upload a design':'Update Bookings'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Designs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Bookings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onTabTapped,
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
