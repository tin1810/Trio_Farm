import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trio_farm_app/core/util/app_color.dart';
import 'package:trio_farm_app/core/util/app_textstyle.dart';
import 'package:trio_farm_app/features/posts/provider/post_provider.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _titleController.addListener(() {
      setState(() {});
    });
    _bodyController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submitPost() async {
    if (_titleController.text.trim().isEmpty ||
        _bodyController.text.trim().isEmpty ||
        _isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final postRepository = ref.read(PostProviders.postRepositoryProvider);

      await postRepository.createPost(
        _titleController.text.trim(),
        _bodyController.text.trim(),
      );

      ref.invalidate(PostProviders.postsProvider);

      if (mounted) {
        final snackBarController = ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post created successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );

        await snackBarController.closed;

        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create post: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPostButtonEnabled =
        _titleController.text.trim().isNotEmpty &&
        _bodyController.text.trim().isNotEmpty &&
        !_isLoading;

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text('Create Post', style: AppTextStyles.headlineMediumSemibold),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: ElevatedButton(
              onPressed: isPostButtonEnabled ? _submitPost : null,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor:
                    isPostButtonEnabled ? AppColor.blue : Colors.grey[300],
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child:
                  _isLoading
                      ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColor.white,
                        ),
                      )
                      : Text(
                        'Post',
                        style: TextStyle(
                          color:
                              isPostButtonEnabled
                                  ? AppColor.white
                                  : Colors.grey[500],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColor.blue,
                  child: Icon(Icons.person, color: AppColor.white, size: 30),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Name', style: AppTextStyles.bodyBold),
                    Text(
                      'Posting publicly',
                      style: AppTextStyles.smallRegular.copyWith(
                        color: AppColor.textGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              autofocus: true,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: TextFormField(
                controller: _bodyController,
                maxLines: null,
                expands: true,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
