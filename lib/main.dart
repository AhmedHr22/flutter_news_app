// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:test_http/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/article.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  ApiService apiService = ApiService();

  // void _launchURL(String url) async {
  //   Uri uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri);
  //   } else {
  //     throw 'Could not launch $uri';
  //   }
  // }
  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  Widget buildItemList(Article record){
    if (record != null){
      return Card(
        elevation: 5,
        child: ListTile(
          leading: Image.network("${record.urlToImage}"),
          title: Text("${record.title}"),
          subtitle: Text("${record.author}"),
          trailing: ElevatedButton(onPressed: () {
            setState(() {
              _launchURL('${record.url}');
            });
          },
          child: const Icon(Icons.link)),
        ),
      );

    }else{
      return const Text("failed to display the item");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Article>>(
        future: apiService.getArticles() ,
        builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
          var record = snapshot.data;
          logger.i(record);
          if(snapshot.hasData){
            return ListView.builder(
                itemCount:snapshot.data?.length,
                itemBuilder: (context, index) {
                  return buildItemList(record![index]);
                    // Text("record[$index] : ${record![index].title} ");
                },
            );
          }else{
            logger.e(snapshot.error);
            return const Center(child: CircularProgressIndicator());
          }
        },
      )

    );
  }
}
