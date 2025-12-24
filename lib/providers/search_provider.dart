import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchFilters {
  final RangeValues overallRange;
  final RangeValues potentialRange;
  final RangeValues ageRange;
  final List<String> selectedPositions;
  final String? preferredFoot;
  final List<String> selectedLeagues;
  final List<String> selectedNationalities;
  final List<String> selectedClubs;
  final List<String> selectedPlayStyles;
  final RangeValues heightRange;
  final RangeValues weightRange;
  final RangeValues skillMovesRange;
  final RangeValues weakFootRange;
  final RangeValues internationalReputationRange;
  final RangeValues paceRange;
  final RangeValues shootingRange;
  final RangeValues passingRange;
  final RangeValues dribblingRange;
  final RangeValues defendingRange;
  final RangeValues physicalRange;

  // Sub-attributes
  // PACE
  final RangeValues accelerationRange;
  final RangeValues sprintSpeedRange;
  // SHOOTING
  final RangeValues positioningRange;
  final RangeValues finishingRange;
  final RangeValues shotPowerRange;
  final RangeValues longShotsRange;
  final RangeValues volleysRange;
  final RangeValues penaltiesRange;
  // PASSING
  final RangeValues visionRange;
  final RangeValues crossingRange;
  final RangeValues fkAccuracyRange;
  final RangeValues shortPassingRange;
  final RangeValues longPassingRange;
  final RangeValues curveRange;
  // DRIBBLING
  final RangeValues agilityRange;
  final RangeValues balanceRange;
  final RangeValues reactionsRange;
  final RangeValues ballControlRange;
  final RangeValues dribblingSkillRange;
  final RangeValues composureRange;
  // DEFENDING
  final RangeValues interceptionsRange;
  final RangeValues headingAccuracyRange;
  final RangeValues markingRange;
  final RangeValues standingTackleRange;
  final RangeValues slidingTackleRange;
  final RangeValues jumpingRange;
  // PHYSICAL
  final RangeValues staminaRange;
  final RangeValues strengthRange;
  final RangeValues aggressionRange;
  // GOALKEEPING
  final RangeValues gkDivingRange;
  final RangeValues gkHandlingRange;
  final RangeValues gkKickingRange;
  final RangeValues gkReflexesRange;
  final RangeValues gkSpeedRange;
  final RangeValues gkPositioningRange;

  SearchFilters({
    this.overallRange = const RangeValues(0, 99),
    this.potentialRange = const RangeValues(0, 99),
    this.ageRange = const RangeValues(15, 45),
    this.selectedPositions = const [],
    this.preferredFoot,
    this.selectedLeagues = const [],
    this.selectedNationalities = const [],
    this.selectedClubs = const [],
    this.selectedPlayStyles = const [],
    this.heightRange = const RangeValues(120, 220),
    this.weightRange = const RangeValues(40, 110),
    this.skillMovesRange = const RangeValues(1, 5),
    this.weakFootRange = const RangeValues(1, 5),
    this.internationalReputationRange = const RangeValues(1, 5),
    this.paceRange = const RangeValues(0, 99),
    this.shootingRange = const RangeValues(0, 99),
    this.passingRange = const RangeValues(0, 99),
    this.dribblingRange = const RangeValues(0, 99),
    this.defendingRange = const RangeValues(0, 99),
    this.physicalRange = const RangeValues(0, 99),
    this.accelerationRange = const RangeValues(0, 99),
    this.sprintSpeedRange = const RangeValues(0, 99),
    this.positioningRange = const RangeValues(0, 99),
    this.finishingRange = const RangeValues(0, 99),
    this.shotPowerRange = const RangeValues(0, 99),
    this.longShotsRange = const RangeValues(0, 99),
    this.volleysRange = const RangeValues(0, 99),
    this.penaltiesRange = const RangeValues(0, 99),
    this.visionRange = const RangeValues(0, 99),
    this.crossingRange = const RangeValues(0, 99),
    this.fkAccuracyRange = const RangeValues(0, 99),
    this.shortPassingRange = const RangeValues(0, 99),
    this.longPassingRange = const RangeValues(0, 99),
    this.curveRange = const RangeValues(0, 99),
    this.agilityRange = const RangeValues(0, 99),
    this.balanceRange = const RangeValues(0, 99),
    this.reactionsRange = const RangeValues(0, 99),
    this.ballControlRange = const RangeValues(0, 99),
    this.dribblingSkillRange = const RangeValues(0, 99),
    this.composureRange = const RangeValues(0, 99),
    this.interceptionsRange = const RangeValues(0, 99),
    this.headingAccuracyRange = const RangeValues(0, 99),
    this.markingRange = const RangeValues(0, 99),
    this.standingTackleRange = const RangeValues(0, 99),
    this.slidingTackleRange = const RangeValues(0, 99),
    this.jumpingRange = const RangeValues(0, 99),
    this.staminaRange = const RangeValues(0, 99),
    this.strengthRange = const RangeValues(0, 99),
    this.aggressionRange = const RangeValues(0, 99),
    this.gkDivingRange = const RangeValues(0, 99),
    this.gkHandlingRange = const RangeValues(0, 99),
    this.gkKickingRange = const RangeValues(0, 99),
    this.gkReflexesRange = const RangeValues(0, 99),
    this.gkSpeedRange = const RangeValues(0, 99),
    this.gkPositioningRange = const RangeValues(0, 99),
  });

  SearchFilters copyWith({
    RangeValues? overallRange,
    RangeValues? potentialRange,
    RangeValues? ageRange,
    List<String>? selectedPositions,
    String? preferredFoot,
    bool clearPreferredFoot = false,
    List<String>? selectedLeagues,
    List<String>? selectedNationalities,
    List<String>? selectedClubs,
    List<String>? selectedPlayStyles,
    RangeValues? heightRange,
    RangeValues? weightRange,
    RangeValues? skillMovesRange,
    RangeValues? weakFootRange,
    RangeValues? internationalReputationRange,
    RangeValues? paceRange,
    RangeValues? shootingRange,
    RangeValues? passingRange,
    RangeValues? dribblingRange,
    RangeValues? defendingRange,
    RangeValues? physicalRange,
    RangeValues? accelerationRange,
    RangeValues? sprintSpeedRange,
    RangeValues? positioningRange,
    RangeValues? finishingRange,
    RangeValues? shotPowerRange,
    RangeValues? longShotsRange,
    RangeValues? volleysRange,
    RangeValues? penaltiesRange,
    RangeValues? visionRange,
    RangeValues? crossingRange,
    RangeValues? fkAccuracyRange,
    RangeValues? shortPassingRange,
    RangeValues? longPassingRange,
    RangeValues? curveRange,
    RangeValues? agilityRange,
    RangeValues? balanceRange,
    RangeValues? reactionsRange,
    RangeValues? ballControlRange,
    RangeValues? dribblingSkillRange,
    RangeValues? composureRange,
    RangeValues? interceptionsRange,
    RangeValues? headingAccuracyRange,
    RangeValues? markingRange,
    RangeValues? standingTackleRange,
    RangeValues? slidingTackleRange,
    RangeValues? jumpingRange,
    RangeValues? staminaRange,
    RangeValues? strengthRange,
    RangeValues? aggressionRange,
    RangeValues? gkDivingRange,
    RangeValues? gkHandlingRange,
    RangeValues? gkKickingRange,
    RangeValues? gkReflexesRange,
    RangeValues? gkSpeedRange,
    RangeValues? gkPositioningRange,
  }) {
    return SearchFilters(
      overallRange: overallRange ?? this.overallRange,
      potentialRange: potentialRange ?? this.potentialRange,
      ageRange: ageRange ?? this.ageRange,
      selectedPositions: selectedPositions ?? this.selectedPositions,
      preferredFoot:
          clearPreferredFoot ? null : (preferredFoot ?? this.preferredFoot),
      selectedLeagues: selectedLeagues ?? this.selectedLeagues,
      selectedNationalities:
          selectedNationalities ?? this.selectedNationalities,
      selectedClubs: selectedClubs ?? this.selectedClubs,
      selectedPlayStyles: selectedPlayStyles ?? this.selectedPlayStyles,
      heightRange: heightRange ?? this.heightRange,
      weightRange: weightRange ?? this.weightRange,
      skillMovesRange: skillMovesRange ?? this.skillMovesRange,
      weakFootRange: weakFootRange ?? this.weakFootRange,
      internationalReputationRange:
          internationalReputationRange ?? this.internationalReputationRange,
      paceRange: paceRange ?? this.paceRange,
      shootingRange: shootingRange ?? this.shootingRange,
      passingRange: passingRange ?? this.passingRange,
      dribblingRange: dribblingRange ?? this.dribblingRange,
      defendingRange: defendingRange ?? this.defendingRange,
      physicalRange: physicalRange ?? this.physicalRange,
      accelerationRange: accelerationRange ?? this.accelerationRange,
      sprintSpeedRange: sprintSpeedRange ?? this.sprintSpeedRange,
      positioningRange: positioningRange ?? this.positioningRange,
      finishingRange: finishingRange ?? this.finishingRange,
      shotPowerRange: shotPowerRange ?? this.shotPowerRange,
      longShotsRange: longShotsRange ?? this.longShotsRange,
      volleysRange: volleysRange ?? this.volleysRange,
      penaltiesRange: penaltiesRange ?? this.penaltiesRange,
      visionRange: visionRange ?? this.visionRange,
      crossingRange: crossingRange ?? this.crossingRange,
      fkAccuracyRange: fkAccuracyRange ?? this.fkAccuracyRange,
      shortPassingRange: shortPassingRange ?? this.shortPassingRange,
      longPassingRange: longPassingRange ?? this.longPassingRange,
      curveRange: curveRange ?? this.curveRange,
      agilityRange: agilityRange ?? this.agilityRange,
      balanceRange: balanceRange ?? this.balanceRange,
      reactionsRange: reactionsRange ?? this.reactionsRange,
      ballControlRange: ballControlRange ?? this.ballControlRange,
      dribblingSkillRange: dribblingSkillRange ?? this.dribblingSkillRange,
      composureRange: composureRange ?? this.composureRange,
      interceptionsRange: interceptionsRange ?? this.interceptionsRange,
      headingAccuracyRange: headingAccuracyRange ?? this.headingAccuracyRange,
      markingRange: markingRange ?? this.markingRange,
      standingTackleRange: standingTackleRange ?? this.standingTackleRange,
      slidingTackleRange: slidingTackleRange ?? this.slidingTackleRange,
      jumpingRange: jumpingRange ?? this.jumpingRange,
      staminaRange: staminaRange ?? this.staminaRange,
      strengthRange: strengthRange ?? this.strengthRange,
      aggressionRange: aggressionRange ?? this.aggressionRange,
      gkDivingRange: gkDivingRange ?? this.gkDivingRange,
      gkHandlingRange: gkHandlingRange ?? this.gkHandlingRange,
      gkKickingRange: gkKickingRange ?? this.gkKickingRange,
      gkReflexesRange: gkReflexesRange ?? this.gkReflexesRange,
      gkSpeedRange: gkSpeedRange ?? this.gkSpeedRange,
      gkPositioningRange: gkPositioningRange ?? this.gkPositioningRange,
    );
  }

  void reset() {}
}

