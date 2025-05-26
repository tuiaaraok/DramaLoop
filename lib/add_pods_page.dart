import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/add_rehearsal_page.dart';
import 'package:flutter_application_4/hive/hive_boxes.dart';
import 'package:flutter_application_4/hive/model/pods_model.dart';
import 'package:flutter_application_4/my_text_field.dart';
import 'package:flutter_application_4/provider/them_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class AddPodsPage extends StatefulWidget {
  final PodsModel? itemToEdit;
  final List<String>? existingProps;

  const AddPodsPage({super.key, this.itemToEdit, this.existingProps});

  @override
  State<AddPodsPage> createState() => _AddPodsPageState();
}

class _AddPodsPageState extends State<AddPodsPage> {
  FocusNode descriptionNode = FocusNode();
  FocusNode quantityNode = FocusNode();
  Box<PodsModel> podsModel = Hive.box<PodsModel>(HiveBoxes.podsModel);
  late MenuElem nameOfThePropsElem;
  TextEditingController nameOfThePropsController = TextEditingController();
  late MenuElem statusElem;
  TextEditingController statusController = TextEditingController();

  final TextEditingController quantityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();

    nameOfThePropsElem = MenuElem(
      isOpen: false,
      selectedElem: widget.itemToEdit?.nameOfTheProps ?? '',
      listElements: widget.existingProps ?? [],
    );
    nameOfThePropsController.text = widget.itemToEdit?.nameOfTheProps ?? '';

    statusElem = MenuElem(
      isOpen: false,
      selectedElem: widget.itemToEdit?.status ?? "In stock",
      listElements: ["In stock", "For rent", "Repairs required"],
    );
    statusController.text = widget.itemToEdit?.status ?? "In stock";

    quantityController.text = widget.itemToEdit?.quantity ?? "";
    descriptionController.text = widget.itemToEdit?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  actions: [
                    KeyboardActionsItem(focusNode: descriptionNode),
                    KeyboardActionsItem(focusNode: quantityNode),
                  ],
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
                                  padding: EdgeInsets.only(left: 50.w),
                                  child: Text(
                                    widget.itemToEdit == null
                                        ? "Add props"
                                        : "Edit props",
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
                              title: "Name of the props",
                              menu: nameOfThePropsElem,
                              hint: '',
                              controller: nameOfThePropsController,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 14.h),
                            child: _buildDropdownSection(
                              title: "Status",
                              menu: statusElem,
                              controller: statusController,
                            ),
                          ),
                          MyTextField.textFieldForm(
                            "Quantity",
                            326.w,
                            context,
                            quantityController,
                            myNode: quantityNode,
                            keyboard: TextInputType.numberWithOptions(),
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
                                if (nameOfThePropsController.text.isNotEmpty &&
                                    statusElem.selectedElem.isNotEmpty &&
                                    quantityController.text.isNotEmpty) {
                                  PodsModel newItem = PodsModel(
                                    nameOfTheProps:
                                        nameOfThePropsController.text,
                                    status: statusElem.selectedElem,
                                    quantity: quantityController.text,
                                    description: descriptionController.text,
                                  );
                                  if (widget.itemToEdit != null) {
                                    int index = podsModel.values
                                        .toList()
                                        .indexOf(widget.itemToEdit!);

                                    if (index != -1) {
                                      // Update the item with the new values
                                      final updatedItem = PodsModel(
                                        nameOfTheProps:
                                            nameOfThePropsController.text,
                                        status: statusElem.selectedElem,
                                        quantity: quantityController.text,
                                        description: descriptionController.text,
                                      );
                                      podsModel.putAt(index, updatedItem);

                                      podsModel.put(
                                        index,
                                        widget.itemToEdit!,
                                      ); // Use put with the key
                                    }
                                  } else {
                                    podsModel.add(newItem);
                                  }
                                  Navigator.pop(context, newItem);
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
                                    widget.itemToEdit == null
                                        ? "Create"
                                        : "Save",
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
      width: 326.w,
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
