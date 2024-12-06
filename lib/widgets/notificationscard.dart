import 'package:flutter/material.dart';

class ReminderCard extends StatelessWidget {
  final String date;
  final String location;
  final String time;
  final String imageUrl;
  final bool isHighlighted; // Add this parameter

  const ReminderCard({
    Key? key,
    required this.date,
    required this.location,
    required this.time,
    required this.imageUrl,
    this.isHighlighted = false, // Default to false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 393,
        height: 131,
        decoration: BoxDecoration(
          color: isHighlighted ? Colors.grey : Colors.white, // Highlighted card gets orange background
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: const Color(0x33000000),
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional(-1, -1),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      date,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontFamily: 'Inter Tight',
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      location,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontFamily: 'Inter Tight',
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1, 1),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      time,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontFamily: 'Inter Tight',
                            color: Colors.red,
                            letterSpacing: 0.0,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: AlignmentDirectional(1, 0),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      imageUrl,
                      width: 153,
                      height: 100,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
