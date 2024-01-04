import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/view/forum/comment.dart';
import 'package:fitnessapp/view/forum/comment_button.dart';
import 'package:fitnessapp/view/forum/like_button.dart';
import 'package:flutter/material.dart';

import 'helper/helper_method.dart';

class Post extends StatefulWidget{
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;

  const Post({
    super.key,
    required this.message,
    required this.user,
    required this.time,
    required this.postId,
    required this.likes,
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {

  // user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  // comment text controller
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  // toggle like
  void toggleLike(){
    setState(() {
      isLiked = !isLiked;
    });

    // Access the document is Firebase
    DocumentReference postRef = FirebaseFirestore.instance.collection("UserPosts").doc(widget.postId);

    if(isLiked){
      // if the post is now liked, add the user's email to the Likes field
      postRef.update({
        "Likes": FieldValue.arrayUnion([currentUser.email])
      });
    }else{
      // if the post is now unliked, remove the user's email from the Likes field
      postRef.update({
        "Likes": FieldValue.arrayRemove([currentUser.email])
      });
    }
  }
  
  // add a comment
  void addComment(String commentText){
    // write the comment to firestore under the collection for this post
    FirebaseFirestore.instance
        .collection("UserPosts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
          "CommentText": commentText,
          "CommentBy": currentUser.email,
          "CommentTime": Timestamp.now()  //  format this when displaying
    });
  }
  
  // show aialog for adding comment
  void showCommentDialog(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Add Comment"),
          content: TextField(
            controller: _commentTextController,
            decoration: InputDecoration(hintText: "Write a comment..."),
          ),

          actions: [
            // cancel button
            TextButton(
              onPressed: () => {
                // pop the box
                Navigator.pop(context),

                // clear controller
                _commentTextController.clear(),
              },
              child: Text("Cancel"),
            ),

            // post button
            TextButton(
                onPressed: () => {
                  // add comment
                  addComment(_commentTextController.text),

                  // pop box
                  Navigator.pop(context),

                  // clear controler
                  _commentTextController.clear(),
                },
                child: Text("Post"),
            ),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // profile pic

          //message and user email
          Row(
            children: [
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[400]),
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                // Forum Posts
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // user
                  Row(
                    children: [
                      Text(
                        widget.user,
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),

                      Text(
                        " • ",
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),

                      Text(
                        widget.time,
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),

                ],
              ),
            ],
          ),

          const SizedBox(height: 10,),
          // message
          Container(
            margin: EdgeInsets.only(top: 8, left: 8),
            child: Row(
              children: [
                Text(
                  widget.message,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),

          const SizedBox(height: 5,),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // LIKE
              Column(
                children: [
                  // like button
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),

                  const SizedBox(height: 5),

                  // like count
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(width: 10,),

              // Comment
              Column(
                children: [
                  // comment button
                  CommentButton(
                    onTap: showCommentDialog,
                  ),

                  const SizedBox(height: 5),

                  // comment count
                  Text(
                    '0',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),
          
          // comment under the post
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("UserPosts")
                  .doc(widget.postId)
                  .collection("Comments")
                  .orderBy("CommentTime", descending:true).snapshots(),
              builder: (context, snapshot){
                // show loading circle if no data yet
                if(!snapshot.hasData){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  shrinkWrap: true,  // for nested lists
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc) {
                    // get the comment
                    final commentData = doc.data() as Map<String, dynamic>;

                    // return the comment
                    return Comment(
                      text: commentData["CommentText"],
                      user: commentData["CommentBy"],
                      time: formatDate(commentData["CommentTime"]),
                    );
                  }).toList(),
                );
              },
          )
        ],
      ),
    );
  }
}