import 'package:easy_hotel/app/components/text_field_widget.dart';
import 'package:easy_hotel/app/components/text_widget.dart';
import 'package:easy_hotel/app/core/values/app_assets.dart';
import 'package:easy_hotel/app/core/values/app_colors.dart';
import 'package:easy_hotel/app/core/values/app_constants.dart';
import 'package:easy_hotel/app/core/values/app_strings.dart';
import 'package:easy_hotel/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import '../controllers/all_rooms_page_controller.dart';
import 'widgets/rooms_search_card.dart';



class AllRoomsPageView extends GetView<AllRoomsPageController> {
  const AllRoomsPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    List<String> hobbyList = [] ;

    RangeValues _currentRangeValues = const RangeValues(40, 80);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.appHallsRedDark,
        foregroundColor: Colors.white,
        title:  const  TextFieldWidget(
          enabled: true,
          hint: AppStrings.search,
          suffixIcon: Icons.search,
          ltr: true,
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
         Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.fromLTRB(20.h, 0, 20.h, 0),
                child: TextWidget(AppStrings.towns,textAlign: TextAlign.left,weight: FontWeight.bold,size: 20.h,),
              ),
              SizedBox(
                height: size.height*.8,
                child:
                ListView.builder(
                  itemCount: 10,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return  RoomsCardWidget( type: 1, image: 'https://www.arabiaweddings.com/sites/default/files/articles/2020/02/wedding_venues_in_amman.png', title: 'gggg', subtitle: 'eeee',id:1,onTap:(){Get.toNamed(Routes.ROOM_DETAIL);},);
                  },

                )   ,),
            ],
          ),



        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        backgroundColor: AppColors.appHallsRedDark,
        closeButtonHeroTag: UniqueKey(),
        openButtonHeroTag: UniqueKey(),
        child: const Icon(Icons.filter_list_rounded, color: Colors.white,),
        children: [
          FloatingActionButton.small(
            backgroundColor: AppColors.appHallsRedDark,
            child: const Icon(Icons.filter, color: Colors.white,),
            onPressed: () {
              Widget okButton = TextButton(
                child:const Center(child: TextWidget("بحث",textColor: Colors.white,size: 15,weight: FontWeight.bold,)),
                onPressed: () {
                },
              );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                      builder: (context , setState){
                        return AlertDialog(
                          title: const Center(child: TextWidget("filter")),
                          content: SizedBox(
                            height: size.height*.4,
                            width: size.width,

                            child: Column(
                              children: [
                                for(String add in hobbyList)
                                  Column(
                                    children: [
                                      const TextWidget("add.name!",),
                                    ],
                                  ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child: Container(width: size.width*.82,height: size.height*.2,
                                    decoration:const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.white),
                                    child: Row(
                                      children: [
                                        Container(width: size.width*.3,
                                          height: size.height*.2,
                                          child: Center(
                                            child: GestureDetector(onTap: (){
                                            },
                                              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                 const TextWidget('من سعر'),
                                                  TextWidget(_currentRangeValues.start.round().toString()),
                                                  const TextWidget(AppStrings.LE),

                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                        ,Container(
                                          width: size.width*.005,
                                          height: size.height*.18,
                                          color: Colors.black,

                                        ),
                                        SizedBox(width: size.width*.3,
                                          height: size.height*2,
                                          child: Center(
                                            child: GestureDetector(onTap: (){
                                            },
                                              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const TextWidget('الي سعر',),
                                                  Text(_currentRangeValues.end.round().toString(),),
                                                  const TextWidget(AppStrings.LE),

                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                RangeSlider(
                                  values: _currentRangeValues,
                                  max: 100,
                                  divisions: 100,
                                  labels: RangeLabels(
                                    _currentRangeValues.start.round().toString(),
                                    _currentRangeValues.end.round().toString(),
                                  ),
                                  onChanged: (RangeValues values) {
                                    setState(() {
                                      _currentRangeValues = values;
                                    });
                                  },
                                ),




                              ],
                            ),
                          ),
                          actions: [
                            Center(
                              child: Container(
                                  height: size.height*.06,
                                  width: size.width*.4,
                                  decoration:const  BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(6.00)),
                                    color: Colors.blueAccent,
                                  ),
                                  child: okButton),
                            ),
                          ],
                        );
                      });
                },
              );
            },
          ),
          FloatingActionButton.small(
            backgroundColor: AppColors.appHallsRedDark,
            child: const Icon(Icons.sort, color: Colors.white,),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}