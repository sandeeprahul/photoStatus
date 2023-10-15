import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTabTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300), // Adjust the animation duration as needed
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black, // Background color for the bottom navigation bar
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildNavItem(0, Icons.home, 'Designs'),
          _buildNavItem(1, Icons.video_stable_sharp, 'Video Edits'),
          _buildNavItem(2, Icons.filter_frames, 'Photo frames'),
          _buildNavItem(3, Icons.add_shopping_cart_outlined, 'My Orders'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTabTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Adjust the animation duration as needed
        padding:  EdgeInsets.all( isSelected ? 12:8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, color: isSelected ? Colors.white : Colors.grey,size: isSelected ?16:14,),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontSize: isSelected ? 14 : 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
