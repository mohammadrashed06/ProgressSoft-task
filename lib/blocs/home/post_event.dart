import 'package:equatable/equatable.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object?> get props => [];
}

class FetchPosts extends PostsEvent {}

class SearchPosts extends PostsEvent {
  final String query;

  const SearchPosts(this.query);

  @override
  List<Object?> get props => [query];
}
