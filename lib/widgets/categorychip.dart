import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed; // Keep onPressed as the required callback
  final bool isSelected; // Add isSelected parameter to track the selection

  const CategoryChip({
    required this.label,
    required this.color,
    required this.onPressed,
    required this.isSelected, // Make isSelected a required parameter
  });

  @override
  Widget build(BuildContext context) {
    // Set the background color to orange if selected, otherwise use original color with opacity
    final backgroundColor = isSelected
        ? const Color.fromARGB(255, 255, 152, 0).withOpacity(0.2) // Orange for selected
        : color.withOpacity(0.2); // Original color with opacity for non-selected

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        backgroundColor: backgroundColor, // Set background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.orange : color, // White text when selected, original color otherwise
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
