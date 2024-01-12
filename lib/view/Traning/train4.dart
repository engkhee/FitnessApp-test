import 'dart:convert';
import 'package:fitnessapp/view/Traning/fitnesss_list.dart';
import 'package:fitnessapp/view/Traning/videoInfo4.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/utils/app_colors.dart';


class train4 extends StatefulWidget {
  static String routeName = "/train4";

  train4({Key? key}) : super(key: key);

  @override
  _train4State createState() => _train4State();
}

class _train4State extends State<train4> {
  List info = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    DefaultAssetBundle.of(context).loadString("json/info4.json").then((value) {
      setState(() {
        info = jsonDecode(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Training",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(child: Container()),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FitnessList()));
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.black,
                  ),
                ),

              ],
            ),
            SizedBox(height: 30,),
            Row(
              children: [
                Text(
                  "P0004",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(child: Container()),
                Text(
                  "Details",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 5,),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VideoInfo4()));
                  },
                  child: Icon(Icons.arrow_forward,
                    size: 20,
                    color: Colors.black,),
                ),
              ],
            ),
            SizedBox(height: 30,),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: 220,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xffffc107).withOpacity(0.5),
                      Color(0xffffecb3).withOpacity(0.6),
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(80),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(5, 10),
                      blurRadius: 5,
                      color: AppColors.lightGrayColor,
                    )
                  ]
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 20, top: 15, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Workout:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      "Arms and",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Shoulder Workout",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 25,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.timer, size: 20, color: Colors.black,),
                            SizedBox(width: 5,),
                            Text(
                              "20 min",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white,
                                    blurRadius: 10,
                                    offset: Offset(4, 8),
                                  )
                                ]
                            ),
                            child: Icon(
                              Icons.play_circle_fill,
                              color: Colors.yellow.withOpacity(0.8),
                              size: 60,
                            )
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 5,),
            Container(
              height: 150,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    margin: const EdgeInsets.only(top: 20),
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/images/card.png"
                          ),
                          fit: BoxFit.fill,
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(8, 10),
                            color: Colors.black12,
                          ),
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(-1, -5),
                            color: Colors.black12,
                          )
                        ]
                    ),
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 100,
                    margin: const EdgeInsets.only(left: 80, top: 35, right: 15),
                    child: Column(
                      children: [
                        Text("Keep moving!",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),),
                        SizedBox(height: 10,),
                        RichText(text: TextSpan(
                            text: "You are doing great!",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            )
                        ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text("Area of focus", textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),)
              ],
            ),
            Expanded(child: OverflowBox(
              child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: ListView.builder(
                    itemCount: info.length,
                    itemBuilder: (_, i) {
                      return Row(
                        children: [
                          Container(
                            height: 100,
                            width: 150,
                            margin: EdgeInsets.only(bottom: 25, top: 25),
                            padding: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    image: AssetImage(
                                        info[i]['img']
                                    )
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4,
                                    offset: Offset(1, 5),
                                    color: Color(0xFFBBDEFB).withOpacity(0.1),
                                  ),
                                  BoxShadow(
                                    blurRadius: 4,
                                    offset: Offset(-1, -5),
                                    color: Color(0xFFBBDEFB).withOpacity(0.3),
                                  )
                                ]
                            ),
                          ),
                          SizedBox(width: 25,),
                          Text(
                            info[i]["title"],
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      );
                    }
                ),
              ),
            )
            )
          ],
        ),
      ),

    );
  }}