import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialize_app/widgets/header.dart';
import 'package:socialize_app/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'home.dart';

class Comments extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  Comments({this.postId, this.postOwnerId, this.postMediaUrl, t});

  @override
  _CommentsState createState() => _CommentsState(
        postId: this.postId,
        postOwnerId: this.postOwnerId,
        postMediaUrl: this.postMediaUrl,
      );
}

class _CommentsState extends State<Comments> {
  TextEditingController commentController = TextEditingController();
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  _CommentsState({
    this.postId,
    this.postOwnerId,
    this.postMediaUrl,
  });

  Container buildComments() {
    return Container(
      child: StreamBuilder(
          stream: commentsRef
              .document(postId)
              .collection('comments')
              .orderBy('timestamp', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return circularProgress();
            } else {
              List<Comment> comments = [];
              snapshot.data.documents.forEach((doc) {
                comments.add(Comment.fromDocument(doc));
              });
              return ListView(
                children: comments,
              );
            }
          }),
    );
  }

  addComment() {
    commentsRef.document(postId).collection('comments').add({
      'username': currentUser.username,
      'comment': commentController.text,
      'timestamp': timeStamp,
      'avatarUrl': currentUser.photoUrl,
      'userId': currentUser.id,
    });
    bool isNotPostOwner = postOwnerId != currentUser.id;
    if (isNotPostOwner) {
      activityFeedRef.document(postOwnerId).collection('feedItems').add({
        'type': 'comment',
        'commentData': commentController.text,
        'username': currentUser.username,
        'userId': currentUser.id,
        'userProfileImg': currentUser.photoUrl,
        'postId': postId,
        'mediaUrl': postMediaUrl,
        'timestamp': timeStamp,
      });
    }
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: 'Comments'),
      body: Column(
        children: <Widget>[
          Expanded(
            child: buildComments(),
          ),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: 'Write a comment',
              ),
            ),
            trailing: OutlineButton(
              onPressed: addComment,
              borderSide: BorderSide.none,
              child: Text('Post'),
            ),
          )
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final Timestamp timestamp;

  Comment({
    this.username,
    this.userId,
    this.avatarUrl,
    this.comment,
    this.timestamp,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      username: doc['username'],
      userId: doc['userId'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
      avatarUrl: doc['avatarUrl'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(right: 5.0, left: 5.0, bottom: 2.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    username,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
              Text(comment),
            ],
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(avatarUrl),
          ),
          subtitle: Text(timeago.format(
            timestamp.toDate(),
          )),
        ),
        Divider(),
      ],
    );
  }
}
