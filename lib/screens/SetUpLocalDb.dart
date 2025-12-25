import 'package:fc_stats_24/db/configureDB.dart';
import 'package:fc_stats_24/screens/BottomTabs.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SetUpLocalDb extends StatefulWidget {
  const SetUpLocalDb({super.key});

  @override
  State<SetUpLocalDb> createState() => _SetUpLocalDbState();
}

class _SetUpLocalDbState extends State<SetUpLocalDb>
    with SingleTickerProviderStateMixin {
  bool loading = true;
  double completed = 0;
  static const storage = FlutterSecureStorage();
  late AnimationController _animController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    checkSetUp();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void checkSetUp() async {
    try {
      var setUp = await storage.read(key: 'db').timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          return null;
        },
      );

      if (setUp == "done") {
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const BottomTabs()),
              (Route<dynamic> route) => false);
        }
      } else {
        if (mounted) {
          setState(() {
            loading = false;
          });
          startSmartSetup();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
        });
        startSmartSetup();
      }
    }
  }

  void startSmartSetup() async {
    try {
      await setupDatabaseIfNeeded((progress) {
        changeCompleted(progress);
      });

      await storage.write(key: 'db', value: 'done');

      if (mounted) {
        setState(() {
          loading = false;
          completed = 1.0;
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const BottomTabs()),
            (Route<dynamic> route) => false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Database setup failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void changeCompleted(int currentRow) async {
    if (mounted) {
      const totalRows = 18349;
      final progress = (currentRow / totalRows).clamp(0.0, 1.0);

      setState(() {
        completed = progress;
      });
    }
  }

  String percent() {
    double p = completed * 100;
    int k = p.round();
    if (completed > 0 && k == 0) return '1';
    return k.toString();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/image.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: !loading
              ? Container(
                  color: Colors.black.withValues(
                      alpha: 0.6), // Darken background for better contrast
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ScaleTransition(
                            scale: _pulseAnimation,
                            child: Icon(
                              Icons.sports_soccer_rounded,
                              size: 80,
                              color: appColors.posColor,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                              margin: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Player Stats 24',
                                    style: TextStyle(
                                      color: appColors.posColor,
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.5),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Optimizing Player Database',
                                    style: TextStyle(
                                      color: appColors.posColor
                                          .withValues(alpha: 0.8),
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              )),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: completed,
                                    minHeight: 12,
                                    color: appColors.posColor,
                                    backgroundColor:
                                        Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      completed < 1
                                          ? 'Setting Up Statistics...'
                                          : 'Ready to Play!',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.white70),
                                    ),
                                    Text(
                                      '${percent()}%',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: appColors.posColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 60),
                          Text(
                            'Works Offline',
                            style: TextStyle(
                              color: appColors.posColor.withValues(alpha: 0.6),
                              fontSize: 14,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 45,
                        height: 45,
                        child: CircularProgressIndicator(
                          color: appColors.posColor,
                          strokeWidth: 3,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Initializing...",
                        style: TextStyle(color: Colors.white70),
                      )
                    ],
                  ),
                )),
    );
  }
}
