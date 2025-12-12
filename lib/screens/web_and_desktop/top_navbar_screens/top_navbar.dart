import 'package:flutter/material.dart';

class TopNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const TopNavbar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: 'E', style: TextStyle(color: Color(0xFF00FF4C))),
                TextSpan(text: 'THIO', style: TextStyle(color: Color(0xFFFCDB00))),
                TextSpan(text: 'WORKS', style: TextStyle(color: Color(0xFFFF0000))),
              ],
            ),
          ),
          const Spacer(),

          _navItem("Home", 0),
          const SizedBox(width: 32),
          _navItem(" Post Jobs", 1),
          const SizedBox(width: 32),
          _navItem("Dashboard", 2),
          const SizedBox(width: 32),
          _navItem("Profile", 3),
        ],
      ),
    );
  }

  Widget _navItem(String title, int index) {
    final bool isActive = selectedIndex == index;

    return InkWell(
      onTap: () => onItemSelected(index),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          color: isActive ? Colors.blue : Colors.black87,
        ),
      ),
    );
  }
}
