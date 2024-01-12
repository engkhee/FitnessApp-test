import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fitnessapp/utils/app_colors.dart';

class ViewDatabase extends StatefulWidget {
  static const String routeName = "/ViewDatabase";

  @override
  _ViewDatabaseState createState() => _ViewDatabaseState();
}

class Database {
  final String image;
  final String link;

  Database(this.image, this.link);
}

class _ViewDatabaseState extends State<ViewDatabase> {
  int selectId = 0;
  int activePage = 0;
  final PageController controller = PageController(viewportFraction: 0.8);

  final List<Database> database = [ // link will prompt on the RUM terminal as well redirect to the google chrome in the device (need log in account)
    Database(
        'assets/images/country_data.png',
        'https://console.firebase.google.com/u/0/project/cat304-30c1e/analytics/app/android:com.hypeteq.fitnessapp/overview/reports~2Fexplorer%3Fparams%3D_r.explorerCard..selmet%253D%255B%2522activeUsers%2522%255D%2526_r.explorerCard..seldim%253D%255B%2522country%2522%255D&r%3Duser-demographics-detail&fpn%3D969629870665'),
    Database(
        'assets/images/event_data.png',
        'https://console.firebase.google.com/u/0/project/cat304-30c1e/analytics/app/android:com.hypeteq.fitnessapp/overview/reports~2Fexplorer%3Fparams%3D_u.date00%253D20231129%2526_u.date01%253D20240109%2526_r.explorerCard..selmet%253D%255B%2522eventCount%2522%255D%2526_r.explorerCard..seldim%253D%255B%2522eventName%2522%255D&r%3Dtop-events&fpn%3D969629870665'),
    Database(
        'assets/images/tech_data.png',
        'https://console.firebase.google.com/u/0/project/cat304-30c1e/analytics/app/android:com.hypeteq.fitnessapp/overview/reports~2Fexplorer%3Fparams%3D_r.explorerCard..selmet%253D%255B%2522activeUsers%2522%252C%2522activeUsers%2522%255D%2526_r.explorerCard..seldim%253D%255B%2522deviceCategory%2522%255D%2526_r.explorerCard..sortKey%253DactiveUsers%2526_r.explorerCard..isAscending%253Dfalse&r%3Duser-technology-detail&fpn%3D969629870665'),
    Database(
        'assets/images/retention_data.png',
        'https://console.firebase.google.com/u/0/project/cat304-30c1e/analytics/app/android:com.hypeteq.fitnessapp/overview/reports~2Fdashboard%3Fparams%3D_u.date00%253D20231129%2526_u.date01%253D20240109%2526_r.0..activeTab%253D0&r%3Dlifecycle-retention-overview&fpn%3D969629870665'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.verifyNut1,
      appBar: AppBar(
        title: Text('Database Center'),
        backgroundColor: AppColors.verifyNut2,
        leadingWidth: 40,
        leading: TextButton(
          onPressed: () {Navigator.pop(context);},
          child: Image.asset(
            'assets/icons/back_icon.png',
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.40,
            margin: EdgeInsets.all(0.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.grayColor.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 0),
                ),
              ],
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: GestureDetector(
              onTap: () async {
                String url = // will redirect to the google chrome to open firebase
                    'https://console.firebase.google.com/u/0/project/cat304-30c1e/analytics/app/android:com.hypeteq.fitnessapp/overview/reports~2Fdashboard%3Fparams%3D_u.date00%253D20231129%2526_u.date01%253D20240109%2526_r.explorerCard..selmet%253D%255B%2522eventCount%2522%255D%2526_r.explorerCard..seldim%253D%255B%2522eventName%2522%255D&r%3Dfirebase-overview&fpn%3D969629870665';
                print('Overall database! Link: $url');

                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  print('Could not launch $url');
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  bottomLeft: Radius.circular(70),
                  bottomRight: Radius.circular(70),
                  topRight: Radius.circular(0),
                ),
                child: Image.asset(
                  'assets/images/overall_data.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: PageView.builder(
                itemCount: database.length,
                controller: controller,
                physics: const BouncingScrollPhysics(),
                padEnds: false,
                pageSnapping: true,
                onPageChanged: (value) => setState(() => activePage = value),
                itemBuilder: (context, index) {
                  bool active = index == activePage;
                  return DatabaseButton(active, index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget DatabaseButton(bool active, int index) {
    return GestureDetector(
      onTap: () async {
        print('Database Button Tapped! Link: ${database[index].link}');
        await launch(database[index].link); // redirect to google chrome to open firebase
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: active ? Colors.green : Colors.black.withOpacity(0.7),
            width: active ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(15.0)),
                  child: Image.asset(
                    database[index].image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Database ${index + 1}',
                style: TextStyle(
                  color: active ? Colors.green : Colors.black.withOpacity(0.7),
                  fontSize: 16.0,
                ),
              ),
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}