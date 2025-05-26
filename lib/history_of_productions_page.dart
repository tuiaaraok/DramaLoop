import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/add_rehearsal_page.dart';
import 'package:flutter_application_4/hive/hive_boxes.dart';
import 'package:flutter_application_4/hive/model/rehearsal_model.dart';
import 'package:flutter_application_4/provider/them_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class HistoryOfProductionsPage extends StatefulWidget {
  const HistoryOfProductionsPage({super.key});

  @override
  State<HistoryOfProductionsPage> createState() =>
      _HistoryOfProductionsPageState();
}

class _HistoryOfProductionsPageState extends State<HistoryOfProductionsPage> {
  TextEditingController searchController = TextEditingController();
  MenuElem menu = MenuElem(
    isOpen: false,
    selectedElem: "",
    listElements: [
      "Name Of The Performance",
      "Date",
      "Choose a hall",
      "List Members",
    ],
  );
  Box<RehearsalModel> rehearsalBox = Hive.box<RehearsalModel>(
    HiveBoxes.rehearsalModel,
  );
  List<RehearsalModel> rehearsals = [];
  List<RehearsalModel> filteredRehearsals = [];

  @override
  void initState() {
    super.initState();
    rehearsals = rehearsalBox.values.toList();
    filteredRehearsals = List.from(
      rehearsals,
    ); // Initialize with all rehearsals
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterRehearsals();
  }

  void _filterRehearsals() {
    String query = searchController.text.toLowerCase();
    String filterType = menu.selectedElem;

    setState(() {
      if (query.isEmpty) {
        // If search query is empty, reset to the original list
        filteredRehearsals = List.from(rehearsals);
      } else {
        filteredRehearsals =
            rehearsals.where((rehearsal) {
              switch (filterType) {
                case "Name Of The Performance":
                  return rehearsal.nameOfThePerformance.toLowerCase().contains(
                    query,
                  );
                case "Date":
                  return DateFormat(
                    'yyyy-MM-dd',
                  ).format(rehearsal.date).toLowerCase().contains(query);
                case "Choose a hall":
                  return rehearsal.chooseHall.toLowerCase().contains(query);
                case "List Members":
                  return rehearsal.listMembers.any(
                    (member) => member.toLowerCase().contains(query),
                  );
                default:
                  // If no filter is selected, search across all fields
                  return rehearsal.nameOfThePerformance.toLowerCase().contains(
                        query,
                      ) ||
                      DateFormat(
                        'yyyy-MM-dd',
                      ).format(rehearsal.date).toLowerCase().contains(query) ||
                      rehearsal.chooseHall.toLowerCase().contains(query) ||
                      rehearsal.listMembers.any(
                        (member) => member.toLowerCase().contains(query),
                      );
              }
            }).toList();
      }
    });
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
                        "History of productions",
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
                Container(
                  height: 40.h,
                  width: 312.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.r)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icons/search.svg"),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: "Search",
                                hintStyle: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                  fontSize: 18.sp,
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              cursorColor: Colors.black,
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: 18.sp,
                              ),
                              // onChanged: (text) { // Moved logic to _onSearchChanged
                              //   _filterRehearsals();
                              // },
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            searchController.clear();
                            _filterRehearsals();
                          },
                          child: SvgPicture.asset("assets/icons/clear.svg"),
                        ),
                        SizedBox(width: 8.w),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            hint: Text(
                              'Select Item',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                menu.selectedElem = value.toString();
                                _filterRehearsals();
                              });
                            },
                            onMenuStateChange: (isOpen) {
                              setState(() {
                                menu.isOpen = isOpen;
                              });
                            },
                            customButton: SvgPicture.asset(
                              "assets/icons/filter.svg",
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
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.sp,
                                          ),
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
                              customHeights: List.filled(
                                menu.listElements.length,
                                50.h,
                              ),
                              padding: EdgeInsets.only(
                                top: 5.h,
                                left: 10.w,
                                right: 10.w,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
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
                      // Use the filtered list here
                      if (filteredRehearsals.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "No rehearsals found.",
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        )
                      else
                        for (var rehearsal in filteredRehearsals) ...[
                          Padding(
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
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.r),
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Color(0xFFF04D23),
                                    radius: 4.r,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 10.w,
                                      right: 14.w,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          DateFormat('dd/MM').format(
                                            rehearsal.date,
                                          ), // Format the date
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                          ),
                        ],
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
}
