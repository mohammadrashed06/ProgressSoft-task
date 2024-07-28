import 'package:flutter/material.dart';

class LanguageDialog extends StatelessWidget {
  final Function(Locale) onLocaleChange;

  const LanguageDialog({super.key, required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Language'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('English'),
            onTap: () {
              onLocaleChange(const Locale('en'));
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text('Arabic'),
            onTap: () {
              onLocaleChange(const Locale('ar'));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
