import 'package:fc_stats_24/utlis/CustomColors.dart';
import 'package:flutter/material.dart';

class ClubDetails extends StatelessWidget {
  final clubData;
  const ClubDetails({Key? key, this.clubData}) : super(key: key);

  String convertWage(var val) {
    if (val == 0) {
      return "-";
    }
    var w = val.toString().length;
    if (w >= 4 && w <= 7) {
      String v = '\u{20AC}' + val.toString().substring(0, w - 3);
      v += "K";
      return v;
    }
    if (w > 7) {
      String v = '\u{20AC}' + val.toString().substring(0, w - 6);
      v += "M";
      return v;
    }
    return val.toString();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double remWidth = width - 24;
    return Container(
      margin: EdgeInsets.all(11),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 11),
      decoration: BoxDecoration(border: Border.all(color: posColor)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: posColor),
            child: Text('CLUB DETAILS',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black)),
          ),
          clubData['club_logo_url'].length > 0
              ? Center(
                  child: Container(
                    width: 0.15 * width,
                    height: 0.15 * width,
                    child: Image.network(
                      clubData['club_logo_url'],
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          // Image loaded successfully
                          return child;
                        } else if (loadingProgress.cumulativeBytesLoaded ==
                            loadingProgress.expectedTotalBytes) {
                          // Image failed to load
                          return Image.asset('assets/images/icon.png',
                              fit: BoxFit.fitWidth);
                        } else {
                          // Image still loading
                          return Image.asset('assets/images/icon.png',
                              fit: BoxFit.fitWidth);
                        }
                      },
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        // Handle image loading error
                        return Image.asset('assets/images/icon.png',
                            fit: BoxFit.fitWidth);
                      },
                    ),
                  ),
                )
              : Container(),
          Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Text(
                clubData['club_name'].length > 0
                    ? clubData['club_name']
                    : "Free Agent",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                clubData['league_name'],
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Joined: ',
                style: TextStyle(fontSize: 15),
              ),
              Text(
                clubData['club_joined'],
                style: TextStyle(fontSize: 15),
              ),
              Text(
                ' - ',
                style: TextStyle(fontSize: 15),
              ),
              Text(
                'Contract Until: ',
                style: TextStyle(fontSize: 15),
              ),
              Text(
                clubData['club_contract_valid_until'].toString(),
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
          Container(
            height: 7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    'Wage',
                    style: TextStyle(fontSize: 15),
                  ),
                  Container(
                    height: 1,
                  ),
                  Text(
                    convertWage(clubData['wage_eur']),
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
              Container(
                width: 15,
              ),
              Column(
                children: [
                  Text(
                    'Value',
                    style: TextStyle(fontSize: 15),
                  ),
                  Container(
                    height: 1,
                  ),
                  Text(
                    convertWage(clubData['value_eur']),
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
              Container(
                width: 15,
              ),
              Column(
                children: [
                  Text(
                    'Clause',
                    style: TextStyle(fontSize: 15),
                  ),
                  Container(
                    height: 1,
                  ),
                  Text(
                    convertWage(clubData['release_clause_eur']),
                    style: TextStyle(fontSize: 15),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