class SearchFiltersNotifier extends StateNotifier<SearchFilters> {
  SearchFiltersNotifier() : super(SearchFilters());

  void setOverallRange(RangeValues values) =>
      state = state.copyWith(overallRange: values);
  void setPotentialRange(RangeValues values) =>
      state = state.copyWith(potentialRange: values);
  void setAgeRange(RangeValues values) =>
      state = state.copyWith(ageRange: values);

  void togglePosition(String pos) {
    final list = List<String>.from(state.selectedPositions);
    if (list.contains(pos)) {
      list.remove(pos);
    } else {
      list.add(pos);
    }
    state = state.copyWith(selectedPositions: list);
  }

  void setPreferredFoot(String? foot) {
    if (foot == null) {
      state = state.copyWith(clearPreferredFoot: true);
    } else {
      state = state.copyWith(preferredFoot: foot);
    }
  }

  void setLeagues(List<String> leagues) =>
      state = state.copyWith(selectedLeagues: leagues);
  void setNationalities(List<String> nationalities) =>
      state = state.copyWith(selectedNationalities: nationalities);
  void setClubs(List<String> clubs) =>
      state = state.copyWith(selectedClubs: clubs);
  void setPlayStyles(List<String> playStyles) =>
      state = state.copyWith(selectedPlayStyles: playStyles);

