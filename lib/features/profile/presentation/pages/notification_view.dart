import 'package:eshop/config/locale/tranlslations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.notifications.getString(context)),
      ),
    );
  }
}
