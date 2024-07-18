import 'package:flutter/material.dart';
import 'package:news_app/api/navigation_api.dart';
import 'package:news_app/api/storage_api.dart';
import 'package:news_app/main.dart';
import 'package:news_app/models/preferences.dart';
import 'package:news_app/pages/main_pages.dart';
import 'package:news_app/style/box_shadow.dart';
import 'package:news_app/style/colors.dart';
import 'package:news_app/utils/all_categories.dart';
import 'package:news_app/utils/database_collection.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({Key? key}) : super(key: key);

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  List<Preferences> selectedPreferences = [];

  Future uploadPreferences() async {
    List prefferece = selectedPreferences.map((e) => e.interest).toList();
    await db
        ?.collection(usersCollection)
        .doc(StorageApi.getUsername())
        .update({"preference": prefferece});
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select News Preference"),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: allPreferences.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 90,
                    crossAxisCount:
                        size.width > 200 ? (size.width / 200).floor() : 1),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (selectedPreferences.contains(allPreferences[index])) {
                        selectedPreferences.remove(allPreferences[index]);
                      } else {
                        selectedPreferences.add(allPreferences[index]);
                      }
                      setState(() {});
                    },
                    child: Container(
                      width: 200,
                      height: 20,
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
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: selectedPreferences
                                              .contains(allPreferences[index])
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
                NavigationApi.nextpageParmanent(
                    route: const MainPages(), context: context);
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () async {
                    await uploadPreferences();
                    StorageApi.setPrefference(selectedPreferences);
                    // ignore: use_build_context_synchronously
                    NavigationApi.nextpageParmanent(
                        route: const MainPages(), context: context);
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
                        Text("Next"),
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
        ),
      ),
    );
  }
}
