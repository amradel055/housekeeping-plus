import 'package:easy_hotel/app/core/utils/show_popup_text.dart';
import 'package:easy_hotel/app/core/utils/user_manager.dart';
import 'package:easy_hotel/app/core/values/app_constants.dart';
import 'package:easy_hotel/app/data/model/delivery/homePage/dto/request/active_orders_request.dart';
import 'package:easy_hotel/app/data/model/delivery/homePage/dto/request/all_orders_request.dart';
import 'package:easy_hotel/app/data/model/delivery/homePage/dto/request/delayed_orders_request.dart';
import 'package:easy_hotel/app/data/model/delivery/homePage/dto/request/deliver_finish_request.dart';
import 'package:easy_hotel/app/data/model/delivery/homePage/dto/request/deliver_orders_request.dart';
import 'package:easy_hotel/app/data/model/delivery/homePage/dto/request/deliver_request.dart';
import 'package:easy_hotel/app/data/model/delivery/homePage/dto/response/order_response.dart';
import 'package:easy_hotel/app/data/repository/delivery/delivery_repository.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../main.dart';
import '../../../core/values/app_strings.dart';

class HomeController extends GetxController {
  RxInt index = 0.obs;
  RxInt serviceIndex = 0.obs;
  RxInt selectedType = 1.obs;
  final isLoading = false.obs;
  var activeOrders = <PolmanOrder>[].obs;
  var allActiveOrders = <PolmanOrder>[].obs;
  final deliverdOrders = <PolmanOrder>[].obs;
  final allOrders = <PolmanOrder>[].obs;
  var delayedOrders = <PolmanOrder>[].obs;
  var allDelayedOrders = <PolmanOrder>[].obs;
   final user = UserManager();
  @override
  void onInit() {
    super.onInit();
    getActiveOrders();

    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    firebaseMessaging.subscribeToTopic(AppConstants.houseKeeping);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
    });
    var initialzationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
                importance: Importance.max,
                priority: Priority.max,
                playSound: true,
              ),
            ));

        FirebaseMessaging.onMessageOpenedApp.listen((event) {
          print("sdsd");
        });
      }
    });
  }

  getActiveOrders() async {
    isLoading(true);
    final request = ActiveOrdersRequestDto(
      branchId: user.user!.branchId!,
    );
    DeliveryRepository().getActiveOrders(request,
        onSuccess: (data) {
          activeOrders.assignAll(data.data);
          allActiveOrders = activeOrders;
        },
        onError: (e) => showPopupText(e.toString()),
        onComplete: () => isLoading(false));
  }

  getDeliveredOrders() async {
    isLoading(true);
    final request = DeliverOrdersRequestDto(branchId: 232, finishBy: 1);
    DeliveryRepository().getDeliveredOrders(request,
        onSuccess: (data) {
          deliverdOrders.assignAll(data.data);
        },
        onError: (e) => showPopupText(e.toString()),
        onComplete: () => isLoading(false));
  }

  getAllOrders() async {
    isLoading(true);
    final request = AllOrdersRequestDto(
      branchId: user.user!.branchId!,
      finishBy: 1,
    );
    DeliveryRepository().getAllOrders(request,
        onSuccess: (data) {
          allOrders.assignAll(data.data);
        },
        onError: (e) => showPopupText(e.toString()),
        onComplete: () => isLoading(false));
  }

  getDelyedOrders() async {
    isLoading(true);
    final request = DelayOrdersRequestDto(finishBy: 1);
    DeliveryRepository().getDelayedOrders(request,
        onSuccess: (data) {
          delayedOrders.assignAll(data.data);
          allDelayedOrders = delayedOrders;
        },
        onError: (e) => showPopupText(e.toString()),
        onComplete: () => isLoading(false));
  }

  filter(String num) {
    delayedOrders.value = List<PolmanOrder>.from(allDelayedOrders
        .where((element) => element.customerName!.contains(num))
        .toList());
  }

  getDeliver(int id,  int customerId) async {
    isLoading(true);
    final request = DeliverRequestDto(id: id, createdBy: user.user!.id!);
    DeliveryRepository().getdeliver(request,
        onSuccess: (data) {
          getActiveOrders();
          UserManager().sendNewOrderNotification(
              "${AppConstants.customer}_$customerId", AppStrings.orderStarted);
          showPopupText(AppStrings.orderStarted);
        },
        onError: (e) => showPopupText(e.toString()),
        onComplete: () => isLoading(false));
  }

  getFinishDeliver(int id, int customerId) async {
    isLoading(true);
    final request = DeliverFinishRequestDto(
      id: id,
    );
    DeliveryRepository().getFinishdeliver(request,
        onSuccess: (data) {
          getDeliveredOrders();
          UserManager().sendNewOrderNotification(
              "${AppConstants.customer}_$customerId", AppStrings.orderFinished);
          showPopupText(AppStrings.orderFinished);
        },
        onError: (e) => showPopupText(e.toString()),
        onComplete: () => isLoading(false));
  }
}
