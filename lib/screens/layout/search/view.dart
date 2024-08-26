import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/post_ctrl.dart';
import '../../_resources/assets_path/icon_broken.dart';
import '../home/widgets.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: context.read<PostCtrl>().searchCtrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'search about anything...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.read<PostCtrl>().searchPosts();
                  },
                  icon: const Icon(
                    IconBroken.search,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<PostCtrl, PostStates>(
              builder: (context, state) {
                final cubit = context.read<PostCtrl>();
                if (state is GetPostsLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is GetPostsErrorState) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconBroken.lock,
                          color: Colors.red,
                          size: 100,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Failed to load posts',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  );
                }
                if (cubit.filteredPosts.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconBroken.document,
                          color: Colors.grey,
                          size: 100,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'No posts found',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemBuilder: (context, index) =>
                      PostCardItem(cubit.filteredPosts[index]),
                  itemCount: cubit.filteredPosts.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
