import 'package:fc_stats_24/State/VideoAdState.dart';
import 'package:fc_stats_24/components/playerCard.dart';
import 'package:fc_stats_24/db/Player.dart';
import 'package:fc_stats_24/db/players22.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final VoidCallback? onOpenDrawer;
  final VoidCallback? onSearchTab;
  final VoidCallback? onSquadsTab;

  const HomeScreen({
    super.key,
    this.onOpenDrawer,
    this.onSearchTab,
    this.onSquadsTab,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool loading = true;
  List<Player> players = [];

  @override
  void initState() {
    super.initState();
    ref.read(videoAdProvider);
    getTop100PlayerData();
  }

  Future<void> getTop100PlayerData() async {
    setState(() {
      loading = true;
    });
    var top100Players = await PlayersDatabase.instance.top100Players();
    setState(() {
      players = top100Players;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Player Stats 24"),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: widget.onOpenDrawer,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: widget.onSearchTab,
            ),
            IconButton(
              icon: const Icon(Icons.groups),
              onPressed: widget.onSquadsTab,
            ),
          ],
        ),
        body: !loading
            ? Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: queryData.size.width * 0.12,
                          alignment: Alignment.center,
                          child: const Text(
                            'OVR',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                        Container(
                          width: queryData.size.width * 0.12,
                          alignment: Alignment.center,
                          child: const Text(
                            'POT',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                        Container(
                          width: queryData.size.width * 0.12,
                          alignment: Alignment.center,
                          child: const Text(
                            'AGE',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: players.length,
                          itemBuilder: (context, index) {
                            return PlayerCard(
                              playerData: players[index],
                            );
                          })),
                ],
              )
            : Center(
                child: SizedBox(
                  height: 45,
                  width: 45,
                  child: CircularProgressIndicator(
                    color: appColors.posColor,
                  ),
                ),
              ));
  }
}
