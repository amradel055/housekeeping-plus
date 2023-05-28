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

class HomeController extends GetxController {

  RxInt  index = 0.obs;
  RxInt  serviceIndex = 0.obs;
  RxInt selectedType = 1.obs;
  final isLoading = false.obs;
  var activeOrders = <PolmanOrder>[].obs;
  var allActiveOrders = <PolmanOrder>[].obs;
  final deliverdOrders = <PolmanOrder>[].obs;
  final allOrders = <PolmanOrder>[].obs;
  var delayedOrders = <PolmanOrder>[].obs;
  var allDelayedOrders = <PolmanOrder>[].obs;




   @override
  void onInit() {
    super.onInit();
    getActiveOrders();


  }

   getActiveOrders() async {
     isLoading(true);
     final request = ActiveOrdersRequestDto(
       branchId: 232,



     );
     DeliveryRepository().getActiveOrders(request,
         onSuccess: (data) {
           activeOrders.assignAll(data.data);
           allActiveOrders=activeOrders;

         },
         onError: (e) => showPopupText( e.toString()),
         onComplete: () => isLoading(false)
     );
   }

   getDeliveredOrders() async {
     isLoading(true);
     final request = DeliverOrdersRequestDto(
         branchId: 232,
         finishBy: 1


     );
     DeliveryRepository().getDeliveredOrders(request,
         onSuccess: (data) {
           deliverdOrders.assignAll(data.data);
         },
         onError: (e) => showPopupText( e.toString()),
         onComplete: () => isLoading(false)
     );
   }

   getAllOrders() async {
     isLoading(true);
     final request = AllOrdersRequestDto(
         branchId: 232,
         finishBy: 1,


     );
     DeliveryRepository().getAllOrders(request,
         onSuccess: (data) {
           allOrders.assignAll(data.data);
         },
         onError: (e) => showPopupText( e.toString()),
         onComplete: () => isLoading(false)
     );
   }

   getDelyedOrders() async {
     isLoading(true);
     final request = DelayOrdersRequestDto(
         finishBy: 1


     );
     DeliveryRepository().getDelayedOrders(request,
         onSuccess: (data) {
           delayedOrders.assignAll(data.data);
           allDelayedOrders=delayedOrders;

         },
         onError: (e) => showPopupText( e.toString()),
         onComplete: () => isLoading(false)
     );
   }

   filter(String num){

     delayedOrders.value = List<PolmanOrder>.from(allDelayedOrders.where((element) => element.customerName!.contains(num)).toList());

   }
   getDeliver(int id ,int deliverId) async {
     isLoading(true);
     final request = DeliverRequestDto(
       id: id,
       createdBy: deliverId
     );
     DeliveryRepository().getdeliver(request,
         onSuccess: (data) {
           getActiveOrders();
           showPopupText( "تم البدء ");
         },
         onError: (e) => showPopupText( e.toString()),
         onComplete: () => isLoading(false)
     );
   }   getFinishDeliver(int id) async {
     isLoading(true);
     final request = DeliverFinishRequestDto(
       id: id,
     );
     DeliveryRepository().getFinishdeliver(request,
         onSuccess: (data) {
           getDeliveredOrders();
           showPopupText( "تم الانتهاء ");
         },
         onError: (e) => showPopupText( e.toString()),
         onComplete: () => isLoading(false)
     );
   }

}
