import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

 Widget buildMenuButton(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
        
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.orange[200], // Ripple effect
        highlightColor: Colors.orange[100], // Orange shade when pressed
        borderRadius: BorderRadius.circular(30),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white, // Default button background
            borderRadius: BorderRadius.circular(30),
            
            
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Icon(icon, color: Colors.orange), // Icons remain black
                SizedBox(width: 20),
                Text(
                  text,
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }