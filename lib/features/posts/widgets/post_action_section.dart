import 'package:flutter/material.dart';
import 'package:trio_farm_app/core/util/app_color.dart';
import 'package:trio_farm_app/data/model/post_model.dart';

class PostDetailAction extends StatelessWidget {
  const PostDetailAction({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Icon(Icons.thumb_up, color: AppColor.blue, size: 16),
              const SizedBox(width: 4),
              const Text('123', style: TextStyle(color: Colors.grey)),
              const Spacer(),
              Text('45 Comments', style: TextStyle(color: Colors.grey[700])),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ActionButton(
              icon: Icons.thumb_up_alt_outlined,
              label: 'Like',
              onPressed: () {},
            ),
            ActionButton(
              icon: Icons.comment_outlined,
              label: 'Comment',
              onPressed: () {},
            ),
            ActionButton(
              icon: Icons.share_outlined,
              label: 'Share',
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.grey[700]),
        label: Text(label, style: TextStyle(color: Colors.grey[700])),
        style: TextButton.styleFrom(foregroundColor: Colors.black12),
      ),
    );
  }
}
