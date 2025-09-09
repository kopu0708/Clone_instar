import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(
      MaterialApp(
       theme: style.theme,
        home: MyApp(),
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data = [];

  getData() async{
  var result = await http.get(Uri.parse('https://codingapple1ssd.github.io/app/data.json'));
  if(result.statusCode == 200){
    data = (jsonDecode(result.body));
    print(data);
  }
  else{
    Fluttertoast.showToast(msg: "데이터를 불러오는데 실패했습니다.",  toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,);
    throw Exception('실패함 ㅄ');
  }
}
  @override

  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Instargram'),
        actions: [
        IconButton(
            onPressed: (){},
            icon: Icon(Icons.add_box_outlined)
        )
      ],
      ),
      body: [Home(data: data), Text('shop')][tab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i){
          setState(() {
            tab = i;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined),label:'샵'),
        ],
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key,required this.data});
  final List data;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: data.length, itemBuilder: (c,i){
         return Column(
           crossAxisAlignment: CrossAxisAlignment.start ,
            children: [
              Image.network(data[i]['image'],width: double.infinity,),
              Text(data[i]['likes'].toString()),
              Text(data[i]['user'].toString()),
              Text(data[i]['content'.toString()]),
            ],
          );
        }
    );
  }
}
