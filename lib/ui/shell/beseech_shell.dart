import 'package:beseech/ui/dashboard/dashboard_page.dart';
import 'package:beseech/ui/history/history_page.dart';
import 'package:beseech/ui/profile/profile_page.dart';
import 'package:beseech/ui/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_database/app/liquid_widgets.dart';

class BeseechShell extends StatefulWidget {
  const BeseechShell({super.key});

  @override
  State<BeseechShell> createState() => _BeseechShellState();
}

class _BeseechShellState extends State<BeseechShell> {
  int _index = 0;

  static const _tabs = [
    (icon: Icons.home_rounded, label: 'Today'),
    (icon: Icons.history_rounded, label: 'History'),
    (icon: Icons.person_rounded, label: 'You'),
    (icon: Icons.tune_rounded, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return LiquidCanvas(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IndexedStack(
          index: _index,
          children: const [
            DashboardPage(),
            HistoryPage(),
            ProfilePage(),
            SettingsPage(),
          ],
        ),
        bottomNavigationBar: LiquidNavBar(
          selectedIndex: _index,
          onSelected: (i) => setState(() => _index = i),
          destinations: [
            for (final tab in _tabs)
              NavigationDestination(
                icon: Icon(tab.icon),
                selectedIcon: Icon(tab.icon),
                label: tab.label,
              ),
          ],
        ),
      ),
    );
  }
}
