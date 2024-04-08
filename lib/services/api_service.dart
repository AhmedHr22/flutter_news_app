import 'dart:convert';
import 'package:http/http.dart' as http ;
import 'package:logger/logger.dart';
import '../models/article.dart';

Logger logger = Logger();

class ApiService{
  Uri urlEndPoint = Uri.parse("https://newsapi.org/v2/everything?q=tesla&from=2024-03-08&sortBy=publishedAt&apiKey=a33bd441e490444da8a2dccc9d465db5");

  Future<List<Article>> getArticles() async {
    var response =await http.get(urlEndPoint);

    try{
      if(response.statusCode == 200) {
        Map<String,dynamic> body = jsonDecode(response.body);
        // logger.i("json=$json");

        List<dynamic> newsBody = jsonDecode(body["articles"]);
        // logger.i("articlebodey = $newsBody");

        List<Article> articles = newsBody.map((dynamic item) => Article.fromJson(item)).toList();
        // logger.i("articles = $articles");
        return articles;
      }
      else{
        throw Exception("failed to load an articles");
      }
    }catch(e){
      logger.e(e);
    }
    return [];

  }
}