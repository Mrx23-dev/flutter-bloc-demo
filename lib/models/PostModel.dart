class PostModel {
  int? id;
  String? title;
  String? body;

  PostModel({
    this.id,
    required this.title,
    required this.body
  });

  //method to get data from map
  PostModel fromJson(Map<String, dynamic> json){
    return PostModel(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        body: json['body'] ?? '',
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id ?? 0,
      'title': title ?? '',
      'body': body ?? '',
    };
  }
}