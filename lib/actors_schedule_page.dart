import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/add_rehearsal_page.dart';
import 'package:flutter_application_4/provider/them_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive
import 'package:flutter_application_4/hive/hive_boxes.dart'; // Import your HiveBoxes
import 'package:flutter_application_4/hive/model/rehearsal_model.dart'; // Import your RehearsalModel
import 'package:intl/intl.dart'; // Import intl for date formatting

class ActorsSchedulePage extends StatefulWidget {
  const ActorsSchedulePage({super.key});

  @override
  State<ActorsSchedulePage> createState() => _ActorsSchedulePageState();
}

class _ActorsSchedulePageState extends State<ActorsSchedulePage> {
  late MenuElem selectAnActorElem;
  Box<RehearsalModel> rehearsalModel = Hive.box<RehearsalModel>(
    HiveBoxes.rehearsalModel,
  );

  FocusNode searchFocusNode = FocusNode();
  String searchQuery = ''; // Add search query variable
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectAnActorElem = MenuElem(
      isOpen: false,
      selectedElem: '',
      listElements:
          rehearsalModel.values
              .expand(
                (toElement) => toElement.listMembers,
              ) // Use listMembers for dropdown
              .toSet()
              .toList(),
    );
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
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
                        "Actors schedule",
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
                            MaterialPageRoute<void>(
                              builder:
                                  (BuildContext context) =>
                                      const AddRehearsalPage(),
                            ),
                          );
                        },
                        child: Icon(Icons.add, size: 36.w),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 37.h),
                _buildDropdownSection(
                  menu: selectAnActorElem,
                  title: "Select an actor",
                ),

                SizedBox(height: 20.h),
                SizedBox(
                  width: 306.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Schedule",
                        style: GoogleFonts.roboto(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 11.h),
                      _buildScheduleList(), // Build schedule list
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleList() {
    return ValueListenableBuilder(
      valueListenable:
          Hive.box<RehearsalModel>(HiveBoxes.rehearsalModel).listenable(),
      builder: (context, Box<RehearsalModel> box, _) {
        // Filter rehearsals based on search query and selected actor
        final List<RehearsalModel> filteredRehearsals =
            box.values.where((rehearsal) {
              final String actorFilter =
                  selectAnActorElem.selectedElem.toLowerCase();

              final String rehearsalName =
                  rehearsal.nameOfThePerformance.toLowerCase();
              final String hallName = rehearsal.chooseHall.toLowerCase();
              final String rehearsalMembers =
                  rehearsal.listMembers.join(',').toLowerCase();
              final String rehearsalDescription =
                  rehearsal.desription.toLowerCase();

              // Check if the rehearsal matches the search query
              final bool matchesSearch =
                  rehearsalName.contains(searchQuery) ||
                  hallName.contains(searchQuery) ||
                  rehearsalMembers.contains(searchQuery) ||
                  rehearsalDescription.contains(searchQuery) ||
                  DateFormat('dd/MM/yyyy')
                      .format(rehearsal.date)
                      .contains(searchQuery) || // Search by date
                  rehearsal.time.contains(searchQuery); // Search by time

              // Check if the rehearsal is associated with the selected actor (if any)
              final bool matchesActor =
                  actorFilter.isEmpty ||
                  rehearsal.listMembers.any(
                    (member) =>
                        member.toLowerCase() == actorFilter, // Exact match
                  );

              return matchesSearch && matchesActor;
            }).toList();

        return Column(
          children:
              filteredRehearsals
                  .map((rehearsal) => _buildScheduleItem(rehearsal))
                  .toList(),
        );
      },
    );
  }

  Widget _buildScheduleItem(RehearsalModel rehearsal) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Container(
        padding: EdgeInsets.only(
          top: 13.h,
          bottom: 12.h,
          right: 11.w,
          left: 13.6.w,
        ),
        width: 306.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
        ),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: Color(0xFFF04D23), radius: 4.r),
            Padding(
              padding: EdgeInsets.only(left: 10.w, right: 14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rehearsal.time,
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    DateFormat(
                      'dd/MM',
                    ).format(rehearsal.date), // Format the date
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rehearsal.nameOfThePerformance,
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    rehearsal.chooseHall,
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownSection({
    required String title,
    required MenuElem menu,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        _buildDropdown(menu: menu, controller: controller),
      ],
    );
  }

  Widget _buildDropdown({
    required MenuElem menu,
    TextEditingController? controller,
  }) {
    return Container(
      height: 40.h,
      width: 306.w,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.black, width: 1.w),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          onChanged: (value) {
            setState(() {
              if (controller != null) {
                controller.text = value.toString();
              }
              menu.selectedElem = value.toString();
            });
          },
          onMenuStateChange: (isOpen) {
            setState(() {
              menu.isOpen = isOpen;
            });
          },
          customButton: Row(
            children: [
              Expanded(
                child:
                    controller != null
                        ? TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: '',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                              fontSize: 18.sp,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 18.sp,
                          ),
                        )
                        : Text(
                          menu.selectedElem,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
              ),
              Icon(
                menu.isOpen
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 30.h,
              ),
            ],
          ),
          items:
              menu.listElements.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: SizedBox(
                    width: 355.w,
                    height: 50.h,
                    child: Center(
                      child: Text(
                        item,
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      ),
                    ),
                  ),
                );
              }).toList(),
          dropdownStyleData: DropdownStyleData(
            width: 361.w,
            maxHeight: 300.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            offset: Offset(-15.w, 0),
          ),
          menuItemStyleData: MenuItemStyleData(
            customHeights: List.filled(menu.listElements.length, 50.h),
            padding: EdgeInsets.only(top: 5.h, left: 10.w, right: 10.w),
          ),
        ),
      ),
    );
  }
}
