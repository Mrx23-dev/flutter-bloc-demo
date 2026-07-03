
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_demo/models/PostModel.dart';
import 'package:flutter_bloc_demo/network/DioClient.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<PostModel> posts;

  PostLoaded(this.posts);
}
class PostSuccess extends PostState {}

class PostError extends PostState {
  final String error;

  PostError(this.error);
}

abstract class PostEvent {}

class FetchPost extends PostEvent {}

class AddPost extends PostEvent {
  final PostModel newPost;

  AddPost(this.newPost);
}

class PostBloc extends Bloc<PostEvent, PostState> {
  List<PostModel> postMemoryCache = [];

  PostBloc() : super(PostInitial()) {
    on<FetchPost>((event, emit) async {
      emit(PostLoading());
      try {
        final response = await DioClient.instance.dio.get('/posts?_limit=10');
        postMemoryCache = (response.data as List).map((jsonMap){
          return PostModel(title: '', body: '').fromJson(jsonMap);
        }).toList();
        emit(PostLoaded(postMemoryCache));
      } on DioException catch (e) {
        emit(PostError(DioClient.instance.handleNetworkError(e)));
      } catch (e) {
        emit(PostError('An unexpected error occurred.'));
      }
    });

    on<AddPost>((event, emit) async {
      emit(PostLoading());
      try {
        final response = await DioClient.instance.dio.post(
            '/posts',
            data: event.newPost.toJson(),
        );
        final createdPost = PostModel(title: '', body: '').fromJson(response.data);
        postMemoryCache.insert(0, createdPost);
        emit(PostSuccess());
      } on DioException catch (e) {
        emit(PostError(DioClient.instance.handleNetworkError(e)));
      } catch (e) {
        emit(PostError('An unexpected error occurred.'));
      }
    });
  }
}
