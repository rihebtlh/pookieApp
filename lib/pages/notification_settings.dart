import 'package:flutter/material.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key}) : super(key: key);

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),  // Reduced padding for compact size
      decoration: BoxDecoration(
        color: const Color(0xFF72DDF7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Turn off Notifications',
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xFF1E1E1E),
                  fontFamily: 'Rubik',
                ),
              ),
              Switch(
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
                activeColor: const Color(0xFFFFAFCC),
                activeTrackColor: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 8),  // Reduced spacing between items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Notification Settings',
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xFF1E1E1E),
                  fontFamily: 'Rubik',
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}
