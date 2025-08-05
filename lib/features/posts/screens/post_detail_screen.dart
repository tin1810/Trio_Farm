import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trio_farm_app/core/util/app_color.dart';
import 'package:trio_farm_app/core/util/app_textstyle.dart' show AppTextStyles;
import 'package:trio_farm_app/features/posts/provider/post_provider.dart';
import 'package:trio_farm_app/features/posts/widgets/create_comment_section.dart';
import 'package:trio_farm_app/features/posts/widgets/error_view.dart';
import 'package:trio_farm_app/features/posts/widgets/post_action_section.dart';
import 'package:trio_farm_app/features/posts/widgets/post_detail_body.dart';
import 'package:trio_farm_app/features/posts/widgets/post_header_section.dart';

class PostDetailScreen extends ConsumerWidget {
  final int postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsyncValue = ref.watch(PostProviders.postDetailProvider(postId));

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          "Post",
          style: AppTextStyles.bodyRegular.copyWith(fontSize: 20),
        ),
      ),
      body: postAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => ErrorView(
              error: error,
              onRetry:
                  () =>
                      ref.invalidate(PostProviders.postDetailProvider(postId)),
            ),
        data: (post) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(PostProviders.postDetailProvider(postId));
              ref.invalidate(PostProviders.commentsProvider(postId));
            },
            child: ListView(
              children: [
                PostDetailHeader(post: post, isDetail: true),
                PostDetailBody(post: post),
                PostDetailAction(post: post),
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                CommentSection(postId: post.id),
              ],
            ),
          );
        },
      ),
    );
  }
}
