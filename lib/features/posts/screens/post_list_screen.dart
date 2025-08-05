import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trio_farm_app/data/model/post_model.dart';
import 'package:trio_farm_app/features/posts/provider/post_provider.dart';
import 'package:trio_farm_app/features/posts/screens/post_detail_screen.dart';
import 'package:trio_farm_app/features/posts/widgets/create_post_section.dart';
import 'package:trio_farm_app/features/posts/widgets/post_action_section.dart';
import 'package:trio_farm_app/features/posts/widgets/post_content_section.dart';
import 'package:trio_farm_app/features/posts/widgets/post_header_section.dart';
import 'package:trio_farm_app/features/posts/widgets/post_image.dart';

class PostListScreen extends ConsumerWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsyncValue = ref.watch(PostProviders.postsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: const Text('Feeds'), elevation: 1.0),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(PostProviders.postsProvider.future),
        child: postsAsyncValue.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('An error occurred: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(PostProviders.postsProvider);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
          data: (posts) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: posts.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const CreatePostSection();
                }

                final post = posts[index - 1];
                return PostCard(key: Key('post_card_${post.id}'), post: post);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8.0),
            );
          },
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PostDetailHeader(post: post, isDetail: false),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return PostDetailScreen(postId: post.id);
                  },
                ),
              );
            },
            child: PostContent(post: post),
          ),
          PostImage(post: post),
          PostDetailAction(post: post),
        ],
      ),
    );
  }
}
