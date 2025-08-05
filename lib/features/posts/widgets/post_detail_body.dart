import 'package:flutter/material.dart';
import 'package:trio_farm_app/core/util/app_textstyle.dart';
import 'package:trio_farm_app/data/model/post_model.dart';

class PostDetailBody extends StatelessWidget {
  const PostDetailBody({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            height: 1.4,
          ),
          children: [
            TextSpan(text: '${post.title}\n\n', style: AppTextStyles.bodyBold),
            TextSpan(
              text: post.body,
              style: AppTextStyles.bodyRegular.copyWith(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
