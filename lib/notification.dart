import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';
// import 'package:flutter/services.dart'; // (현재 사용되지 않음)

final notifications = FlutterLocalNotificationsPlugin();

// 1. (추가) context 없이 네비게이션하기 위한 GlobalKey
// 이 키는 main.dart의 MaterialApp에도 설정해야 합니다.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// 2. (추가) 알림을 탭했을 때 실행될 함수 (최상위 레벨)
void onNotificationTapped(NotificationResponse notificationResponse) {
  // final String? payload = notificationResponse.payload; // 페이로드 사용 시

  // context 대신 navigatorKey를 사용하여 페이지 이동
  if (navigatorKey.currentState != null) {
    navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (context) => Text('새로운 페이지')),
    );
  }
}

// 3. (수정) 앱 로드 시 실행할 기본 설정
initNotification() async { // <-- context 매개변수 제거

  // (추가) 타임존 초기화 (showNotification2를 위해 앱 시작 시 한 번만 실행)
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.local);

  // 일반 알림 권한 요청 (Android 13+)
  notifications.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  // (추가하신 코드) 정확한 알람 권한 요청 (Android 12+)
  // zonedSchedule의 exactAllowWhileIdle 모드 사용 시 필수
  if (Platform.isAndroid) {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
    notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final granted = await androidImplementation?.requestExactAlarmsPermission();
    if (granted == true) {
      print("정확한 알람 권한 받음");
    } else {
      print("정확한 알람 권한 거절");
    }
  }

  // 안드로이드용 아이콘 설정
  var androidSetting = AndroidInitializationSettings('app_icon');

  // iOS 권한 설정
  var iosSetting = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  var initializationSettings = InitializationSettings(
    android: androidSetting,
    iOS: iosSetting,
    // 4. (중요) 앱 실행 중 알림 탭 시 콜백
    onDidReceiveNotificationResponse: onNotificationTapped,
  );

  // 5. (수정) initialize 함수 변경
  await notifications.initialize(
    initializationSettings,
    // (오류 발생 부분) onSelectNotification 파라미터는 여기서 완전히 제거합니다.
  );

  // 6. (추가) 앱이 종료된 상태에서 알림을 탭하여 실행된 경우 처리
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
  await notifications.getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    if (notificationAppLaunchDetails!.notificationResponse != null) {
      // 앱을 실행시킨 알림의 응답(payload 등)을 가지고 탭 로직 수행
      onNotificationTapped(notificationAppLaunchDetails.notificationResponse!);
    }
  }
}

// (변경 없음) 즉시 알림
showNotification() async {
  var androidDetails = AndroidNotificationDetails(
    '유니크한 알림 채널 ID',
    '알림종류 설명',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );
  var iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  notifications.show(
      1,
      '제목1',
      '내용1',
      NotificationDetails(android: androidDetails, iOS: iosDetails)
  );
}

// (수정) 예약 알림
showNotification2() async {

  // (제거) tz.initializeTimeZones();
  // -> initNotification()으로 이동 (앱 실행 시 한 번만 호출)

  var androidDetails = const AndroidNotificationDetails(
    '유니크한 알림 ID',
    '알림종류 설명',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );
  var iosDetails = const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  notifications.zonedSchedule(
      2,
      '제목2',
      '내용2',
      tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)),
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime
  );
}