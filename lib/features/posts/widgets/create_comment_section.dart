import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trio_farm_app/data/model/comment_model.dart';
import 'package:trio_farm_app/features/posts/provider/post_provider.dart';
import 'package:trio_farm_app/features/posts/widgets/error_view.dart';

class CommentSection extends ConsumerWidget {
  final int postId;
  const CommentSection({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsAsyncValue = ref.watch(
      PostProviders.commentsProvider(postId),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: commentsAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => ErrorView(
              error: error,
              onRetry:
                  () => ref.invalidate(PostProviders.commentsProvider(postId)),
            ),
        data: (comments) {
          if (comments.isEmpty) {
            return const Center(child: Text('No comments yet. Be the first!'));
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder:
                (context, index) => CommentItem(comment: comments[index]),
          );
        },
      ),
    );
  }
}

class CommentItem extends StatelessWidget {
  final Comment comment;
  const CommentItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(radius: 18, child: Icon(Icons.person_outline)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.email ?? 'Anonymous',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(comment.body),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  'Like · Reply · 2h',
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
