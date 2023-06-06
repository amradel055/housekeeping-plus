import 'package:easy_hotel/app/core/utils/common.dart';
import 'package:easy_hotel/app/modules/home/controllers/home_controller.dart';
import 'package:easy_hotel/app/modules/home/views/widgets/order_container.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/app_refresh_indecetor.dart';


class ActiveOrdersWidget extends GetView<HomeController> {
  const ActiveOrdersWidget({Key? key})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Common.getSpin(),
        );
      }
      return SizedBox(
          width: size.width,
          child: AppRefreshIndicator(
            onRefresh: () async => await controller.getActiveOrders(),
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.activeOrders.length,
                padding: const EdgeInsets.all(4),
                dragStartBehavior: DragStartBehavior.start,
                itemBuilder: (context, i) {
                  final order = controller.activeOrders[i];
                  return OrderContainer(
                      true,
                      order.roomNum.toString() ?? "",
                      order.roomNum ?? 0,
                      order.roomNum.toString() ?? "",
                      order.customerName ?? "",
                      order.roomNum.toString(),
                      i);
                },
              );
            }),
          ));
    });
  }

}

