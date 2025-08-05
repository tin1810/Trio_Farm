import 'package:flutter/material.dart';
import 'package:trio_farm_app/core/util/app_color.dart';
import 'package:trio_farm_app/core/util/app_textstyle.dart';
import 'package:trio_farm_app/features/posts/screens/create_post_screen.dart';

class CreatePostSection extends StatelessWidget {
  const CreatePostSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColor.blue,
                  child: Icon(Icons.person, color: AppColor.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CreatePostScreen();
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "What's on your mind?",
                        style: AppTextStyles.bodyRegular,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
          ],
        ),
      ),
    );
  }
}
