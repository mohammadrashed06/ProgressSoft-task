import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_soft_task/blocs/home/post_event.dart';
import 'package:progress_soft_task/blocs/home/post_state.dart';

import '../../models/post.dart';
import '../../repositories/posts_repository.dart';


class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository postsRepository;
  List<Post> allPosts = [];

  PostsBloc({required this.postsRepository}) : super(PostsInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<SearchPosts>(_onSearchPosts);
  }

  void _onFetchPosts(FetchPosts event, Emitter<PostsState> emit) async {
    emit(PostsLoading());
    try {
      allPosts = await postsRepository.fetchPosts();
      emit(PostsLoaded(allPosts));
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }

  void _onSearchPosts(SearchPosts event, Emitter<PostsState> emit) {
    final query = event.query;
    if (query.isEmpty) {
      emit(PostsLoaded(allPosts));
    } else {
      final filteredPosts = allPosts.where((post) {
        return post.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
      emit(PostsLoaded(filteredPosts));
    }
  }
}
