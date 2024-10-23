import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scangen/Controller/generator/generator_controller.dart';
import 'package:scangen/Utils/Colors/app_colors.dart';
import 'package:scangen/Utils/Helper/helper_function.dart';
import 'package:scangen/Utils/sizes/app_size.dart';

class BottonSheet extends StatefulWidget {
  const BottonSheet({super.key});

  @override
  State<BottonSheet> createState() => _BottonSheetState();
}

class _BottonSheetState extends State<BottonSheet> {
  final GeneratorController generatorController =
      Get.find<GeneratorController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String initialText;
  late TextEditingController textController;
  final FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    initialText = generatorController.generateUrl.value;
    textController = TextEditingController(text: initialText);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.dark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------Title And TextField----------------------
              const Text(
                "Enter text or URL",
                style: TextStyle(color: AppColors.white),
              ),
              const SizedBox(height: 5),
              Form(
                key: formKey,
                child: TextFormField(
                  controller: textController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    hintText: 'eg: www.scangen.com',
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: Colors.white),
                  maxLines: 6, // Set max lines to 6
                  minLines: 1, // Allow the text field to expand from 1 line
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Text or URL required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: AppSizes.spaceBtwItems),
              // ------------------MOre options Button----------------------
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    !generatorController.menuOpen.value
                        ? InkWell(
                            onTap: () {
                              generatorController.menuOpen.value = true;
                            },
                            child: const Row(
                              children: [
                                Text("More Options"),
                                SizedBox(width: 5),
                                Icon(Icons.arrow_left_outlined)
                              ],
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              generatorController.menuOpen.value = false;
                            },
                            child: const Row(
                              children: [
                                Text("Hide Options"),
                                SizedBox(width: 5),
                                Icon(Icons.arrow_drop_down_outlined)
                              ],
                            ),
                          )
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // -----------------QR Code Style Dropdown----------------------
              Obx(() {
                if (generatorController.menuOpen.value) {
                  return Column(
                    children: [
                      Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("QR Code Style"),
                            const SizedBox(height: 6),
                            Container(
                              height: 40,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: AppColors.secondary),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value:
                                      generatorController.selectedValue.value,
                                  onChanged: (value) {
                                    generatorController.selectedValue.value =
                                        value!;
                                  },
                                  items: generatorController.items
                                      .map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),

                      const SizedBox(height: 10),
                      // ----------------Color Selection Area-----------------
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Foreground Selection
                          Column(
                            children: [
                              const Text("Foreground Color"),
                              const SizedBox(height: 5),
                              InkWell(
                                onTap: () {
                                  HelperFunction.showColorPicker(
                                      context: context,
                                      pickerColor: generatorController
                                          .selectedForegroundColor.value,
                                      title: "Pick Foreground Color",
                                      onColorChanged: (color) =>
                                          generatorController
                                              .onSelectedforegroundColorChange(
                                                  color),
                                      gotIt: () {
                                        generatorController
                                            .foregroundColorChange();
                                        Navigator.of(context).pop();
                                      });
                                },
                                child: Container(
                                  width: 130,
                                  decoration: BoxDecoration(
                                    color: generatorController
                                        .selectedForegroundColor.value, // Here
                                    borderRadius: BorderRadius.circular(5),
                                    border:
                                        Border.all(color: AppColors.secondary),
                                  ),
                                  height: 30,
                                  child: const Center(
                                    child: Text("Select",
                                        style: TextStyle(
                                            color: AppColors.secondary)),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(width: AppSizes.spaceBtwItems),
                          // Background Selection
                          Column(
                            children: [
                              const Text("Background Color"),
                              const SizedBox(height: 5),
                              InkWell(
                                onTap: () => HelperFunction.showColorPicker(
                                    context: context,
                                    pickerColor: generatorController
                                        .selectedBackgroundColor.value,
                                    title: "Pick Foreground Color",
                                    onColorChanged: (color) =>
                                        generatorController
                                            .onSelectedBackgroundColorChange(
                                                color),
                                    gotIt: () {
                                      generatorController
                                          .backgroundColorChange();
                                      Navigator.of(context).pop();
                                    }),
                                child: Container(
                                  width: 130,
                                  decoration: BoxDecoration(
                                    color: generatorController
                                        .selectedBackgroundColor.value, // Here
                                    borderRadius: BorderRadius.circular(5),
                                    border:
                                        Border.all(color: AppColors.secondary),
                                  ),
                                  height: 30,
                                  child: const Center(
                                      child: Text(
                                    "Select",
                                    style:
                                        TextStyle(color: AppColors.secondary),
                                  )),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      // --------------------Warning Note----------------------
                      const Column(
                        children: [
                          Divider(
                            thickness: 2,
                          ),
                          SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.warning_amber,
                                color: Colors.amber,
                                size: 14,
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  "These options are currently in beta. QR codes generated may occasionally not scan properly.",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),

                      const SizedBox(height: 13),
                      // ------------------Pick Image From Gallery---------------------
                      Obx(() => InkWell(
                            onTap: () {
                              generatorController.pickAndStoreImage();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border:
                                      Border.all(color: AppColors.secondary)),
                              child: Center(
                                  child: generatorController
                                              .pickedImage.value ==
                                          null
                                      ? const SizedBox(
                                          height: 20, child: Text("Pick Image"))
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 20,
                                              alignment: Alignment
                                                  .center, // Center the text vertically
                                              child: const Text("Image Picked"),
                                            ),
                                            const SizedBox(width: 5),
                                            SizedBox(
                                              height: 20,
                                              child: IconButton(
                                                onPressed: () {
                                                  generatorController
                                                      .pickedImage.value = null;
                                                },
                                                icon: const Icon(
                                                    color: AppColors.secondary,
                                                    Icons
                                                        .highlight_remove_sharp),
                                                padding: EdgeInsets.zero,
                                              ),
                                            ),
                                          ],
                                        )),
                            ),
                          )),
                      const SizedBox(height: AppSizes.spaceBtwItems),
                      // ------------------Center Image Position----------------------
                      Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Image Position"),
                            const SizedBox(height: 6),
                            Container(
                              height: 40,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: AppColors.secondary),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: generatorController
                                      .selectedImagePostionItem.value,
                                  onChanged: (value) {
                                    generatorController.selectedImagePostionItem
                                        .value = value!;
                                  },
                                  items: generatorController.imagePostionItems
                                      .map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),

                      const SizedBox(height: AppSizes.spaceBtwItems),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              }),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary),
                  onPressed: () {
                    generatorController.generateQR(
                        textController.text, focusNode, context, formKey);
                  },
                  child: Text(
                    "Generate QR Code",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .apply(color: AppColors.white),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spaceBtwItems),
            ],
          ),
        ),
      ),
    );
  }
}
