import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress_soft_task/screens/main/profile_tab.dart';

import 'home_tab.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    const HomeTab(),
    const ProfileTab(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _currentIndex == 0 ? Text(tr("mainPage.home")) :  Text(tr("mainPage.profile")),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Change Language'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('English'),
                          onTap: () {
                            context.setLocale(
                              const Locale('en'),
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: const Text('Arabic'),
                          onTap: () {
                            context.setLocale(
                              const Locale('ar'),
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  )
              );
            },
          ),
        ],
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: tr("mainPage.home"),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: tr("mainPage.profile"),
          ),
        ],
      ),
    );
  }
}
