import 'package:fc_stats_24/ads/BannerAdSmall.dart';
import 'package:fc_stats_24/db/configureDB.dart';
import 'package:fc_stats_24/screens/BottomTabs.dart';
import 'package:fc_stats_24/utlis/CustomColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SetUpLocalDb extends StatefulWidget {
  const SetUpLocalDb({super.key});

  @override
  _SetUpLocalDbState createState() => _SetUpLocalDbState();
}

class _SetUpLocalDbState extends State<SetUpLocalDb> {
  bool loading = true;
  double completed = 0;
  static const storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    checkSetUp();
  }

  void checkSetUp() async {
    try {
      // Add timeout to prevent hanging if secure storage is messed up
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
          // Start the smart database setup
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
      print('[SetUpLocalDb] Starting smart database setup...');
      
      // Use the new smart setup function that handles everything
      await setupDatabaseIfNeeded((progress) {
        changeCompleted(progress);
      });
      
      // Setup completed successfully
      print('[SetUpLocalDb] Database setup completed successfully!');
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
    } catch (e, stackTrace) {
      print('[SetUpLocalDb] ERROR in startSmartSetup: $e');
      print('[SetUpLocalDb] Stack trace: $stackTrace');
      
      // Show error to user
      if (mounted) {
        setState(() {
          loading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Database setup failed: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void changeCompleted(int currentRow) async {
    if (mounted) {
      final totalRows = 18349;
      final progress = currentRow / totalRows;
      
      print('[SetUpLocalDb] Progress update: row $currentRow/$totalRows (${(progress * 100).toStringAsFixed(2)}%)');
      
      setState(() {
        completed = progress;
      });
    } else {
      print('[SetUpLocalDb] Widget not mounted, skipping progress update');
    }
  }

  String percent() {
    double p = completed * 100;
    int k = p.round();
    // Show at least 1% if there's any progress
    if (completed > 0 && k == 0) return '1';
    return k.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/image.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: !loading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Player Stats 24',
                                  style: TextStyle(
                                    color: posColor,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  height: 5,
                                ),
                                const Text(
                                  'Storing Over 20000 Players',
                                  style: TextStyle(
                                    color: posColor,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            )),
                        Container(
                            margin: const EdgeInsets.all(15),
                            child: LinearProgressIndicator(
                              value: completed,
                              minHeight: 12.5,
                              color: posColor,
                            )),
                        completed < 1
                            ? const Text(
                                'Setting Up Players Database',
                                style: TextStyle(fontSize: 16),
                              )
                            : const Text(
                                'Database Setup Completed',
                                style: TextStyle(fontSize: 16),
                              ),
                        Container(
                          height: 9,
                        ),
                        Text('${percent()} % Completed',
                            style: const TextStyle(fontSize: 16)),
                        Container(
                          height: 25,
                        ),
                        const Text(
                          'App will Work Offline as well',
                          style: TextStyle(
                            color: posColor,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    )),
                    BannerSmallAd(),
                  ],
                )
              : Center(
                  child: SizedBox(
                    width: 45,
                    height: 45,
                    child: const CircularProgressIndicator(
                      color: posColor,
                    ),
                  ),
                )),
    );
  }
}