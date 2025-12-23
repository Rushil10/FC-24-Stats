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
  final String? selectedRoles;

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
    this.selectedRoles,
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
    String? selectedRoles,
    bool clearSelectedRoles = false,
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
      selectedRoles:
          clearSelectedRoles ? null : (selectedRoles ?? this.selectedRoles),
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
  void setSelectedRoles(String? roles) {
    if (roles == null) {
      state = state.copyWith(clearSelectedRoles: true);
    } else {
      state = state.copyWith(selectedRoles: roles);
    }
  }

  void reset() => state = SearchFilters();
}

final searchFiltersProvider =
    StateNotifierProvider<SearchFiltersNotifier, SearchFilters>((ref) {
  return SearchFiltersNotifier();
});
