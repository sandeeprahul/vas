import 'package:flutter/material.dart';

class AnimalBgWidget extends StatelessWidget {
  const AnimalBgWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Shadow version behind the main image
          Transform.translate(
            offset: const Offset(5, 5), // Offset to bottom-right
            child: Transform.rotate(
              angle: 0.05, // Slight angle in radians (~2.8 degrees)
              child: Opacity(
                opacity: 0.3, // Shadow darkness
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Colors.black38,
                    BlendMode.srcIn,
                  ),
                  child: Image.asset('assets/bg_animals.png'),
                ),
              ),
            ),
          ),

          // Main image
           Image.asset('assets/bg_animals.png'),
        ],
      ),
    );
  }
}
