import 'package:flutter/material.dart';

class RowHeader extends StatelessWidget {
  final String day;
  final int vacancyCount;

  RowHeader({required this.day, required this.vacancyCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 35,
                  margin: EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      width: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.black,
                        size: 12,
                      ),
                      const SizedBox(width: 1),
                      Text(
                        '$vacancyCount',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.add_box_rounded,
                  color: Colors.blue.shade400,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
