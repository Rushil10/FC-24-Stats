import 'package:fc_stats_24/config_ads.dart';
import 'package:fc_stats_24/screens/FavouritesScreen.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlobalDrawer extends ConsumerWidget {
  final Function(int)? onTabRequested;

  const GlobalDrawer({super.key, this.onTabRequested});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: appColors.posColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  appTitle,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'FC $appYear Database',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              onTabRequested?.call(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Search Players'),
            onTap: () {
              Navigator.pop(context);
              onTabRequested?.call(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.groups),
            title: const Text('Squad Builder'),
            onTap: () {
              Navigator.pop(context);
              onTabRequested?.call(2);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.star, color: Colors.amber),
            title: const Text('Favourites'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Favourites(
                    type: "Fav",
                    title: "Favourites",
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.trending_up, color: Colors.green),
            title: const Text('Emerging Players'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Favourites(
                    type: "Young",
                    title: "Emerging Players",
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_search, color: Colors.blue),
            title: const Text('Free Agents'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Favourites(
                    type: "Free",
                    title: "Free Agents",
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
