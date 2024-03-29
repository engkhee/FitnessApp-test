import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/view/forum/fitness/fitness_post.dart';
import 'package:fitnessapp/common_widgets/round_textfield.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../helper/helper_method.dart';

class FitnessForumScreen extends StatefulWidget {
  const FitnessForumScreen({Key? key}) : super(key: key);

  @override
  State<FitnessForumScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<FitnessForumScreen> {

  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // text controller
  final textController = TextEditingController();

  // post message
  void postMessage(){
    // only post if there is something in the textfield
    if(textController.text.isNotEmpty){
      // store in firebase
      FirebaseFirestore.instance.collection("FitnessPosts").add({
        "UserEmail": currentUser.email,
        "Message": textController.text,
        "TimeStamp": Timestamp.now(),
        "Likes": [],
      });
    }

    // clear the textfield
    setState(() {
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      child:
        Scaffold(
          backgroundColor: Colors.white,

          body: Center(
            child: Column(
              children: [
                //post message
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      //text field
                      Expanded(
                          child: RoundTextField(
                            controller: textController,
                            hintText: "Write something...",
                            icon: "assets/icons/write.png",
                            textInputType: TextInputType.text,
                          )
                      ),
                      // post button
                      IconButton(
                        onPressed: postMessage,
                        icon: const Icon(Icons.arrow_circle_right_outlined),
                        color: Colors.black54,
                      )
                    ],
                  ),
                ),

                // log in as
                Text(
                  "Logged in as: " + currentUser.email!,
                  style: TextStyle(color: Colors.black54),
                ),

                // the wall
                Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                        .collection("FitnessPosts").orderBy(
                          "TimeStamp",
                          descending:false,
                      )
                      .snapshots(),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index){
                              // get the message
                              final post = snapshot.data!.docs[index];
                              return FitnessPost(
                                message: post['Message'],
                                user: post['UserEmail'],
                                time: formatDate(post["TimeStamp"]),
                                postId: post.id,
                                likes: List<String>.from(post['Likes'] ?? []),
                              );
                            },
                          );
                        }else if(snapshot.hasError){
                          return Center(
                            child: Text('Error${snapshot.error}'),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                ),



                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
    );
  }
}
