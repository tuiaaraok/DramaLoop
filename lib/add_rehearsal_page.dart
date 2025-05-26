import 'dart:developer';
import 'dart:math' as math;

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/hive/hive_boxes.dart';
import 'package:flutter_application_4/hive/model/rehearsal_model.dart';
import 'package:flutter_application_4/my_text_field.dart';
import 'package:flutter_application_4/provider/them_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class AddRehearsalPage extends StatefulWidget {
  const AddRehearsalPage({super.key});

  @override
  State<AddRehearsalPage> createState() => _AddRehearsalPageState();
}

class _AddRehearsalPageState extends State<AddRehearsalPage> {
  Box<RehearsalModel> rehearsalModel = Hive.box<RehearsalModel>(
    HiveBoxes.rehearsalModel,
  );
  FocusNode descriptionNode = FocusNode();
  String previousText = '';
  TextEditingController nameOfThePerformanceController =
      TextEditingController();
  TextEditingController chooseHallController = TextEditingController();
  List<TextEditingController> membersController = [TextEditingController()];
  late MenuElem nameOfThePerformanceElem;
  late MenuElem chooseHallElem;
  List<MenuElem> membersElem = [];
  final TextEditingController rehearsalDateController = TextEditingController();
  final TextEditingController rehearsalTimeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  // Validation flags
  bool _nameOfThePerformanceValid = true;
  bool _rehearsalDateValid = true;
  bool _rehearsalTimeValid = true;
  bool _chooseHallValid = true;
  final List<bool> _membersValid = [];
  bool _formValid = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    nameOfThePerformanceElem = MenuElem(
      isOpen: false,
      selectedElem: "",
      listElements:
          rehearsalModel.values
              .map((toElement) => toElement.nameOfThePerformance)
              .toSet()
              .toList(),
    );
    chooseHallElem = MenuElem(
      isOpen: false,
      selectedElem: "",
      listElements:
          rehearsalModel.values
              .map((toElement) => toElement.chooseHall)
              .toSet()
              .toList(),
    );

