
-----

# Flutter 노트

## I. 플러터 레이아웃 만들기

### \#\#\# 텍스트: `Text()`

글자를 화면에 표시할 때 사용합니다. 첫 번째 파라미터에 원하는 텍스트를 넣고, `style` 파라미터를 통해 디자인을 변경할 수 있습니다.

```dart
Text(
  '안녕하세요!',
  style: TextStyle(
    color: Colors.blue, // 글자 색상
    fontSize: 24.0,     // 글자 크기
    fontWeight: FontWeight.bold, // 굵기
  ),
)
```

> **🎨 색상 지정 방법 3가지**
>
> 1.  **미리 정의된 색상**: `Colors.blue`, `Colors.red` 등
> 2.  **RGBO**: `Color.fromRGBO(255, 0, 0, 1)` (Red, Green, Blue, Opacity)
> 3.  **HEX 코드**: `Color(0xFFE91E63)` (앞에 `0xFF`를 붙여서 사용)

-----

### \#\#\# 아이콘: `Icon()`

미리 정의된 아이콘을 보여주는 위젯입니다. `Icons` 클래스에서 원하는 아이콘을 선택하여 사용합니다.

```dart
Icon(
  Icons.star,
  color: Colors.yellow,
  size: 50.0,
)
```

> **Tip**: 아이콘의 종류는 [Flutter 공식 문서](https://api.flutter.dev/flutter/material/Icons-class.html)에서 찾아볼 수 있습니다.

-----

### \#\#\# 이미지: `Image.asset()`

프로젝트 내부에 저장된 이미지를 불러올 때 사용합니다.

1.  프로젝트 최상단에 `assets` 폴더를 만들고 이미지를 넣습니다.
2.  `pubspec.yaml` 파일에 `assets` 폴더 경로를 등록합니다.

<!-- end list -->

```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/
```

3.  `Image.asset('경로')` 코드를 사용해 이미지를 표시합니다.

<!-- end list -->

```dart
Image.asset('assets/my_image.png')
```

-----

### \#\#\# 박스: `Container()` 와 `SizedBox()`

사각형 영역을 만드는 위젯입니다.

  - **`Container()`**: 여백(`margin`, `padding`), 테두리, 배경색 등 다양한 꾸미기가 가능한 만능 박스입니다.
  - **`SizedBox()`**: 단순히 **공간을 차지하거나 크기를 지정**하는 용도의 가벼운 박스입니다. `Container()`보다 가벼워 성능에 유리합니다.

<!-- end list -->

```dart
Container(
  width: 150,
  height: 150,
  color: Colors.blue,
  padding: EdgeInsets.all(20), // 안쪽 여백
  margin: EdgeInsets.all(10), // 바깥 여백
  child: Text('Box'),
  decoration: BoxDecoration( // color는 decoration과 동시 사용 불가
    border: Border.all(color: Colors.black),
    borderRadius: BorderRadius.circular(10),
  ),
)
```

> **단위 LP (Logical Pixel)**
> Flutter에서 사용하는 `width`, `height` 등의 단위는 LP입니다. 다양한 기기의 화면 밀도(PPI)에 관계없이 일관된 크기를 보여주기 위한 논리적 단위입니다. (참고: 1cm ≈ 38LP)

-----

### \#\#\# 위젯 배치 및 정렬

#### **`Row()`와 `Column()`: 가로/세로 배치**

여러 위젯을 가로나 세로로 나란히 배치할 때 사용합니다. `children` 파라미터에 위젯 리스트(`[]`)를 전달합니다.

  - `Row()`: 위젯을 **가로**로 배치합니다. (mainAxis: 가로)
  - `Column()`: 위젯을 **세로**로 배치합니다. (mainAxis: 세로)

<!-- end list -->

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 자식 위젯들의 간격 조절
  children: [
    Icon(Icons.star),
    Icon(Icons.star),
    Icon(Icons.star),
  ],
)
```

#### **`Center()`와 `Align()`: 특정 위치 정렬**

  - `Center()`: 자식 위젯을 부모 영역의 **중앙**에 배치합니다.
  - `Align()`: 자식 위젯을 **원하는 위치**에 정밀하게 배치합니다.

<!-- end list -->

```dart
Align(
  alignment: Alignment.bottomRight, // 우측 하단 정렬
  child: Container(width: 50, height: 50, color: Colors.blue),
)
```

#### **`Flexible()`과 `Expanded()`: 비율 배치**

`Row`나 `Column` 내부에서 공간을 비율로 나누어 차지하게 합니다.

  - `Flexible()`: `flex` 값에 따라 공간을 **비율**로 차지합니다.
  - `Expanded()`: `Flexible(fit: FlexFit.tight)`와 동일하며, 사용 가능한 **남은 공간 전체**를 차지합니다.

<!-- end list -->

```dart
Row(
  children: [
    Flexible(flex: 2, child: Container(color: Colors.blue)), // 2의 비율
    Flexible(flex: 1, child: Container(color: Colors.red)),  // 1의 비율
  ],
)
```

-----

### \#\#\# 페이지 기본 구조: `Scaffold()`

앱 화면의 기본 구조(상단 바, 본문, 하단 바 등)를 쉽게 만들도록 도와주는 뼈대 위젯입니다.

  - `appBar`: 상단 앱 바 영역. `AppBar()` 위젯을 사용합니다.
  - `body`: 화면의 대부분을 차지하는 중앙 본문 영역. (필수)
  - `bottomNavigationBar`: 하단 내비게이션 바 영역.
  - `floatingActionButton`: 화면 위에 떠 있는 원형 버튼.

<!-- end list -->

```dart
Scaffold(
  appBar: AppBar(
    title: Text('My App'),
    leading: Icon(Icons.menu), // 제목 왼쪽
    actions: [Icon(Icons.settings)], // 제목 오른쪽
  ),
  body: Center(child: Text('본문 영역')),
)
```

-----

### \#\#\# 목록: `ListView()` 와 `ListView.builder()`

스크롤이 가능한 목록을 만들 때 사용합니다.

  - **`ListView()`**: 목록의 개수가 정해져 있을 때 간단하게 사용합니다.
  - **`ListView.builder()`**: **동적으로 많은 목록**을 효율적으로 생성할 때 사용합니다. 화면에 보이는 부분만 렌더링하여 성능을 최적화합니다.

<!-- end list -->

```dart
ListView.builder(
  itemCount: 50, // 생성할 목록의 총 개수
  itemBuilder: (context, i) { // 각 항목을 그리는 함수
    return ListTile(
      leading: Icon(Icons.person),
      title: Text('Contact #$i'),
    );
  },
)
```

-----

### \#\#\# 버튼 위젯

  - `TextButton()`: 글자만 있는 버튼
  - `ElevatedButton()`: 입체감이 있는 버튼
  - `IconButton()`: 아이콘만 있는 버튼

<!-- end list -->

```dart
ElevatedButton(
  onPressed: () {
    // 버튼을 눌렀을 때 실행할 코드
    print('버튼 클릭됨!');
  },
  child: Text('Click Me'),
)
```

-----

### \#\#\# 커스텀 위젯 (위젯 재사용)

복잡하고 긴 레이아웃 코드를 별도의 클래스로 분리하여 재사용할 수 있습니다. `stless` 또는 `stful` 키워드로 자동 완성할 수 있습니다.

```dart
// 커스텀 위젯 정의 (StatelessWidget)
class MyCustomWidget extends StatelessWidget {
  const MyCustomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.red,
    );
  }
}

