import 'package:fc_stats_24/components/playerCard.dart';
import 'package:fc_stats_24/db/Player.dart';
import 'package:fc_stats_24/db/players22.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:fc_stats_24/providers/search_provider.dart';
import 'package:flutter/material.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;
  final SearchFilters filters;

  const SearchResultsScreen({
    super.key,
    required this.query,
    required this.filters,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  bool loading = true;
  List<Player> players = [];

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    setState(() {
      loading = true;
    });

    final List<Player> results = await PlayersDatabase.instance.filterPlayers(
      query: widget.query,
      minOverall: widget.filters.overallRange.start,
      maxOverall: widget.filters.overallRange.end,
      minPotential: widget.filters.potentialRange.start,
      maxPotential: widget.filters.potentialRange.end,
      minAge: widget.filters.ageRange.start,
      maxAge: widget.filters.ageRange.end,
      positions: widget.filters.selectedPositions,
      preferredFoot: widget.filters.preferredFoot,
      leagues: widget.filters.selectedLeagues,
      nationalities: widget.filters.selectedNationalities,
      clubs: widget.filters.selectedClubs,
      playStyles: widget.filters.selectedPlayStyles,
      minPace: widget.filters.paceRange.start,
      maxPace: widget.filters.paceRange.end,
      minHeight: widget.filters.heightRange.start,
      maxHeight: widget.filters.heightRange.end,
      minWeight: widget.filters.weightRange.start,
      maxWeight: widget.filters.weightRange.end,
      minSkillMoves: widget.filters.skillMovesRange.start,
      maxSkillMoves: widget.filters.skillMovesRange.end,
      minWeakFoot: widget.filters.weakFootRange.start,
      maxWeakFoot: widget.filters.weakFootRange.end,
      minReputation: widget.filters.internationalReputationRange.start,
      maxReputation: widget.filters.internationalReputationRange.end,
      minShooting: widget.filters.shootingRange.start,
      maxShooting: widget.filters.shootingRange.end,
      minPassing: widget.filters.passingRange.start,
      maxPassing: widget.filters.passingRange.end,
      minDribbling: widget.filters.dribblingRange.start,
      maxDribbling: widget.filters.dribblingRange.end,
      minDefending: widget.filters.defendingRange.start,
      maxDefending: widget.filters.defendingRange.end,
      minPhysic: widget.filters.physicalRange.start,
      maxPhysic: widget.filters.physicalRange.end,
      minAcceleration: widget.filters.accelerationRange.start,
      maxAcceleration: widget.filters.accelerationRange.end,
      minSprintSpeed: widget.filters.sprintSpeedRange.start,
      maxSprintSpeed: widget.filters.sprintSpeedRange.end,
      minPositioning: widget.filters.positioningRange.start,
      maxPositioning: widget.filters.positioningRange.end,
      minFinishing: widget.filters.finishingRange.start,
      maxFinishing: widget.filters.finishingRange.end,
      minShotPower: widget.filters.shotPowerRange.start,
      maxShotPower: widget.filters.shotPowerRange.end,
      minLongShots: widget.filters.longShotsRange.start,
      maxLongShots: widget.filters.longShotsRange.end,
      minVolleys: widget.filters.volleysRange.start,
      maxVolleys: widget.filters.volleysRange.end,
      minPenalties: widget.filters.penaltiesRange.start,
      maxPenalties: widget.filters.penaltiesRange.end,
      minVision: widget.filters.visionRange.start,
      maxVision: widget.filters.visionRange.end,
      minCrossing: widget.filters.crossingRange.start,
      maxCrossing: widget.filters.crossingRange.end,
      minFkAccuracy: widget.filters.fkAccuracyRange.start,
      maxFkAccuracy: widget.filters.fkAccuracyRange.end,
      minShortPassing: widget.filters.shortPassingRange.start,
      maxShortPassing: widget.filters.shortPassingRange.end,
      minLongPassing: widget.filters.longPassingRange.start,
      maxLongPassing: widget.filters.longPassingRange.end,
      minCurve: widget.filters.curveRange.start,
      maxCurve: widget.filters.curveRange.end,
      minAgility: widget.filters.agilityRange.start,
      maxAgility: widget.filters.agilityRange.end,
      minBalance: widget.filters.balanceRange.start,
      maxBalance: widget.filters.balanceRange.end,
      minReactions: widget.filters.reactionsRange.start,
      maxReactions: widget.filters.reactionsRange.end,
      minBallControl: widget.filters.ballControlRange.start,
      maxBallControl: widget.filters.ballControlRange.end,
      minDribblingSkill: widget.filters.dribblingSkillRange.start,
      maxDribblingSkill: widget.filters.dribblingSkillRange.end,
      minComposure: widget.filters.composureRange.start,
      maxComposure: widget.filters.composureRange.end,
      minInterceptions: widget.filters.interceptionsRange.start,
      maxInterceptions: widget.filters.interceptionsRange.end,
      minHeadingAccuracy: widget.filters.headingAccuracyRange.start,
      maxHeadingAccuracy: widget.filters.headingAccuracyRange.end,
      minMarking: widget.filters.markingRange.start,
      maxMarking: widget.filters.markingRange.end,
      minStandingTackle: widget.filters.standingTackleRange.start,
      maxStandingTackle: widget.filters.standingTackleRange.end,
      minSlidingTackle: widget.filters.slidingTackleRange.start,
      maxSlidingTackle: widget.filters.slidingTackleRange.end,
      minJumping: widget.filters.jumpingRange.start,
      maxJumping: widget.filters.jumpingRange.end,
      minStamina: widget.filters.staminaRange.start,
      maxStamina: widget.filters.staminaRange.end,
      minStrength: widget.filters.strengthRange.start,
      maxStrength: widget.filters.strengthRange.end,
      minAggression: widget.filters.aggressionRange.start,
      maxAggression: widget.filters.aggressionRange.end,
      minGkDiving: widget.filters.gkDivingRange.start,
      maxGkDiving: widget.filters.gkDivingRange.end,
      minGkHandling: widget.filters.gkHandlingRange.start,
      maxGkHandling: widget.filters.gkHandlingRange.end,
      minGkKicking: widget.filters.gkKickingRange.start,
      maxGkKicking: widget.filters.gkKickingRange.end,
      minGkReflexes: widget.filters.gkReflexesRange.start,
      maxGkReflexes: widget.filters.gkReflexesRange.end,
      minGkSpeed: widget.filters.gkSpeedRange.start,
      maxGkSpeed: widget.filters.gkSpeedRange.end,
      minGkPositioning: widget.filters.gkPositioningRange.start,
      maxGkPositioning: widget.filters.gkPositioningRange.end,
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
    final appColors = Theme.of(context).extension<AppColors>()!;
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Search Results"),
        backgroundColor: scaffoldColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: appColors.posColor))
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
