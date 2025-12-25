import 'package:fc_stats_24/components/playerCard.dart';
import 'package:fc_stats_24/db/Player.dart';
import 'package:fc_stats_24/db/players22.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Favourites extends ConsumerStatefulWidget {
  final String type;
  final String title;
  const Favourites({super.key, required this.type, required this.title});

  @override
  ConsumerState<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends ConsumerState<Favourites> {
  bool loading = true;
  List<Player> players = [];

  @override
  void initState() {
    super.initState();
    if (widget.type == "Fav") {
      getFavouritePlayers();
    }
    if (widget.type == "Young") {
      getYoungPlayers();
    }
    if (widget.type == "Free") {
      getAllFreePlayers();
    }
  }

  void getFavouritePlayers() async {
    var all = await PlayersDatabase.instance.getFavourites();
    setState(() {
      players = all;
      loading = false;
    });
  }

  void getAllFreePlayers() async {
    var all = await PlayersDatabase.instance.getFreeAgents();
    setState(() {
      players = all;
      loading = false;
    });
  }

  void getYoungPlayers() async {
    var all = await PlayersDatabase.instance.getYoungPlayers();
    setState(() {
      players = all;
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
          title: Text(widget.title),
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
                  width: 45,
                  height: 45,
                  child: CircularProgressIndicator(
                    color: appColors.posColor,
                  ),
                ),
              ));
  }
}