// 커스텀 위젯 사용
MyCustomWidget()
```

-----

## II. 플러터 주요 기능 구현

### \#\#\# State와 StatefulWidget

**State**는 앱의 '상태'를 저장하는 데이터입니다. 이 값이 변경되면 화면도 함께 변경되어야 합니다.

  - **StatelessWidget**: 한번 그려진 후 내용이 바뀌지 않는 정적인 위젯입니다.
  - **StatefulWidget**: 사용자의 행동 등으로 **State가 변경되면 화면을 다시 그리는(재렌더링)** 동적인 위젯입니다.

`StatefulWidget` 내에서 변수를 선언하면 State가 되며, 이 값을 변경할 때는 반드시 `setState()` 함수로 감싸주어야 화면이 갱신됩니다.

```dart
class Counter extends StatefulWidget {
  const Counter({super.key});
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0; // State 변수

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count.toString()),
        ElevatedButton(
          onPressed: () {
            setState(() { // 이 함수 안에서 state를 변경해야 재렌더링됨
              count++;
            });
          },
          child: Text('더하기'),
        )
      ],
    );
  }
}
```

> **성능 최적화 Tip**
> `AppBar`, `BottomNavigationBar`처럼 자주 변경되지 않는 부분은 `StatelessWidget`으로, 좋아요 버튼처럼 데이터가 자주 변하는 부분은 `StatefulWidget`으로 만들어야 앱 성능 저하를 막을 수 있습니다.

-----

### \#\#\# 다이얼로그 (팝업): `showDialog()`

사용자에게 알림이나 추가 입력을 받을 때 사용하는 팝업창입니다.

```dart
showDialog(
  context: context, // 현재 위젯의 context 정보
  builder: (context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Text('다이얼로그 내용'),
      ),
    );
  },
);
```

> **`context`란?**
> 위젯 트리에서 **현재 위젯의 위치 정보**를 담고 있는 중요한 변수입니다. `showDialog`, `Navigator` 등 다른 위젯이나 페이지와 상호작용할 때 "누가 누구를 호출했는지" 알려주는 역할을 합니다.

-----

### \#\#\# State 전달 (부모 ↔ 자식)

#### **1. 부모 → 자식으로 State 전달**

자식 위젯을 호출할 때 생성자의 파라미터로 데이터를 전달합니다.

```dart
// 1. 부모 위젯에서 자식 위젯 호출 시 데이터 전달
MyWidget(name: '홍길동', count: 10)

