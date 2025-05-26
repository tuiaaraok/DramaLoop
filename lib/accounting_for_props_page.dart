import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_4/provider/them_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_application_4/hive/hive_boxes.dart';
import 'package:flutter_application_4/hive/model/pods_model.dart';
import 'add_pods_page.dart';

class AccountingForPropsPage extends StatefulWidget {
  const AccountingForPropsPage({super.key});

  @override
  State<AccountingForPropsPage> createState() => _AccountingForPropsPageState();
}

class _AccountingForPropsPageState extends State<AccountingForPropsPage> {
  late Box<PodsModel> podsBox;

  @override
  void initState() {
    super.initState();
    podsBox = Hive.box<PodsModel>(HiveBoxes.podsModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: 336.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: 36.w,
                          color:
                              context.watch<ThemeProvider>().isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                      Text(
                        "Accounting for props",
                        style: GoogleFonts.roboto(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color:
                              context.watch<ThemeProvider>().isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => AddPodsPage(
                                    existingProps:
                                        podsBox.values
                                            .map((e) => e.nameOfTheProps)
                                            .toList(),
                                  ),
                            ),
                          ).then((value) {
                            setState(() {}); // Refresh after adding or editing
                          });
                        },
                        child: Icon(Icons.add, size: 36.w),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 22.h),
                ValueListenableBuilder(
                  valueListenable: podsBox.listenable(),
                  builder: (context, Box<PodsModel> box, _) {
                    return Column(
                      children:
                          box.values
                              .map((item) => _buildPropsItem(item))
                              .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPropsItem(PodsModel item) {
    return Container(
      padding: EdgeInsets.only(top: 8.h, bottom: 9.h, left: 6.w, right: 10.w),
      margin: EdgeInsets.only(bottom: 14.h),
      width: 306.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17.r,
            backgroundColor: const Color(0xFFA17CFF).withValues(alpha: 0.22),
            child: Center(
              child: Image.asset(getImage(item.status), width: 25.w),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.w, right: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nameOfTheProps,
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    item.status,
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _editPropsItem(item);
                },
                child: SvgPicture.asset("assets/icons/redact.svg"),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () {
                  _deletePropsItem(item);
                },
                child: SvgPicture.asset("assets/icons/delete.svg"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  getImage(String url) {
    switch (url) {
      case "In stock":
        return "assets/icons/in_stock.png";
      case "For rent":
        return "assets/icons/rent.png";
      case "Repairs required":
        return "assets/icons/repairs_required.png";
    }
  }

  void _editPropsItem(PodsModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AddPodsPage(
              itemToEdit: item,
              existingProps:
                  podsBox.values.map((e) => e.nameOfTheProps).toList(),
            ),
      ),
    ).then((value) {
      setState(() {}); // Refresh after editing
    });
  }

  void _deletePropsItem(PodsModel item) {
    //Find the index of the item you are deleting
    int index = podsBox.values.toList().indexOf(item);
    if (index != -1) {
      podsBox.deleteAt(index);
    } else {
      log(
        "Error: Item to delete not found in Hive box.",
      ); // Handle the error appropriately
    }
    setState(() {}); // Refresh after deleting
  }
}
