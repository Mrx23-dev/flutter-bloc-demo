import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_demo/screens/post_form_page.dart';

import '../bloc/post_bloc.dart';

class PostListPage extends StatelessWidget {
  const PostListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post Master View'),),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (_)=> PostFormPage(),
          ));
        },
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state){
          if(state is PostLoading) return const Center(child: CircularProgressIndicator(),);
          if(state is PostError) return Center(child: Text(state.error,style: TextStyle(color: Colors.red),));
          if(state is PostLoaded || PostBloc().postMemoryCache.isNotEmpty){
            final list = context.read<PostBloc>().postMemoryCache;
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index){
                return ListTile(
                  title: Text(list[index].title??''),
                  subtitle: Text(list[index].body??'',maxLines: 1,),
                );
              },
            );
          }
          return const Center(child: Text('No posts found.'));
        },
      ),
    );
  }
}