// 2. 자식 위젯에서 데이터 받기
class MyWidget extends StatelessWidget {
  final String name; // 전달받을 데이터의 이름과 타입을 선언
  final int count;

  // 생성자를 통해 데이터를 받음
  const MyWidget({super.key, required this.name, required this.count});

  @override
  Widget build(BuildContext context) {
    // 3. 전달받은 데이터 사용
    return Text('$name님의 카운트: $count');
  }
}
```

#### **2. 자식 → 부모로 State 변경 요청**

자식은 부모의 State를 직접 수정할 수 없습니다. 대신 **부모가 만든 State 변경 함수를 자식에게 전달**하고, 자식은 그 함수를 호출만 합니다.

```dart
// 1. 부모 위젯: State 변경 함수를 정의하고 자식에게 전달
class Parent extends StatefulWidget {
  // ...
  void increment() {
    setState(() { count++; });
  }

  @override
  Widget build(BuildContext context) {
    return Child(
      count: count,
      increment: increment, // 함수 자체를 전달
    );
  }
}

// 2. 자식 위젯: 함수를 받아 버튼 클릭 시 실행
class Child extends StatelessWidget {
  final int count;
  final Function() increment; // 함수를 받을 변수 선언

  const Child({super.key, required this.count, required this.increment});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        increment(); // 전달받은 함수 실행
      },
      child: Text(count.toString()),
    );
  }
}
```
### 혼자서 해볼 응용사항은

- 완료버튼 눌러도 Dialog 닫히게 만들려면? [V]

- 빈칸으로 완료버튼 누르면 추가안되게?   [V]

- 이름옆에 삭제버튼과 기능?     [V]

- 이름들 가나다순 정렬버튼? (sort함수 사용법을 찾아봅시다) [V]

- 전화번호 데이터도 3개 마련해놓고 전화번호도 보여주고 싶으면?[V]
  
____
## 유저에게 권한 요청하는 법

### 1\. `permission_handler` 패키지 설치

앱에서 사용자의 연락처나 파일 같은 민감한 데이터에 접근하려면, 먼저 사용자에게 권한을 요청해야 합니다. 이를 위해 `permission_handler` 패키지를 설치합니다.

1.  프로젝트의 `pubspec.yaml` 파일을 엽니다.

2.  `dependencies:` 항목 아래에 `permission_handler`를 추가합니다. (버전은 최신 버전을 확인하고 명시하는 것이 좋습니다.)

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      permission_handler: ^11.3.1 # 예시 버전
    ```

3.  파일을 저장한 후, IDE(통합 개발 환경)의 `Pub get` 버튼을 클릭하거나 터미널에서 아래 명령어를 실행하여 패키지를 설치합니다.

    ```bash
    flutter pub get
    ```

