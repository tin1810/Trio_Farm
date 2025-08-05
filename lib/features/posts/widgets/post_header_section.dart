import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trio_farm_app/core/util/app_color.dart';
import 'package:trio_farm_app/core/util/app_textstyle.dart';
import 'package:trio_farm_app/data/model/post_model.dart';
import 'package:trio_farm_app/features/posts/provider/post_provider.dart';
import 'package:trio_farm_app/features/posts/screens/edit_post_screen.dart';

class PostDetailHeader extends StatelessWidget {
  final bool isDetail;
  final Post post;
  const PostDetailHeader({
    super.key,
    required this.post,
    required this.isDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColor.blue,
            child: Text("U${post.id}", style: TextStyle(color: AppColor.white)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User ${post.id}', style: AppTextStyles.bodyRegular),
                Text(
                  '5h ago · Public',
                  style: AppTextStyles.smallRegular.copyWith(
                    color: const Color(0xFF9E9E9E),
                  ),
                ),
              ],
            ),
          ),
          isDetail ? MoreOptionButton(post: post) : SizedBox(),
        ],
      ),
    );
  }
}

class MoreOptionButton extends ConsumerWidget {
  final Post post;
  const MoreOptionButton({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EditPostPage(post: post)),
          );
        } else if (value == 'delete') {
          _showDeleteConfirmation(context, post.id, ref);
        }
      },
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit, color: AppColor.green),
                title: Text('Edit Post', style: AppTextStyles.smallRegular),
              ),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: AppColor.red),
                title: Text('Delete Post', style: AppTextStyles.smallRegular),
              ),
            ),
          ],
      icon: Icon(Icons.more_horiz, color: Colors.grey[700]),
    );
  }
}

void _showDeleteConfirmation(BuildContext context, int? id, WidgetRef ref) {
  showDialog(
    context: context,
    builder:
        (dialogContext) => AlertDialog(
          title: Text('Delete Post?', style: AppTextStyles.bodyBold),
          content: const Text(
            'Are you sure you want to delete this post? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel', style: AppTextStyles.smallRegular),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                _performDelete(context, id ?? 0, ref);
              },
              child: Text(
                'Delete',
                style: AppTextStyles.smallRegular.copyWith(color: AppColor.red),
              ),
            ),
          ],
        ),
  );
}

Future<void> _performDelete(BuildContext context, int id, WidgetRef ref) async {
  try {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Deleting post...'),
        duration: Duration(seconds: 1),
      ),
    );

    await ref.read(PostProviders.postRepositoryProvider).deletePost(id);

    ref.invalidate(PostProviders.postsProvider);
    ref.invalidate(PostProviders.postDetailProvider(id));

    if (context.mounted) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post deleted successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete post: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
