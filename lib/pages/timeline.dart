import 'package:flutter/material.dart';
import 'package:socialize_app/widgets/header.dart';
import 'package:socialize_app/widgets/post.dart';
import 'package:socialize_app/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialize_app/models/user.dart';
import 'home.dart';
import '';

class Timeline extends StatefulWidget {
  final User currentUser;

  Timeline({this.currentUser});

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<Post> posts;

  @override
  void initState() {
    getTimeline();
    super.initState();
  }

  getTimeline() async {
    QuerySnapshot snapshot = await timelineRef
        .document(widget.currentUser.id)
        .collection('timelinePosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();

    List<Post> posts =
        snapshot.documents.map((doc) => Post.fromDocument(doc)).toList();

    setState(() {
      this.posts = posts;
    });
  }

  buildTimeline() {
    if (posts == null) {
      return circularProgress();
    } else if (posts.isEmpty) {
      return Text('No Posts');
    } else {
      return ListView(
        children: posts,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => getTimeline(),
      child: buildTimeline(),
    );
  }
}
