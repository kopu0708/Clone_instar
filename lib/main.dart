import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


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
  var page = 1;
  var isLoading = false;
  var userImage;

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
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/more$page.json'));
    if(result.statusCode == 200) {
      var moreData = jsonDecode(result.body);
      setState(() {
        data.add(moreData);
        page++;
      });
    }
    else{
      Fluttertoast.showToast(
          msg: "더 이상 데이터가 없습니다.",
          gravity: ToastGravity.BOTTOM
      );
    }
    setState(() {
      isLoading = false;
    });
  }
  void addPost(Map<String, dynamic> newPost){
    setState(() {
      data.insert(0, newPost);
    });
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
            icon: Icon(Icons.add_box_outlined),
            onPressed: () async{
              var picker = ImagePicker();
              var image = await picker.pickImage(source: ImageSource.gallery);
              if(image != null){
                setState(() {
                  userImage = File(image.path);
                });
              }
              Navigator.push(context,
              MaterialPageRoute(builder: (c) => Upload(
                  userImage: userImage,
                  addPost: addPost,
              ))
              );
            },
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
  
  @override
  void initState() {
    super.initState();
    scroll.addListener((){
      if(scroll.position.pixels == scroll.position.maxScrollExtent){
        widget.getmore();
      }
    });
  }
  

  @override
  Widget build(BuildContext context) {
    if(widget.data.isNotEmpty){
      return ListView.builder(
          itemCount: widget.data.length,
          controller: scroll,
          itemBuilder: (c,i){
            Widget imageWidget;

            var imageData = widget.data[i]['image'];
            // 이미지 데이터의 타입을 확인
            if (imageData is String) {
              // 타입이 String이면 Image.network 사용
              imageWidget = Image.network(imageData);
            } else if (imageData is File) {
              // 타입이 File이면 Image.file 사용
              imageWidget = Image.file(imageData);
            } else {
              // 예외 처리: 혹시 모를 다른 타입에 대비해 빈 컨테이너 표시
              imageWidget = Container(color: Colors.grey);
            }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start ,
          children: [
            imageWidget,
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
class Upload extends StatelessWidget {
  const Upload({super.key,this.userImage, this.addPost});
  final userImage;
  final Function(Map<String, dynamic>)? addPost;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(userImage),
          Text('이미지 업로드 화면'),
          TextButton(onPressed: (){
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => (addList(
                userImage: userImage,
                addPost: addPost,
              )))
            );
          }, child: Text('다음')),
          IconButton(onPressed: (){Navigator.pop(context);},
                     icon: Icon(Icons.close)
          )
        ],
      ),
    );
  }
}
class addList extends StatefulWidget {
   addList({super.key, this.userImage, this.addPost});
   final userImage;
   final Function(Map<String,dynamic>)? addPost;
  @override
  State<addList> createState() => _addListState();
}

class _addListState extends State<addList> {
   final UserName = TextEditingController();
   final letter = TextEditingController();

  @override
  void dispose(){
    UserName.dispose();
    letter.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: UserName,
            keyboardType: TextInputType.text,
            maxLength: 10,
            decoration: InputDecoration(
              labelText: 'user name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 30,),
          TextField(controller: letter,
            keyboardType: TextInputType.multiline,
            minLines: 5, maxLines: 10, maxLength: 100,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '글내용 작성'
            ),
          ),
          ElevatedButton(onPressed: (){
            if(widget.addPost != null){
              var newPost = {
                "id": UserName,
                "image": widget.userImage, // File 객체 이미지
                "likes": 0,
                "date": "July 25",
                "content": letter.text,
                "liked": false,
                "user": UserName.text
              };
              widget.addPost!(newPost);
            }
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
              child:Text('발행'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                foregroundColor: Colors.black,
                elevation: 5
              ),
          )
        ],),
      ),
    );
  }
}
