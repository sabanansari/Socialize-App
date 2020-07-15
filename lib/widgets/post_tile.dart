import 'package:flutter/material.dart';
import 'post.dart';
import 'custom_image.dart';

class PostTile extends StatefulWidget {
  final Post post;

  PostTile({this.post});

  @override
  _PostTileState createState() => _PostTileState(post: this.post);
}

class _PostTileState extends State<PostTile> {
  final Post post;
  _PostTileState({this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('showing post'),
      child: cachedNetworkImage(post.mediaUrl),
    );
  }
}
