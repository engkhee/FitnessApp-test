import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;

  const Comment({
    super.key,
    required this.text,
    required this.user,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:  CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // comment
          Text(text),

          const SizedBox(height: 5,),

          // user, time
          Row(
            children: [
              const Icon(
                Icons.comment_bank_outlined,
                color: Colors.grey,
                size: 15,
              ),

              const SizedBox(width: 5,),

              Text(
                user,
                style: TextStyle(color: Colors.grey[500], fontSize: 11.5),
              ),

              Text(
                " • ",
                style: TextStyle(color: Colors.grey[400], fontSize: 11.5),
              ),

              Text(
                time,
                style: TextStyle(color: Colors.grey[400], fontSize: 11.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
