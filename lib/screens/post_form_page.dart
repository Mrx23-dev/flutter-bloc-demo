import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_demo/bloc/post_bloc.dart';
import 'package:flutter_bloc_demo/models/PostModel.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostFormPage extends StatefulWidget {
  const PostFormPage({super.key});

  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostSuccess) {
            Fluttertoast.showToast(msg: "Success!");
          }
          if (state is PostError) {
            Fluttertoast.showToast(msg: state.error);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(label: Text('Title')),
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? 'Enter a title'
                        : null;
                  },
                ),
                TextFormField(
                  controller: bodyController,
                  decoration: InputDecoration(label: Text('Body Description')),
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? 'Enter a body text'
                        : null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      if(formKey.currentState!.validate()){
                        PostModel post = PostModel(title: titleController.text, body: bodyController.text);
                        context.read<PostBloc>().add(AddPost(post));
                      }
                    },
                    child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
