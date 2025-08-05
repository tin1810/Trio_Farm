import 'dart:convert';

import '../../core/network/api_client.dart';
import '../../core/util/app_constant.dart';
import '../model/comment_model.dart';
import '../model/post_model.dart';

class PostRepository {
  final ApiClient _apiClient;
  PostRepository(this._apiClient);

  Future<List<Post>> getPosts() async {
    final response = await _apiClient.get(AppConstant.postUrl);
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Post.fromJson(json)).toList();
  }

  Future<Post> getPostDetails(int id) async {
    final response = await _apiClient.get('${AppConstant.postUrl}/$id');
    return Post.fromJson(jsonDecode(response.body));
  }

  Future<Post> createPost(String title, String body) async {
    final response = await _apiClient.post(
      AppConstant.postUrl,
      body: {'title': title, 'body': body, 'userId': 1},
    );
    return Post.fromJson(jsonDecode(response.body));
  }

  Future<List<Comment>> getComments(int postId) async {
    final response = await _apiClient.get(
      '${AppConstant.commentUrl}?postId=$postId',
    );
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Comment.fromJson(json)).toList();
  }

  Future<void> deletePost(int postId) async {
    await _apiClient.delete('${AppConstant.postUrl}/$postId');
  }

  Future<Post> updatePost(int postId, Map<String, dynamic> data) async {
    final response = await _apiClient.patch(
      '${AppConstant.postUrl}/$postId',
      body: data,
    );
    return Post.fromJson(jsonDecode(response.body));
  }
}
