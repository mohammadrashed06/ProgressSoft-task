import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostsRepository {
  final String authority;

  PostsRepository({required this.authority});

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('$authority/posts'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((postJson) => Post.fromJson(postJson)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<List<Post>> searchPosts(String? query) async {
    if (query == null || query.isEmpty) {
      return fetchPosts();
    }

    final response = await http.get(Uri.parse('$authority/posts?title=$query'));
    print(response.request?.url.toString());
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((postJson) => Post.fromJson(postJson)).toList();
    } else {
      throw Exception('Failed to search posts');
    }
  }
}
