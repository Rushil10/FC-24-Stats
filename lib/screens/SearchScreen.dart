import 'package:fc_stats_24/components/playerCard.dart';
import 'package:fc_stats_24/db/players22.dart';
import 'package:fc_stats_24/utlis/CustomColors.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  bool loading = false;
  var players = [];

  void searchPlayer(var st) async {
    setState(() {
      loading = true;
    });
    var playerResults = await PlayersDatabase.instance.searchPlayers(st);
    //print(playerResults.length);
    setState(() {
      players = playerResults;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              autofocus: false,
              onChanged: (text) {
                if (text.length > 2) {
                  searchPlayer(text);
                }
              },
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 25,
                    color: Colors.black,
                  ),
                  //contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  hintText: 'SEARCH',
                  fillColor: posColor,
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 19),
                  filled: true),
              style: const TextStyle(color: Colors.black, fontSize: 19),
            ),
          ),
          Expanded(
              child: !loading
                  ? ListView.builder(
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        return PlayerCard(
                          playerData: players[index],
                        );
                      })
                  : const Center(
                      child: CircularProgressIndicator(
                        color: posColor,
                      ),
                    ))
        ],
      ),
    );
  }
}
