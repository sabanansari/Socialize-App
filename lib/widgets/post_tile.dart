import 'package:flutter/material.dart';
import 'post.dart';
import 'custom_image.dart';

class PostTile extends StatelessWidget {
  final Post post;

  PostTile(this.post);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('showing post'),
      child: cachedNetworkImage(post.mediaUrl),
    );
  }
}
