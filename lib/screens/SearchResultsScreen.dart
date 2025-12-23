import 'package:fc_stats_24/components/playerCard.dart';
import 'package:fc_stats_24/db/players22.dart';
import 'package:fc_stats_24/utlis/CustomColors.dart';
import 'package:flutter/material.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;
  final double minOverall;
  final double maxOverall;
  final double minPotential;
  final double maxPotential;
  final double minAge;
  final double maxAge;
  final List<String> selectedPositions;
  final String? preferredFoot;
  final String? league;
  final String? nationality;
  final String? club;
  final String? playStyles;
  final String? roles;

  const SearchResultsScreen({
    super.key,
    required this.query,
    required this.minOverall,
    required this.maxOverall,
    required this.minPotential,
    required this.maxPotential,
    required this.minAge,
    required this.maxAge,
    required this.selectedPositions,
    this.preferredFoot,
    this.league,
    this.nationality,
    this.club,
    this.playStyles,
    this.roles,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  bool loading = true;
  List<Map> players = [];

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    setState(() {
      loading = true;
    });
    
    final results = await PlayersDatabase.instance.filterPlayers(
      query: widget.query,
      minOverall: widget.minOverall,
      maxOverall: widget.maxOverall,
      minPotential: widget.minPotential,
      maxPotential: widget.maxPotential,
      minAge: widget.minAge,
      maxAge: widget.maxAge,
      positions: widget.selectedPositions,
      preferredFoot: widget.preferredFoot,
      league: widget.league,
      nationality: widget.nationality,
      club: widget.club,
      playStyles: widget.playStyles,
      roles: widget.roles,
    );



    if (mounted) {
      setState(() {
        players = results;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2228),
      appBar: AppBar(
        title: const Text("Search Results"),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: posColor))
          : players.isEmpty
              ? const Center(
                  child: Text(
                    "No players found matching your criteria.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    return PlayerCard(
                      playerData: players[index],
                    );
                  },
                ),
    );
  }
}
