// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:news_app/api/snackbar_api.dart';
import 'package:news_app/api/storage_api.dart';
import 'package:news_app/enum/upload_enum.dart';
import 'package:news_app/main.dart';
import 'package:news_app/models/preferences.dart';
import 'package:news_app/style/box_shadow.dart';
import 'package:news_app/style/colors.dart';
import 'package:news_app/style/text_style.dart';
import 'package:news_app/utils/all_categories.dart';
import 'package:news_app/utils/database_collection.dart';
import 'package:news_app/widget/button.dart';

class ChangePrefference extends StatefulWidget {
  const ChangePrefference({Key? key}) : super(key: key);

  @override
  State<ChangePrefference> createState() => _ChangePrefferenceState();
}

class _ChangePrefferenceState extends State<ChangePrefference> {
  List<Preferences> selectedPreferences = [];
  UploadState uploadState = UploadState.initial;

  Future uploadPreferences() async {
    List prefferece = selectedPreferences.map((e) => e.interest).toList();
    await db
        ?.collection(usersCollection)
        .doc(StorageApi.getUsername())
        .update({"preference": prefferece});
    SnackbarApi()
        .snackbar(context: context, text: "Prefferences Updated Successfully");
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Preference"),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Builder(builder: (context) {
          switch (uploadState) {
            case UploadState.initial:
              return Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      itemCount: allPreferences.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 90,
                          crossAxisCount: size.width > 200
                              ? (size.width / 200).floor()
                              : 1),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (selectedPreferences
                                .contains(allPreferences[index])) {
                              selectedPreferences.remove(allPreferences[index]);
                            } else {
                              selectedPreferences.add(allPreferences[index]);
                            }
                            setState(() {});
                          },
                          child: Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: selectedPreferences
                                        .contains(allPreferences[index])
                                    ? const Color.fromARGB(255, 37, 82, 119)
                                    : Colors.white,
                                boxShadow: containerShadows),
                            margin: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  width: 9,
                                  margin: const EdgeInsets.only(right: 15),
                                  decoration: BoxDecoration(
                                      color: allPreferences[index].color,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10))),
                                ),
                                Expanded(
                                    child: Text(allPreferences[index].interest,
                                        style: sectionHeader2Style.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300,
                                            color: selectedPreferences.contains(
                                                    allPreferences[index])
                                                ? Colors.white
                                                : Colors.black)))
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () async {
                          await uploadPreferences();
                          StorageApi.setPrefference(selectedPreferences);
                        },
                        child: Container(
                          color: buttonColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          alignment: Alignment.center,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Update"),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.arrow_forward)
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );

            case UploadState.uploaded:
              return TweenAnimationBuilder(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(seconds: 1),
                builder: (context, value, child) {
                  return AnimatedOpacity(
                    opacity: value,
                    duration: const Duration(milliseconds: 500),
                    child: AnimatedPositioned(
                        bottom: size.width * value,
                        duration: const Duration(seconds: 1),
                        child: const Text("Change Succefully")),
                  );
                },
              );

            case UploadState.uploading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case UploadState.failed:
              return Center(
                child: Column(
                  children: [
                    const Text("Fail to upload"),
                    Button(text: "Re-try", callback: uploadPreferences)
                  ],
                ),
              );
          }
        }),
      ),
    );
  }
}
