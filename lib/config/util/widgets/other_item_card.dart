import 'package:flutter/material.dart';

import 'package:eshop/config/theme/styles.dart';

class OtherItemCard extends StatelessWidget {
  final String title;
  final Function()? onClick;
  final IconData? icon;
  const OtherItemCard({
    super.key,
    required this.title,
    this.onClick,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            onTap: onClick,
            leading: Icon(
              icon,
              size: 30,
            ),
            title: Text(
              title,
              style: Styles.font16WhiteMedium.copyWith(color: Colors.black),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
