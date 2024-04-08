class Article{
  final String author;
  final String title;
  final String description;
  final String urlToImage;
  final String publishedAt;
  final String content;

  Article(
      this.author,
      this.title,
      this.description,
      this.urlToImage,
      this.publishedAt,
      this.content,
  );

  factory Article.fromJson(Map<String , dynamic>json){
    return switch(json){
      {
        "author":String author,
        "title":String title,
        "description":String description,
        "urlToImage":String urlToImage,
        "publishedAt":String publishedAt,
        "content":String content,
      } => Article(author, title, description, urlToImage, publishedAt, content),
      _ =>throw Exception("failed to load an article")
    };
  }



}