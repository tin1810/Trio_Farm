import 'package:flutter/material.dart';
import 'package:trio_farm_app/data/model/post_model.dart';
import 'package:trio_farm_app/features/posts/screens/full_screen_imageviewer.dart';

class PostImage extends StatelessWidget {
  const PostImage({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
    final String heroTag = 'post_image_${post.id}';
    final String thumbnailUrl = 'https://picsum.photos/seed/${post.id}/600/400';
    final String fullScreenUrl =
        'https://picsum.photos/seed/${post.id}/1200/800';

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (_) => FullScreenImageViewer(
                  imageUrl: fullScreenUrl,
                  heroTag: heroTag,
                ),
          ),
        );
      },
      child: Hero(
        tag: heroTag,
        child: Image.network(
          thumbnailUrl,
          fit: BoxFit.cover,
          height: 250,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 250,
              color: Colors.grey[300],
              child: const Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 250,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported, color: Colors.grey),
            );
          },
        ),
      ),
    );
  }
}
