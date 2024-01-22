import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TutorialVideosWidget extends StatelessWidget {
  final String searchQuery;

  const TutorialVideosWidget({Key? key, required this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('tutorial_videos').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          var videos = snapshot.data!.docs.where((doc) {
            var video = doc.data() as Map<String, dynamic>;
            return (video['title'].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
                video['description'].toString().toLowerCase().contains(searchQuery.toLowerCase()));
          }).toList();
          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              var video = videos[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(video['title']),
                subtitle: Text(video['description']),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
