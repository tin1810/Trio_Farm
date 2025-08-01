import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trio_farm/features/posts/provider/post_provider.dart';

class PostDetailScreen extends ConsumerWidget {
  final int postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postDetailAsyncValue = ref.watch(
      PostProviders.postDetailProvider(postId),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Post Details")),
      body: postDetailAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (post) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Text(post.body),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
