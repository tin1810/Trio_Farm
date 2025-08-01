import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trio_farm/core/network/api_client.dart';
import 'package:trio_farm/data/model/post_model.dart';
import 'package:trio_farm/data/repository/post_repository.dart';

late final BuildContext context;

class PostProviders {
  static final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

  static final postRepositoryProvider = Provider<PostRepository>((ref) {
    return PostRepository(ref.watch(apiClientProvider));
  });

  static final postsProvider = FutureProvider<List<Post>>((ref) {
    final repository = ref.watch(postRepositoryProvider);
    return repository.getPosts(context);
  });

  static final postDetailProvider = FutureProvider.family<Post, int>((
    ref,
    postId,
  ) {
    final repository = ref.watch(postRepositoryProvider);
    return repository.getPostDetails(context, postId);
  });
}
