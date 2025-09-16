import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/rendering.dart';


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
  var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
  if(result.statusCode == 200){
    setState(() {
      data = (jsonDecode(result.body));
    });
    print(data);
  }
  else{
      Fluttertoast.showToast(
        msg: "데이터를 불러오는데 실패했습니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,);
    //throw Exception('실패함 ㅄ');
  }
}
  getmore() async{
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    if(result.statusCode == 200) {
      var moreData = jsonDecode(result.body);
      setState(() {
        data.add(moreData);
      });
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
      body: [Home(data: data, getmore : getmore), Text('shop')][tab],
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

class Home extends StatefulWidget {
  const Home({super.key,required this.data, required this.getmore});
  final Function() getmore;
  final List data;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  var scroll = ScrollController();
  var extraData;
  var loading = 0;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(scroll.position.pixels == scroll.position.maxScrollExtent){
      loading++;
    }

    scroll.addListener((){
      if(scroll.position.pixels == scroll.position.maxScrollExtent && loading == 1){
        widget.getmore();
      }
    });
  }
  

  @override
  Widget build(BuildContext context) {
    if(widget.data.isNotEmpty){
      return ListView.builder(
          itemCount: widget.data.length,controller: scroll, itemBuilder: (c,i){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start ,
          children: [
            Image.network(widget.data[i]['image']),
            Text('좋아용 ${widget.data[i]['likes'].toString()}'),
            Text(widget.data[i]['user'].toString()),
            Text(widget.data[i]['content'].toString()),
          ],
        );
      }
      );
    }
    else {
      return Text('로딩중임');
    }
  }
}
