import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed; 
  final bool isSelected; 

  const CategoryChip({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
    required this.isSelected, 
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double fontSize = screenWidth > 600 ? 18 : 14; 
    EdgeInsetsGeometry padding = screenWidth > 600
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 8);

    final backgroundColor = isSelected
        ? const Color.fromARGB(255, 255, 152, 0).withOpacity(0.2)
        : color.withOpacity(0.2);

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: padding,
        backgroundColor: backgroundColor, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,  
          color: isSelected
              ? Colors.orange
              : color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
