import 'package:fc_stats_24/State/VideoAdState.dart';
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Player Stats 24',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'FC 24 Database',
                  style: TextStyle(
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
              final count = ref.read(videoAdProvider);
              ref.read(videoAdProvider.notifier).increment();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Favourites(
                    type: "Fav",
                    title: "Favourites",
                    count: count,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.trending_up, color: Colors.green),
            title: const Text('Emerging Players'),
            onTap: () {
              final count = ref.read(videoAdProvider);
              ref.read(videoAdProvider.notifier).increment();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Favourites(
                    type: "Young",
                    title: "Emerging Players",
                    count: count,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_search, color: Colors.blue),
            title: const Text('Free Agents'),
            onTap: () {
              final count = ref.read(videoAdProvider);
              ref.read(videoAdProvider.notifier).increment();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Favourites(
                    type: "Free",
                    title: "Free Agents",
                    count: count,
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
