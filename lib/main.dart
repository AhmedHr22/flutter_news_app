import 'package:flutter/material.dart';
import 'package:test_http/services/api_service.dart';

import 'models/article.dart';


void main() {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          List<Article>? record = snapshot.data;
          logger.i(record);
          if(snapshot.hasData){
            return ListView.builder(
                itemBuilder: (context, index) {
                  return Text("record[$index] : $record ");
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