  void setHeightRange(RangeValues values) =>
      state = state.copyWith(heightRange: values);
  void setWeightRange(RangeValues values) =>
      state = state.copyWith(weightRange: values);
  void setSkillMovesRange(RangeValues values) =>
      state = state.copyWith(skillMovesRange: values);
  void setWeakFootRange(RangeValues values) =>
      state = state.copyWith(weakFootRange: values);
  void setInternationalReputationRange(RangeValues values) =>
      state = state.copyWith(internationalReputationRange: values);

  void setPaceRange(RangeValues values) =>
      state = state.copyWith(paceRange: values);
  void setShootingRange(RangeValues values) =>
      state = state.copyWith(shootingRange: values);
  void setPassingRange(RangeValues values) =>
      state = state.copyWith(passingRange: values);
  void setDribblingRange(RangeValues values) =>
      state = state.copyWith(dribblingRange: values);
  void setDefendingRange(RangeValues values) =>
      state = state.copyWith(defendingRange: values);
  void setPhysicalRange(RangeValues values) =>
      state = state.copyWith(physicalRange: values);

  void setAccelerationRange(RangeValues values) =>
      state = state.copyWith(accelerationRange: values);
  void setSprintSpeedRange(RangeValues values) =>
      state = state.copyWith(sprintSpeedRange: values);
  void setPositioningRange(RangeValues values) =>
      state = state.copyWith(positioningRange: values);
  void setFinishingRange(RangeValues values) =>
      state = state.copyWith(finishingRange: values);
  void setShotPowerRange(RangeValues values) =>
      state = state.copyWith(shotPowerRange: values);
  void setLongShotsRange(RangeValues values) =>
      state = state.copyWith(longShotsRange: values);
  void setVolleysRange(RangeValues values) =>
      state = state.copyWith(volleysRange: values);
  void setPenaltiesRange(RangeValues values) =>
      state = state.copyWith(penaltiesRange: values);
  void setVisionRange(RangeValues values) =>
      state = state.copyWith(visionRange: values);
  void setCrossingRange(RangeValues values) =>
      state = state.copyWith(crossingRange: values);
  void setFkAccuracyRange(RangeValues values) =>
      state = state.copyWith(fkAccuracyRange: values);
  void setShortPassingRange(RangeValues values) =>
      state = state.copyWith(shortPassingRange: values);
  void setLongPassingRange(RangeValues values) =>
      state = state.copyWith(longPassingRange: values);
  void setCurveRange(RangeValues values) =>
      state = state.copyWith(curveRange: values);
  void setAgilityRange(RangeValues values) =>
      state = state.copyWith(agilityRange: values);
  void setBalanceRange(RangeValues values) =>
      state = state.copyWith(balanceRange: values);
  void setReactionsRange(RangeValues values) =>
      state = state.copyWith(reactionsRange: values);
  void setBallControlRange(RangeValues values) =>
      state = state.copyWith(ballControlRange: values);
  void setDribblingSkillRange(RangeValues values) =>
      state = state.copyWith(dribblingSkillRange: values);
  void setComposureRange(RangeValues values) =>
      state = state.copyWith(composureRange: values);
  void setInterceptionsRange(RangeValues values) =>
      state = state.copyWith(interceptionsRange: values);
  void setHeadingAccuracyRange(RangeValues values) =>
      state = state.copyWith(headingAccuracyRange: values);
  void setMarkingRange(RangeValues values) =>
      state = state.copyWith(markingRange: values);
  void setStandingTackleRange(RangeValues values) =>
      state = state.copyWith(standingTackleRange: values);
  void setSlidingTackleRange(RangeValues values) =>
      state = state.copyWith(slidingTackleRange: values);
  void setJumpingRange(RangeValues values) =>
      state = state.copyWith(jumpingRange: values);
  void setStaminaRange(RangeValues values) =>
      state = state.copyWith(staminaRange: values);
  void setStrengthRange(RangeValues values) =>
      state = state.copyWith(strengthRange: values);
  void setAggressionRange(RangeValues values) =>
      state = state.copyWith(aggressionRange: values);
  void setGkDivingRange(RangeValues values) =>
      state = state.copyWith(gkDivingRange: values);
  void setGkHandlingRange(RangeValues values) =>
      state = state.copyWith(gkHandlingRange: values);
  void setGkKickingRange(RangeValues values) =>
      state = state.copyWith(gkKickingRange: values);
  void setGkReflexesRange(RangeValues values) =>
      state = state.copyWith(gkReflexesRange: values);
  void setGkSpeedRange(RangeValues values) =>
      state = state.copyWith(gkSpeedRange: values);
  void setGkPositioningRange(RangeValues values) =>
      state = state.copyWith(gkPositioningRange: values);

  void reset() => state = SearchFilters();
}

final searchFiltersProvider =
    StateNotifierProvider<SearchFiltersNotifier, SearchFilters>((ref) {
  return SearchFiltersNotifier();
});
