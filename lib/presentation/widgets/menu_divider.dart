import 'package:flutter/material.dart';

class MenuDivider extends StatelessWidget {
  String title;
  void Function()? onTap;
  MenuDivider({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: onTap,
          child: const Text(
            "View All",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }
}
