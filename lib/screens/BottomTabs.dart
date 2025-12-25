import 'package:fc_stats_24/components/GlobalDrawer.dart';
import 'package:fc_stats_24/screens/HomeScreen.dart';
import 'package:fc_stats_24/screens/SearchScreen.dart';
import 'package:fc_stats_24/screens/SquadsScreen.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

class BottomTabs extends StatefulWidget {
  const BottomTabs({super.key});

  @override
  State<BottomTabs> createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    final List<Widget> _widgetOptions = <Widget>[
      HomeScreen(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        onSearchTab: () => _onItemTapped(1),
        onSquadsTab: () => _onItemTapped(2),
      ),
      SearchScreen(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        onSquadsTab: () => _onItemTapped(2),
      ),
      SquadsScreen(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        onSearchTab: () => _onItemTapped(1),
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: GlobalDrawer(
        onTabRequested: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.sports_soccer_rounded,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.groups,
            ),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: appColors.posColor,
        backgroundColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
