import 'dart:convert';
import 'package:http/http.dart' as http ;
import 'package:logger/logger.dart';
import '../models/article.dart';

Logger logger = Logger();

class ApiService{
  Uri urlEndPoint = Uri.parse("https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=a33bd441e490444da8a2dccc9d465db5");

  Future<List<Article>> getArticles() async {
    var response =await http.get(urlEndPoint);

    if(response.statusCode == 200) {
      // logger.w("success");
      Map<String,dynamic> body = jsonDecode(response.body);
      logger.i("json=${body["articles"]}");
      List<dynamic> newsBody = body["articles"];
      logger.i("articlebodey = $newsBody");
      // return [];
      //
      List<Article> articles = newsBody.map((dynamic item) => Article.fromJson(item)).toList();
      logger.i("articles = $articles");
      return articles;
    }
    else{
      throw Exception("failed to load an articles");
    }


  }


}