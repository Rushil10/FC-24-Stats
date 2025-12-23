import 'dart:async';
import 'package:fc_stats_24/components/SearchFilterComp.dart';
import 'package:fc_stats_24/components/playerCard.dart';
import 'package:fc_stats_24/db/players22.dart';
import 'package:fc_stats_24/screens/SearchResultsScreen.dart';
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

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounce;
  
  // Filter States
  RangeValues _overallRange = const RangeValues(0, 99);
  RangeValues _potentialRange = const RangeValues(0, 99);
  RangeValues _ageRange = const RangeValues(15, 45);
  
  List<String> _selectedPositions = [];
  String? _selectedFoot; 
  String? _selectedLeague;
  String? _selectedNationality;
  String? _selectedClub;
  // Play Styles and Roles (simple text search or selection)
  String? _selectedPlayStyles; // Comma separated if multiple? Or just single for now for simplicity
  String? _selectedRoles;      // "Work Rate" or similar

  // Overlay Results
  List<Map> _overlayResults = [];
  bool _isLoadingOverlay = false;
  bool _showOverlay = false;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    if (query.isEmpty) {
      setState(() {
        _showOverlay = false;
        _overlayResults = [];
      });
      return;
    }

    setState(() {
      _showOverlay = true;
      _isLoadingOverlay = true;
    });

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final results = await PlayersDatabase.instance.filterPlayers(
        query: query,
      );
      
      if (mounted) {
        setState(() {
          _overlayResults = results;
          _isLoadingOverlay = false;
          // If query was cleared while fetching
          if (_searchController.text.isEmpty) {
             _showOverlay = false;
          }
        });
      }
    });
  }
  
  void _navigateToResults() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
          query: _searchController.text,
          minOverall: _overallRange.start,
          maxOverall: _overallRange.end,
          minPotential: _potentialRange.start,
          maxPotential: _potentialRange.end,
          minAge: _ageRange.start,
          maxAge: _ageRange.end,
          selectedPositions: _selectedPositions,
          preferredFoot: _selectedFoot,
          league: _selectedLeague,
          nationality: _selectedNationality,
          club: _selectedClub,
          playStyles: _selectedPlayStyles,
          roles: _selectedRoles,
        ),
      ),
    );
  }

  // --- Generic Filter API Selectors ---

  void _openGenericSelector(String title, Future<List<String>> fetcher, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E2228),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return FutureBuilder<List<String>>(
              future: fetcher,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: posColor));
                }
                var items = snapshot.data!;
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text("Select $title", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(items[index], style: const TextStyle(color: Colors.white)),
                              onTap: () {
                                onSelect(items[index]);
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // Simple text input selector for PlayStyles/Roles if no list available
  void _openTextSelector(String title, String? currentValue, Function(String) onSave) {
     TextEditingController c = TextEditingController(text: currentValue);
     showDialog(context: context, builder: (context) {
       return AlertDialog(
         backgroundColor: const Color(0xFF1E2228),
         title: Text("Enter $title", style: const TextStyle(color: Colors.white)),
         content: TextField(
           controller: c,
           style: const TextStyle(color: Colors.white),
           decoration: const InputDecoration(hintText: "e.g. Finesse Shot", hintStyle: TextStyle(color: Colors.grey)),
         ),
         actions: [
           TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
           TextButton(onPressed: () {
             onSave(c.text);
             Navigator.pop(context);
           }, child: const Text("Save", style: TextStyle(color: posColor))),
         ],
       );
     });
  }

  void _openPositionSelector() {
    final positions = ['GK', 'CB', 'LB', 'RB', 'CDM', 'CM', 'CAM', 'RM', 'LM', 'LW', 'RW', 'ST', 'CF'];
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E2228),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Select Positions", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1.5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: positions.length,
                      itemBuilder: (context, index) {
                        final pos = positions[index];
                        final isSelected = _selectedPositions.contains(pos);
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              if (isSelected) {
                                _selectedPositions.remove(pos);
                              } else {
                                _selectedPositions.add(pos);
                              }
                            });
                             setState(() {}); // Update main screen
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? posColor : Colors.grey[800],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              pos,
                              style: TextStyle(
                                color: isSelected ? Colors.black : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Keep state
    return Scaffold(
      backgroundColor: Colors.black, // Dark Theme
      resizeToAvoidBottomInset: false, // Prevent resizing when keyboard opens for overlay stability
      appBar: AppBar(
        title: const Text("Player Potentials", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_off),
            onPressed: () {
              setState(() {
                _searchController.clear();
                _showOverlay = false;
                _overallRange = const RangeValues(0, 99);
                _potentialRange = const RangeValues(0, 99);
                _ageRange = const RangeValues(15, 45);
                _selectedPositions = [];
                _selectedFoot = null;
                _selectedLeague = null;
                _selectedNationality = null;
                _selectedClub = null;
                _selectedPlayStyles = null;
                _selectedRoles = null;
              });
            },
          )
        ],
      ),
      body: Stack(
        children: [
          // Main Body with Filters
          Padding(
            padding: const EdgeInsets.only(top: 80), // Reserve space for search bar
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Range Sliders
                  RangeFilterSection(
                    title: "Overall",
                    values: _overallRange,
                    min: 0, max: 99,
                    onChanged: (v) => setState(() => _overallRange = v),
                  ),
                  RangeFilterSection(
                    title: "Potential",
                    values: _potentialRange,
                    min: 0, max: 99,
                    onChanged: (v) => setState(() => _potentialRange = v),
                  ),
                  RangeFilterSection(
                    title: "Age",
                    values: _ageRange,
                    min: 15, max: 45,
                    onChanged: (v) => setState(() => _ageRange = v),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Filter Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.5,
                    children: [
                      // Position
                      FilterGridButton(
                        label: "Position",
                        value: _selectedPositions.isEmpty ? "All" : "(${_selectedPositions.length}) Selected",
                        onTap: _openPositionSelector,
                      ),
                      // Foot
                      FilterGridButton(
                        label: "Foot",
                        value: _selectedFoot ?? "Any",
                        onTap: () {
                           setState(() {
                             if (_selectedFoot == null) _selectedFoot = "Left";
                             else if (_selectedFoot == "Left") _selectedFoot = "Right";
                             else _selectedFoot = null;
                           });
                        },
                      ),
                       // League
                      FilterGridButton(
                        label: "League",
                        value: _selectedLeague ?? "Any",
                        onTap: () => _openGenericSelector("League", PlayersDatabase.instance.getDistinctLeagues(), (val) {
                          setState(() => _selectedLeague = val);
                        }),
                      ),
                      // Nationality
                      FilterGridButton(
                        label: "Nationality",
                        value: _selectedNationality ?? "Any",
                        onTap: () => _openGenericSelector("Nationality", PlayersDatabase.instance.getDistinctNationalities(), (val) {
                          setState(() => _selectedNationality = val);
                        }),
                      ),
                      // Club
                       FilterGridButton(
                        label: "Club",
                        value: _selectedClub ?? "Any",
                        onTap: () => _openGenericSelector("Club", PlayersDatabase.instance.getDistinctClubs(), (val) {
                          setState(() => _selectedClub = val);
                        }),
                      ),
                      // Play Styles (Traits)
                      FilterGridButton(
                        label: "Play Styles",
                        value: _selectedPlayStyles ?? "Any",
                        onTap: () => _openTextSelector("Play Style (Trait)", _selectedPlayStyles, (val) {
                          setState(() => _selectedPlayStyles = val.isEmpty ? null : val);
                        }),
                      ),
                      // Roles (Work Rate)
                      FilterGridButton(
                        label: "Roles",
                        value: _selectedRoles ?? "Any",
                        onTap: () => _openTextSelector("Work Rate (e.g. High/High)", _selectedRoles, (val) {
                          setState(() => _selectedRoles = val.isEmpty ? null : val);
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
          
          // Fixed Search Bar at Top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: _onSearchChanged,
                onTap: () {
                   if (_searchController.text.isNotEmpty) {
                     setState(() => _showOverlay = true);
                   }
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "SEARCH",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  filled: true,
                  fillColor: const Color(0xFF1E2228),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          
          // Results Overlay (Conditionally shown below Search Bar)
          if (_showOverlay)
            Positioned(
              top: 80, // Height of Search Bar container
              left: 16, 
              right: 16,
              height: MediaQuery.of(context).size.height * 0.5, // Half height
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2228),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                     const BoxShadow(color: Colors.black54, blurRadius: 10, spreadRadius: 2)
                  ],
                  border: Border.all(color: Colors.grey[800]!),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey[800]!))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Quick Results (${_overlayResults.length})", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                          GestureDetector(
                            onTap: () => setState(() => _showOverlay = false),
                            child: const Icon(Icons.close, color: Colors.grey, size: 20),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _isLoadingOverlay
                        ? const Center(child: CircularProgressIndicator(color: posColor))
                        : _overlayResults.isEmpty 
                            ? const Center(child: Text("No players found", style: TextStyle(color: Colors.grey)))
                            : ListView.builder(
                                itemCount: _overlayResults.length,
                                itemBuilder: (context, index) {
                                  // Simplified result item
                                  final p = _overlayResults[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: Image.network(p['player_face_url'] ?? '', errorBuilder: (c,o,s) => const Icon(Icons.person, color: Colors.grey)),
                                    ),
                                    title: Text(p['short_name'] ?? 'Unknown', style: const TextStyle(color: Colors.white)),
                                    subtitle: Text("${p['overall']} | ${p['player_positions']}", style: const TextStyle(color: posColor)),
                                    onTap: () {
                                      // Can handle quick navigation to details if desired
                                      // But user said "search text also propagates", so maybe just typing?
                                      // Assuming selecting here navigates to details or fills search?
                                      // Let's just fill search and hide overlay for now, or open detials
                                      // User: "show the results in an overlay modal... and that search text also propogates into my final next page"
                                      // Implies this is just preview.
                                    },
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomSheet: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _navigateToResults,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff4af1f2), 
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("SEARCH", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
