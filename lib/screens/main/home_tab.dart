import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/home/post_bloc.dart';
import '../../blocs/home/post_event.dart';
import '../../blocs/home/post_state.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PostsBloc>().add(FetchPosts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    final query = _searchController.text;
                    context.read<PostsBloc>().add(SearchPosts(query));
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<PostsBloc, PostsState>(
                builder: (context, state) {
                  if (state is PostsInitial || state is PostsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PostsLoaded) {
                    return ListView.builder(
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        final post = state.posts[index];
                        return ListTile(
                          title: Text(post.title,style: const TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text(post.body),
                        );
                      },
                    );
                  } else if (state is PostsError) {
                    return Center(child: Text(state.error));
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
