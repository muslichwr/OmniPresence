import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_attendance/config/app_colors.dart';

class SettingsSwitch extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool value;
  final Function(bool) onChanged;

  const SettingsSwitch({
    Key? key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }
}
