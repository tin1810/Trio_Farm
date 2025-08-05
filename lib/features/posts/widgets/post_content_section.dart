import 'package:flutter/material.dart';
import 'package:trio_farm_app/core/util/app_textstyle.dart';
import 'package:trio_farm_app/data/model/post_model.dart';

class PostContent extends StatelessWidget {
  const PostContent({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: AppTextStyles.bodyBold.copyWith(fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 4),
          Text(
            post.body,
            style: AppTextStyles.smallRegular.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
