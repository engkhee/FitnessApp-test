import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/view/forum/comment.dart';
import 'package:fitnessapp/view/forum/comment_button.dart';
import 'package:fitnessapp/view/forum/delete_button.dart';
import 'package:fitnessapp/view/forum/like_button.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../helper/helper_method.dart';


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
  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: Text(
          "Add Comment",
          style: TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 12),
              child: TextField(
                controller: _commentTextController,
                decoration: InputDecoration(
                  hintText: "Write a comment...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                maxLines: null,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              addComment(_commentTextController.text);
              Navigator.pop(context);
              _commentTextController.clear();
            },
            style: ElevatedButton.styleFrom(
              primary: AppColors.primaryColor1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Post",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showEditPostDialog() {
    TextEditingController _editPostController = TextEditingController(text: widget.message);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, // Change the background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corners for dialog
        ),
        title: Text(
          "Edit Post",
          style: TextStyle(
            color: Colors.black, // Title text color
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: TextField(
          controller: _editPostController,
          decoration: InputDecoration(
            hintText: "Edit your post...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            fillColor: Colors.white, // Light grey background color for the text field
            filled: true,
          ),
          maxLines: null, // Makes it expandable
          style: TextStyle(fontSize: 16), // Text size inside the TextField
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.red, // Cancel button text color
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              updatePost(_editPostController.text);
              Navigator.of(context).pop();
            },
            child: Text(
              "Update",
              style: TextStyle(
                color: Colors.black, // Update button text color
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: AppColors.lightblueColor , // Background color of the button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Method to update the post in Firestore
  void updatePost(String newMessage) {
    FirebaseFirestore.instance.collection("UserPosts").doc(widget.postId).update({
      "Message": newMessage,
    }).then((_) {
      print("Post updated successfully");
    }).catchError((error) {
      print("Error updating post: $error");
    });
  }

  // delete a post
  void deletePost(){
    // show a dialog box asking for confirmation before deleting the post
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Delete Post"),
          content: const Text("Are you sure you want to delete this post?"),
          actions: [
            // CANCEL BUTTON
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
            ),

            // DELETE BUTTON
            TextButton(
              onPressed: () async {
                // delete the comments from firestore first
                // (if delete the post, the comments will still be stored in fire base)
                final commentDocs = await FirebaseFirestore.instance
                    .collection("UserPosts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .get();

                for(var doc in commentDocs.docs){
                  await FirebaseFirestore.instance
                    .collection("UserPosts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .doc(doc.id)
                    .delete();
                }

                // Then delete the post
                FirebaseFirestore.instance
                    .collection("UserPosts")
                    .doc(widget.postId)
                    .delete()
                    .then((value) => print("post deleted"))
                    .catchError(
                        (error) => print("failed to delte post: $error")
                );

                //dissmiss the dialog
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightblueColor,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // profile pic

          //message and user email
          Row(
            children: [
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: AppColors.primaryG)),
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
                        style: TextStyle(color: Colors.black87, fontSize: 12),
                      ),

                      Text(
                        " • ",
                        style: TextStyle(color: Colors.black87, fontSize: 12),
                      ),

                      Text(
                        widget.time,
                        style: TextStyle(color: Colors.black87, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 10,),

              // delete button
              if(widget.user == currentUser.email || currentUser.email!.endsWith('fitness.com'))
                DeleteButton(onTap: deletePost),
            ],
          ),

          const SizedBox(height: 10,),
          // message
          Container(
            margin: EdgeInsets.only(top: 8, left: 8),
            child: Column(
              children: [
                Text(
                  widget.message,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),

          if (widget.user == currentUser.email) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // EDIT
                Column(
                  children: [
                    // Edit button
                    InkWell(
                      onTap: showEditPostDialog,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Adjust padding as needed
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor1 , // Box color
                          borderRadius: BorderRadius.circular(4), // Rounded corners
                        ),
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            color: Colors.white, // Text color
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                  ],
                ),
              ],
            ),
          ],

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

                  const SizedBox(height: 25),

                  // comment count
                  // Text(
                  //   '-',
                  //   style: TextStyle(color: Colors.grey),
                  // ),
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
                  .orderBy("CommentTime", descending:false).snapshots(),
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