### 2\. 패키지 import 하기

권한 요청 기능을 사용할 파일 상단에 `import` 구문을 추가하여 패키지를 가져옵니다. 일반적으로 `main.dart`나 권한 요청 로직이 들어가는 파일에 추가합니다.

```dart
import 'package:permission_handler/permission_handler.dart';
```

-----

### 3\. 안드로이드(Android) 설정

안드로이드 앱에서 권한을 사용하려면 몇 가지 추가 설정이 필요합니다.

#### 1\) `gradle.properties` 파일 확인

`android/gradle.properties` 파일에 아래 두 줄이 포함되어 있는지 확인하고, 없다면 추가합니다. 대부분의 최신 플러터 프로젝트에는 이미 설정되어 있습니다.

```properties
android.useAndroidX=true
android.enableJetifier=true
```

#### 2\) `AndroidManifest.xml` 파일에 권한 추가

`android/app/src/main/AndroidManifest.xml` 파일의 `<manifest>` 태그 안에, 요청하려는 권한을 `<uses-permission>` 태그로 명시해야 합니다.

예를 들어, **연락처**와 **저장 공간** 접근 권한을 요청하려면 아래 코드를 추가합니다.

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.READ_CONTACTS"/>

    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>

    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    
    <application
        ...
    </application>