    membersElem.add(
      MenuElem(
        isOpen: false,
        selectedElem: "",

        listElements:
            rehearsalModel.values
                .map((toElement) => toElement.listMembers)
                .expand((members) => members) // Flatten the lists
                .toSet() // Remove duplicates
                .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
          child: LayoutBuilder(
            builder: (context, constraint) {
              return KeyboardActions(
                config: KeyboardActionsConfig(
                  keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
                  nextFocus: false,
                  actions: [KeyboardActionsItem(focusNode: descriptionNode)],
                ),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraint.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          SizedBox(
                            width: 326.w,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: GoogleFonts.roboto(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFFF0000),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 39.w),
                                  child: Text(
                                    "Add rehearsal",
                                    style: GoogleFonts.roboto(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          context
                                                  .watch<ThemeProvider>()
                                                  .isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 25.h),
                          Padding(
                            padding: EdgeInsets.only(bottom: 14.h),
                            child: DropMenuWidget(
                              title: "Name of the performance",
                              menu: nameOfThePerformanceElem,
                              hint: '',
                              controller: nameOfThePerformanceController,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 14.h),
                            child: SizedBox(
                              width: 325.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyTextField.textFieldIcon(
                                    "Rehearsal date",
                                    152.w,
                                    rehearsalDateController,
                                    SvgPicture.asset(
                                      "assets/icons/calendar.svg",
                                    ),
                                    context,
                                    keyboard: TextInputType.datetime,
                                    onChange:
                                        (text) => _validateDate(
                                          text,
                                          rehearsalDateController,
                                        ),
                                  ),
                                  MyTextField.textFieldIcon(
                                    "Rehearsal time",
                                    152.w,
                                    rehearsalTimeController,
                                    SvgPicture.asset("assets/icons/time.svg"),
                                    context,
                                    keyboard: TextInputType.datetime,

                                    onChange: (text) {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 14.h),
                            child: DropMenuWidget(
                              title: "Choose a hall",
                              menu: chooseHallElem,
                              controller: chooseHallController,
                              hint: '',
                            ),
                          ),
                          for (int i = 0; i < membersElem.length; i++) ...[
                            Padding(
                              padding: EdgeInsets.only(bottom: 14.h),
                              child: DropMenuWidget(
                                title: "Members",
                                menu: membersElem[i],
                                hint: '',
                                controller: membersController[i],
                              ),
                            ),
                          ],
                          SizedBox(
                            width: 326.w,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () {
                                  membersElem.add(
                                    MenuElem(
                                      isOpen: false,
                                      selectedElem: "",
                                      listElements:
                                          rehearsalModel.values
                                              .map(
                                                (toElement) =>
                                                    toElement.chooseHall,
                                              )
                                              .toSet()
                                              .toList(),
                                    ),
                                  );
                                  membersController.add(
                                    TextEditingController(),
                                  );
                                  setState(() {});
                                },
                                child: Text(
                                  "+Add Members",
                                  style: GoogleFonts.roboto(
                                    color: Color(0xFF6C4AE5),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 14.h),
                          MyTextField.descriptionTextFieldForm(
                            "Description",
                            326.w,
                            descriptionController,
                            descriptionNode,
                            context,
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.paddingOf(context).bottom,
                              top: 20.h,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _validateForm();
                                if (_formValid) {
                                  _addRehearsal();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Please fill in all required fields correctly.',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },

                              child: Container(
                                width: 362.w,
                                height: 58.h,
                                decoration: BoxDecoration(
                                  color: Color(0xFFA17CFF),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30.r),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Create",
                                    style: GoogleFonts.roboto(
                                      fontSize: 22.sp,
                                      color:
                                          context
                                                  .watch<ThemeProvider>()
                                                  .isDarkMode
                                              ? Colors.black
                                              : Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _validateForm() {
    setState(() {
      _nameOfThePerformanceValid =
          nameOfThePerformanceController.text.isNotEmpty;
      _rehearsalDateValid = rehearsalDateController.text.isNotEmpty;
      _rehearsalTimeValid = rehearsalTimeController.text.isNotEmpty;
      _chooseHallValid = chooseHallController.text.isNotEmpty;

      // Validate members fields
      for (int i = 0; i < membersController.length; i++) {
        if (i < _membersValid.length) {
          _membersValid[i] = membersController[i].text.isNotEmpty;
        }
      }

      // Check overall form validity
      _formValid =
          _nameOfThePerformanceValid &&
          _rehearsalDateValid &&
          _rehearsalTimeValid &&
          _chooseHallValid &&
          _membersValid.every(
            (isValid) => isValid,
          ); // All members fields must be valid
    });
  }

  void _addRehearsal() {
    // Parse the date and time from the text fields
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    DateTime rehearsalDate;
    try {
      rehearsalDate = dateFormat.parse(rehearsalDateController.text);
    } catch (e) {
      // Handle parsing errors, e.g., invalid date format
      log("Error parsing date: $e");
      return; // Exit if date parsing fails
    }

    String rehearsalTime =
        rehearsalTimeController.text; // Time is stored as a string

    // Extract member names from the member controllers
    List<String> memberNames =
        membersController.map((controller) => controller.text).toList();

    // Create a new RehearsalModel instance
    final newRehearsal = RehearsalModel(
      nameOfThePerformance: nameOfThePerformanceController.text,
      date: rehearsalDate,
      time: rehearsalTime,
      chooseHall: chooseHallController.text,
      listMembers: memberNames,
      desription: descriptionController.text,
    );

    // Add the new rehearsal to the Hive box
    rehearsalModel.add(newRehearsal);

    // Clear the form fields
    nameOfThePerformanceController.clear();
    rehearsalDateController.clear();
    rehearsalTimeController.clear();
    chooseHallController.clear();
    for (var controller in membersController) {
      controller.clear();
    }
    descriptionController.clear();

    // Optionally, navigate back to the previous screen or show a success message
    Navigator.pop(context);
  }

  void _validateDate(String text, TextEditingController controller) {
    String sanitizedText = text.replaceAll(RegExp(r'[^0-9]'), '');
    String formattedText = '';

    for (int i = 0; i < sanitizedText.length && i < 8; i++) {
      formattedText += sanitizedText[i];
      if (i == 1 || i == 3) {
        formattedText += '/';
      }
    }

    List<String> parts = formattedText.split('/');
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      int? day = int.tryParse(parts[0]);
      if (day != null && day > 31) {
        formattedText = formattedText.substring(0, 2);
      }
    }
    if (parts.length > 1 && parts[1].isNotEmpty) {
      int? month = int.tryParse(parts[1]);
      if (month != null && month > 12) {
        formattedText = formattedText.substring(0, 2);
      }
    }

    controller.value = TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
    previousText = controller.text;
  }
}

class MenuElem {
  bool isOpen;
  String selectedElem;
  List<String> listElements;

  MenuElem({
    required this.isOpen,
    required this.selectedElem,
    required this.listElements,
  });
}

class DropMenuWidget extends StatefulWidget {
  final String title;
  final MenuElem menu;
  final TextEditingController? controller;
  final String hint;
  final double width;
  final double height;
  final bool useCustomDropdown;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const DropMenuWidget({
    super.key,
    required this.title,
    required this.menu,
    this.controller,
    required this.hint,
    this.width = 325,
    this.height = 40,
    this.useCustomDropdown = false,
    this.focusNode,
    this.keyboardType,
    this.onChanged,
  });

  @override
  State<DropMenuWidget> createState() => _DropMenuWidgetState();
}

class _DropMenuWidgetState extends State<DropMenuWidget> {
  @override
  void initState() {
    super.initState();
    _syncControllerWithMenu();
  }

  @override
  void didUpdateWidget(covariant DropMenuWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.menu.selectedElem != widget.menu.selectedElem) {
      _syncControllerWithMenu();
    }
  }

  void _syncControllerWithMenu() {
    if (widget.controller != null && widget.menu.selectedElem.isNotEmpty) {
      widget.controller!.text = widget.menu.selectedElem;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            color:
                context.watch<ThemeProvider>().isDarkMode
                    ? Colors.white
                    : Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 18.sp,
          ),
        ),
        widget.useCustomDropdown
            ? _buildCustomDropdown()
            : _buildDropdownButton2(),
      ],
    );
  }

  Widget _buildDropdownButton2() {
    return SizedBox(
      height: widget.height.h,
      width: widget.width.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.black, width: 1.w),
        ),
        child:
            widget.controller == null
                ? _buildDefaultDropdown()
                : _buildDropdownWithTextField(),
      ),
    );
  }

  Widget _buildDefaultDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        value:
            widget.menu.selectedElem.isEmpty ? null : widget.menu.selectedElem,
        onChanged: _handleItemSelected,
        onMenuStateChange: _handleMenuStateChange,
        customButton: _buildDropdownContent2(),
        items: _buildMenuItems(),
        dropdownStyleData: _dropdownStyleData(),
        menuItemStyleData: _menuItemStyleData(),
      ),
    );
  }

  Widget _buildDropdownWithTextField() {
    return Row(
      children: [Expanded(child: _buildTextField()), _buildDropdownToggle()],
    );
  }

  Widget _buildTextField() {
    return TextField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 18.sp,
        ),
      ),
      keyboardType: widget.keyboardType,
      cursorColor: Colors.black,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontSize: 18.sp,
      ),
      onChanged: widget.onChanged,
    );
  }

  Widget _buildDropdownToggle() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        value:
            widget.menu.selectedElem.isEmpty ? null : widget.menu.selectedElem,
        onChanged: _handleItemSelected,
        onMenuStateChange: _handleMenuStateChange,
        customButton: _buildDropdownToggleButton2(),
        items: _buildMenuItems(),
        dropdownStyleData: _dropdownStyleData(),
        menuItemStyleData: _menuItemStyleData(),
      ),
    );
  }

  Widget _buildCustomDropdown() {
    return SizedBox(
      width: widget.width.w,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.black, width: 1.w),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: widget.menu.listElements.isEmpty ? 13.h : 0,
          ),
          child:
              widget.menu.isOpen ? _buildExpandedMenu() : _buildCollapsedMenu(),
        ),
      ),
    );
  }

  Widget _buildExpandedMenu() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.menu.listElements.map(_buildMenuItem).toList(),
        ),
        Positioned(right: 0.w, top: 0.h, child: _buildDropdownToggleButton()),
      ],
    );
  }

  Widget _buildCollapsedMenu() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child:
                widget.controller != null
                    ? _buildTextField()
                    : GestureDetector(
                      onTap: _toggleMenu,
                      child: Text(
                        widget.menu.selectedElem.isEmpty
                            ? widget.hint
                            : widget.menu.selectedElem,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
          ),
        ),
        _buildDropdownToggleButton(),
      ],
    );
  }

  Widget _buildDropdownContent2() {
    return Row(
      children: [
        Expanded(
          child:
              widget.controller != null
                  ? _buildTextField()
                  : Text(
                    widget.menu.selectedElem.isEmpty
                        ? widget.hint
                        : widget.menu.selectedElem,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 18.sp,
                    ),
                  ),
        ),
        _buildDropdownToggleButton2(),
      ],
    );
  }

  Widget _buildDropdownToggleButton() {
    return IconButton(
      onPressed: _toggleMenu,
      icon: Transform.rotate(
        angle: widget.menu.isOpen ? math.pi : 0,
        child: SvgPicture.asset("assets/icons/arrow-down.svg", width: 24.w),
      ),
    );
  }

  Widget _buildDropdownToggleButton2() {
    return Transform.rotate(
      angle: widget.menu.isOpen ? math.pi : 0,
      child: SvgPicture.asset("assets/icons/arrow-down.svg", width: 24.w),
    );
  }

  Widget _buildMenuItem(String element) {
    return GestureDetector(
      onTap: () => _handleItemSelected(element),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Text(
          element,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }

  void _handleItemSelected(String? value) {
    if (value == null) return;

    setState(() {
      widget.menu
        ..selectedElem = value
        ..isOpen = false;

      if (widget.controller != null) {
        widget.controller!.text = value;
      }
      widget.onChanged?.call(value);
    });
  }

  void _handleMenuStateChange(bool isOpen) =>
      setState(() => widget.menu.isOpen = isOpen);

  void _toggleMenu() =>
      setState(() => widget.menu.isOpen = !widget.menu.isOpen);

  List<DropdownMenuItem<String>> _buildMenuItems() {
    return widget.menu.listElements
        .map(
          (item) => DropdownMenuItem(
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
          ),
        )
        .toList();
  }

  DropdownStyleData _dropdownStyleData() {
    return DropdownStyleData(
      width: 361.w,
      maxHeight: 300.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      offset: Offset(-15.w, 0),
    );
  }

  MenuItemStyleData _menuItemStyleData() {
    return MenuItemStyleData(
      customHeights: List.filled(widget.menu.listElements.length, 50.h),
      padding: EdgeInsets.only(top: 5.h, left: 10.w, right: 10.w),
    );
  }
}
