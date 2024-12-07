import 'package:flutter/material.dart';

Widget buildMenuButton(BuildContext context,
    {required IconData icon, required String text, required VoidCallback onTap}) {
  return Material(
    color: Colors.transparent, // Make Material widget background transparent
    child: InkWell(
      onTap: onTap,
      splashColor: Colors.orange.withOpacity(0.3), // Ripple effect color
      highlightColor: Colors.orange.withOpacity(0.1), // Highlight color
      borderRadius: BorderRadius.circular(12), // Optional: Rounded border for the effect
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[300], // Light gray background
          borderRadius: BorderRadius.circular(12), // Rounded edges
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.black),
                SizedBox(width: 10),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.black),
          ],
        ),
      ),
    ),
  );
}
