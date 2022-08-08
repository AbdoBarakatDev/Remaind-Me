import 'package:bottom_nav_screens/modules/bottom_nav_screens/new_tasks/remainder_cubit/task_alarm_notification_helper.dart';
import 'package:bottom_nav_screens/modules/version_screen/version_screen.dart';
import 'package:bottom_nav_screens/shared/components/components.dart';
import 'package:bottom_nav_screens/shared/cubit/app_states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../shared/cubit/app_cubit.dart';

class HomeLayout extends StatelessWidget {
  static final String id = "Home Layout";

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  TextStyle _style = TextStyle(fontSize: 20);
  double height;
  String title;
  DateTime date;
  TimeOfDay time;
  AppCubit appCubit;
  BuildContext buildContext;

  LocalNotificationService service;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    service = LocalNotificationService();
    service.initialize();
    // listenToNotification();

    height = MediaQuery.of(context).size.height;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppInsertInDataBaseStates) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        appCubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          drawer: Drawer(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Padding(
              padding: EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.blue,
                        child: CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/images/remainder_me.png"),
                            radius: 50),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "Remainder Me",
                          style: TextStyle(color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(color: Colors.blue),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                      onTap: () {
                        AppCubit.get(context).changeScreenIndex(0);
                      },
                      child: Text(
                        "Home",
                        style: _style,
                      )),
                  Divider(height: 30, indent: 20, endIndent: 30),
                  GestureDetector(
                      onTap: () {
                        AppCubit.get(context).changeScreenIndex(2);
                      },
                      child: Text(
                        "Archived Tasks",
                        style: _style,
                      )),
                  Divider(height: 30, indent: 20, endIndent: 30),
                  GestureDetector(
                      onTap: () {
                        AppCubit.get(context).changeScreenIndex(1);
                      },
                      child: Text(
                        "Done Tasks",
                        style: _style,
                      )),
                  Divider(height: 30, indent: 20, endIndent: 30),
                  GestureDetector(
                      onTap: () {
                        AppCubit.get(context).launchProfile();
                      },
                      child: Text(
                        "About Us",
                        style: _style,
                      )),
                  Divider(height: 30, indent: 20, endIndent: 30),
                  GestureDetector(
                    onTap: () {
                      doWidgetNavigation(context, VersionScreen());
                    },
                    child: Text(
                      "Version 1.0.0",
                      style: _style,
                    ),
                  ),
                  Spacer(),
                  Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text("copyrights©2022-2023"))
                ],
              ),
            ),
          ),
          appBar: AppBar(
            centerTitle: true,
            title: Text(appCubit.bottomBarTitles[appCubit.indexOfPage]),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            child: ConditionalBuilder(
              condition: state is! AppLoadingState,
              builder: (context) =>
                  appCubit.bottomBarPages[appCubit.indexOfPage],
              fallback: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25.0))),
                builder: (context) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Container(
                      color: Colors.white,
                      height: height * 0.40,
                      padding: EdgeInsets.all(10),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: defaultTextFormField(
                                validatorFunction: (String value) {
                                  if (value.isEmpty) {
                                    return "Title must not be empty";
                                  } else {
                                    return null;
                                  }
                                },
                                // textAlign: AppCubit.get(context).isStartWithArabic?TextAlign.right:TextAlign.left,
                                onChange: (String value) {
                                  if (value.isNotEmpty) {
                                    AppCubit.get(context)
                                        .chekStartingWithArabic(value);
                                  }
                                },
                                // textDirection: AppCubit.get(context).isStartWithArabic?TextDirection.RTL:TextDirection.LTR,
                                textDirection: TextDirection.RTL,
                                controller: titleController,
                                hintText: "Task Title",
                                prefixIcon: Icons.title,
                                textInputAction: TextInputAction.next,
                                borderRadius: 10,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  return showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then(
                                    (value) {
                                      time = value;
                                      timeController.text =
                                          value.format(context).toString();
                                    },
                                  ).onError((error, stackTrace) {
                                    print(error);
                                  });
                                },
                                child: defaultTextFormField(
                                  textInputType: TextInputType.datetime,
                                  controller: timeController,
                                  textInputAction: TextInputAction.next,
                                  enabled: false,
                                  validatorFunction: (String value) {
                                    if (value.isEmpty) {
                                      return "Time must not be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  hintText: "Task Time",
                                  prefixIcon: Icons.watch_later_outlined,
                                  borderRadius: 10,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  return showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse("2030-04-14"),
                                  ).then(
                                    (value) {
                                      date = value;
                                      dateController.text = DateFormat.yMMMd()
                                          .format(value)
                                          .toString();
                                    },
                                  ).onError((error, stackTrace) {
                                    print(error);
                                  });
                                },
                                child: defaultTextFormField(
                                  enabled: false,
                                  textInputType: TextInputType.datetime,
                                  textInputAction: TextInputAction.next,
                                  controller: dateController,
                                  validatorFunction: (String value) {
                                    if (value.isEmpty) {
                                      return "Time must not be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  hintText: "Task Date",
                                  prefixIcon: Icons.date_range,
                                  borderRadius: 10,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                OutlinedButton(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"),
                                ),
                                OutlinedButton(
                                  onPressed: () async {
                                    if (formKey.currentState.validate()) {
                                      print("Validated");
                                      formKey.currentState.save();
                                      appCubit.insertInDB(
                                          title: titleController.text.trim(),
                                          time: timeController.text.trim(),
                                          date: dateController.text.trim());
                                      AppCubit.get(context)
                                          .calculateTimeDifferenceBetween(
                                              startDate: DateTime.now(),
                                              endDate: DateTime(
                                                  date.year,
                                                  date.month,
                                                  date.day,
                                                  time.hour,
                                                  time.minute));
                                      // AppCubit.get(context).getTaskProgress(
                                      //     AppCubit.get(context).seconds);
                                      appCubit.changeIconBottomSheet(
                                          bottomSheetOpened: false,
                                          iconData: Icons.edit);

                                      await service.showScheduledNotification(
                                          id: AppCubit.get(context)
                                              .getRandomId(),
                                          title: "Remainder Task",
                                          body:
                                              "Lets begin (${titleController.text})",
                                          seconds:
                                              AppCubit.get(context).seconds).then((value) {

                                      });

                                    }
                                  },
                                  child: Text("Add"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                elevation: 20,
              );
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: appCubit.indexOfPage,
            onTap: (value) {
              appCubit.changeScreenIndex(value);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.menu), label: "New Tasks"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_box), label: "Done Tasks"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive), label: "Archived Tasks"),
            ],
          ),
        );
      },
    );
  }


  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNotificationListener);

  void onNotificationListener(String payload) {
    if (payload != null && payload.isNotEmpty) {
      // print("payload: $payload");
      //   Navigator.push(
      //       buildContext!,
      //       MaterialPageRoute(
      //         builder: (context) => SecondScreen(),
      //       ));
    }
  }

}