</manifest>
```

> 💡 **더 많은 권한 정보**
>
> 카메라, 위치, 마이크 등 다른 권한에 대한 설정은 [permission\_handler 공식 예제 `AndroidManifest.xml` 파일](https://www.google.com/search?q=%5Bhttps://github.com/Baseflow/flutter-permission-handler/blob/main/permission_handler/example/android/app/src/main/AndroidManifest.xml)에서](https://www.google.com/search?q=https://github.com/Baseflow/flutter-permission-handler/blob/main/permission\_handler/example/android/app/src/main/AndroidManifest.xml)%EC%97%90%EC%84%9C) 확인할 수 있습니다.

## 사용자 정보 가져오는 패키지

### contacts_service 패키지를 설치부터...
pubspec.yaml 파일에 contacts_service를 추가한다. 위 와 같은 방식이다. 설치했으면 import 'package:contacts_service/contacts_service.dart';
이거 쓰자 
사용법은 여기서 참고 https://pub.dev/packages/flutter_contacts 

var contacts = await FlutterContacts(withProperties: true);
이렇게 쓰면 모든 연락처를 가져와 List안에 담아준다고 한다.

여기서 처음보는 키워드가 나오는데 async와 await 이다. 
async는 지금 함수가 시간이 걸리는 작업을 포함하고 있을 때 비동기 방식으로 처리하겠다라고 표시하는 예약어이다.

await는 aysnc 함수 내에서 시간이 걸리는 작업 앞에 붙여서 해당 작업이 끝날 때까지 기다리게 하는 명령어이다. 하지만 중요한것은 앱 전체가 멈추는게 아니라 다른 요소들은 계속해서 정상적으로 작동한다. 

## 글자입력란 TextField 이쁘게 꾸미기
먼저 해당 위젯 안에 decoration: inputDecoration() 여기 안에 여러가지 스타일을 넣으면 된다.

### 양옆에 아이콘 넣고 싶으면 icon: 파라미터를 넣는다. 
prefixIcon: , suffixIcon: 이런 파라미터도 있다.

참고) ThemeData 파일에다가 넣고 싶으면 inputDecorationTheme: InputDecorationTheme() 열고 거기 안에 넣으면 된다. 모든 TextField에 스타일을 줄 수 있다.
### border 주려면 enabledBorder: 파라미터
~~~
TextField(
  decoration: InputDecoration(

    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.green,
        width: 1.0,
      ),
    ),

  ),
),
~~~
커서찍혔을 때, 에러일 때 등 테두리를 변경하고 싶으면 enabledBorder: 뿐만 아니라
border:, focusedBorder:, disabledBorder:, errorBorder:, focusedErrorBorder: 등를 더 넣어보고 익히자 

### border를 하단만 주려면 
~~~
TextField(
  decoration: InputDecoration(
    enabledBorder: UnderlineInputBorder(),
  ),
),
~~~
OutlineInputBorder() 위젯은 상하좌우 테두리를 주고 UnderLineInputBorder() 위젯은 하단 테두리만 주고 InputBorder.none 위젯 쓰면 테두리를 없애준다. 이 위젯들 안에서 border 두께, 색상 이런거 커스터마이징 하자 

### 테두리 둥글게 borderRadius:
~~~
TextField(
  decoration: InputDecoration(

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
    ),

  ),
),
~~~
OutlineInputBorder() 안에 넣을 수 있다.

### border 없애기 & 배경색 입히기 
~~~
TextField(
  decoration: InputDecoration(

    filled: true,
    fillColor: Colors.blue.shade100,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
    )

  ),
),
~~~
borderSide: BorderSide.none 이건 테두리 선을 없애줍니다. 

### 근처에 힌트 띄우기
~~~
TextField(
  decoration: InputDecoration(
    hintText: 'hint',
    helperText: 'helper',
    labelText: 'label',
    counterText: 'counter'
  ),
),
~~~
4개 중 원하는 것만 고르면 됩니다.

이 글자들 스타일주고 싶으면 

hintStyle: TextStyle(color: Colors.green), 

이런 파라미터를 더해주면 됩니다.

---------
## ThemeData 
🤔 ThemeData를 사용하는 이유
앱을 개발할 때 위젯마다 스타일을 개별적으로 적용하면 코드가 길어지고 지저분해집니다. **ThemeData**를 사용하면 앱 전체의 스타일(색상, 폰트 등)을 한 곳에서 중앙 관리할 수 있어, 코드의 가독성과 유지보수성이 크게 향상됩니다.

🎨 ThemeData 기본 사용법 및 예시
ThemeData는 MaterialApp 위젯의 theme 속성에 지정하여 앱 전체에 적용합니다.
~~~
Dart

MaterialApp(
  theme: ThemeData(
    // 아이콘 전체에 적용될 스타일
    iconTheme: IconThemeData(color: Colors.red, size: 40),
    
    // AppBar 전체에 적용될 스타일
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
    ),
  ),
  home: MyApp(),
)
~~~
⚠️ 스타일 적용 우선순위와 주의사항
1. 스타일이 중복될 경우
ThemeData로 설정한 전역 스타일과 위젯에 직접 지정한 로컬 스타일이 충돌하면, 위젯에 더 가까운 로컬 스타일이 우선적으로 적용됩니다.

2. 복잡한 위젯의 스타일 적용
AppBar나 Dialog처럼 여러 요소로 구성된 위젯은, 해당 위젯 전용 테마 속성 안에서 스타일을 지정해야 제대로 적용됩니다.

예시: AppBar 안의 아이콘 색상을 바꾸려면, ThemeData의 iconTheme이 아닌 appBarTheme 내부의 iconTheme 속성을 사용해야 합니다.
~~~
Dart

ThemeData(
  appBarTheme: AppBarTheme(
    // AppBar 내부의 아이콘에만 적용될 스타일
    iconTheme: IconThemeData(color: Colors.white), 
  ),
)
~~~
이러한 전용 테마는 dialogTheme, snackBarTheme 등 다양하게 존재합니다.

✍️ textTheme으로 텍스트 스타일 관리하기
textTheme을 사용하면 앱의 텍스트 스타일을 용도별로 미리 정의할 수 있습니다. Flutter의 각 위젯은 기본적으로 정해진 텍스트 스타일을 사용합니다.

Text 위젯: bodyMedium 스타일을 기본으로 사용

AppBar 제목: titleLarge 스타일을 기본으로 사용
~~~
Dart

ThemeData(
  textTheme: TextTheme(
    // Text 위젯의 기본 스타일을 파란색으로 지정
    bodyMedium: TextStyle(color: Colors.blue),
  ),
)
~~~
💡 실용적인 팁: TextStyle 변수 활용
textTheme 설정이 복잡하게 느껴진다면, 자주 사용하는 TextStyle을 변수로 만들어 재사용하는 것이 더 편리할 수 있습니다.
~~~
Dart

// 스타일을 변수로 미리 정의
var myTextStyle = TextStyle(color: Colors.red, fontWeight: FontWeight.bold);

// 필요할 때마다 변수를 가져와서 적용
Text('원하는 글자', style: myTextStyle);
~~~
ThemeData() 같은 경우는 길이가 매우 길어질 수 있다. 그럴 땐 다른 파일로 빼서 쓰면된다. 

1.lib 폴더 안에 style.dart 이런 파일을 만들어서 거기서 변수를 만들어 축약할 내용을 모두 집어 넣으면 된다.
2.impotr문으로 main.dart로 불러오면 끝 다른 파일에 있는 변수, 함수, 클래스 전부 사용할 수 있다.

import '경로' as 작명

**사용할 땐 

작명.거기있던변수명

이러면 됩니다.

 

as 키워드로 작명은 생략가능한데

작명하는게 약간 보기쉽고 변수명 중복문제도 약간 사전에 방지할 수 있습니다.**

변수를 다른 파일에서 쓰기 싫으면

 

style.dart 파일을 import 해오면 거기 있던 모든 변수, 함수, 클래스를 사용가능합니다.

근데 style.dart 파일 안에서만 쓰고 싶은 변수가 있으면 어떻게하죠?

 
~~~
var _age = 20;
var _data = 'john';
~~~
그럼 변수명 작명할 때 언더바를 왼쪽에 붙이면 됩니다.

언더바 붙이면 자동으로 "다른 파일에서 import해서 쓸 수 없는 변수"가 됩니다. 

함수명, 클래스명에도 통하니까 다른 파일에서 쓰기 싫은 변수들은 언더바를 쓰도록 합시다. 

#### ThemeData() 안의 특정스타일 불러오기 
Theme.of()는 족보를 하나 입력할 수 있다. 그 족보에서 가장 가까운 ThemeData()를 찾아서 가져와주는 함수이다.

원하는 스타일을 하나 딱 가져와서 쓸 수 있다.

## 탭으로 페이지 나누는 법 
페이지로 나누고 싶다면 여러가지 방법이 있다. 페이지가 많다면 Router를 써도 되고 

Navigator를 써서 새로운 페이지를 위에 덮어씌워도 된다. 

탭도 있는데 탭을 만드는 방법은 다음 3-step이 이다.

1. 현재 UI의 현재 상태를 저장할 state를 만들어둔다.
2. 그 state에 따라 현재 UI가 어떻게 보일지 코드를 짜 넣는다.
3. 유저가 state 쉽게 조작할 수 있는 기능을 개발해 놓는다.

위와 같이 3-step을 사용하면 동적인 UI를 만들 수 있다. 

자세히 설명을 하자면 
~~~
class MyApp extends StatefulWidget{
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
var tab = 0;
(생략)
~~~
위와 같이 StatefulWidget에서 state를 하나 만든다. 위 처럼 단순하게 0이면 0번 탭을 보여주는 상태 이렇게 써도 되고 var tab = 'home' 이런 식으로 써도 상관없다.

~~~
body: [Text('홈페이지'), Text('샵페이지')]
~~~
Scaffold()안에 body: 파라미터에 페이지 2개를 만들었다. 
이러면 tab이 0이면 Text('홈페이지') 이게 보이고 1이면 Text('삽페이지')이게 보일 것 같다.

왜냐하면 List 자료형과 그 안에서 데이터를 뽑는 문법이기 때문이다.

~~~
bottomNavigationBar: BottomNavigationBar(
    showUnselectedLabels: false,
    showSelectedLabels: false,
    currentIndex: pageNum,
    onTap: (i){
      print(i);
      setState((){
      tab = i;
      })
    },
    items: [ 생략 ]
)  
~~~
BottomNavigationBar() 안에는 onTap: 파라미터를 추가할 수 있습니다.

이러면 눌렀을 때 코드를 실행해주는데

i라는 파라미터를 추가하면 지금 몇번째 버튼을 눌렀는지 알려줍니다.

0번 버튼 누르면 i는 0이 됩니다.

1번 버튼 누르면 i는 1이 됩니다. 

 

그럼 그걸 tab = i; 이렇게 넣어버리면

0번 버튼 누르면 tab이 0이 되고 그럼 Text('홈페이지')가 보이고

1번 버튼 누르면 tab이 1이 되고 그럼 Text('샵페이지')가 보이고 그렇다.

참고로 좌우 슬라이드가 되게 만들고 싶으면 PageView()위젯으로 페이지들을 감싸면 된다.


