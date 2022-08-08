import 'dart:math';

import 'package:bottom_nav_screens/modules/bottom_nav_screens/archived_tasks/archived_tasks.dart';
import 'package:bottom_nav_screens/modules/bottom_nav_screens/new_tasks/new_tasks.dart';
import 'package:bottom_nav_screens/shared/cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../modules/bottom_nav_screens/done_tasks/done_tasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStates());

  static AppCubit get(BuildContext context) =>
      BlocProvider.of<AppCubit>(context);

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  String tableName = "tasks";
  int indexOfPage = 0;
  List<String> bottomBarTitles = ["New Tasks", "Done Tasks", "Archived Tasks"];
  List<Widget> bottomBarPages = [NewTasks(), DoneTasks(), ArchivedTasks()];
  Database database;
  IconData iconData = Icons.add;
  bool bottomSheetOpened = false;

  changeScreenIndex(int index) {
    indexOfPage = index;
    print("Index of page : $indexOfPage");
    emit(AppChangeBottomNavIndexStates());
  }

  changeIconBottomSheet({
    @required bool bottomSheetOpened,
    @required IconData iconData,
  }) {
    this.bottomSheetOpened = bottomSheetOpened;
    this.iconData = iconData;
    // print("Opened changed to ${this.bottomSheetOpened}");
    // print("Icon changed to ${this.iconData}");
    emit(ChangeIconBottomSheetStates());
  }

  void createDB() {
    openDatabase(
      "myRev.db",
      version: 1,
      onCreate: (db, version) {
        db
            .execute(
                "CREATE TABLE $tableName (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)")
            .then((value) => print("Database Successfully Created"))
            .onError((error, stackTrace) =>
                print("Database Error Creation ${error.toString()}"));
      },
      onOpen: (db) {
        getDataFromDB(db);
        print("Database Opened");
      },
    ).then((value) {
      database = value;
      emit(AppCreateDataBaseStates());
    });
  }

  void insertInDB({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    await database
        .transaction((txn) => txn
                .rawInsert(
                    "INSERT INTO $tableName (title ,date ,time ,status) VALUES ('$title','$date','$time','new task') ")
                .then((value) => {
                      // print(
                      //     "Row $value successfully added ==> title: $title date: $date time: $time"),
                      emit(AppInsertInDataBaseStates())
                    })
                .catchError((error, stackTrace) {
              print("Error while inserting a Row Error :${error.toString()}");
            }))
        .then((value) {
      getDataFromDB(database);
    });
  }

  void updateInDB({
    @required String status,
    @required int id,
  }) async {
    await database.transaction((txn) => txn.rawUpdate(
          'UPDATE $tableName SET status = ? WHERE id = ?',
          ['$status', id],
        ).then((value) => {
              // print("Row $value successfully Updated ==> taskType: $status"),
              getDataFromDB(database),
              emit(AppUpdateInDataBaseStates())
            }));
  }

  void deleteFromDB({
    @required int id,
  }) async {
    await database
        .transaction((txn) => txn
            .rawDelete('DELETE FROM $tableName WHERE id = ?', ['$id'])
            .then((value) => {
                  // print("Row $value successfully deleted ==> title: $id "),
                  emit(AppDeleteFromDataBaseStates())
                })
            .catchError((error, stackTrace) {
              print("Error while deleting a Row Error :${error.toString()}");
            }))
        .then((value) {
      getDataFromDB(database);
    });
  }

  void getDataFromDB(Database db) async {
    newTasks = [];
    archivedTasks = [];
    doneTasks = [];
    emit(AppLoadingState());
    db.rawQuery("SELECT * FROM $tableName").then((value) {
      value.forEach((element) {
        // print(">>>>>>>>>>>>>> $element");
        if (element["status"] == "new task") {
          newTasks.add(element);
        } else if (element["status"] == "done tasks") {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDataBaseStates());
      // print("New Tasks is $newTasks");
      // print("done Tasks is $doneTasks");
      // print("archived Tasks is $archivedTasks");
    });
  }

  bool isStartWithArabic = false;

  chekStartingWithArabic(String text) {
    RegExp regex = RegExp(
        "[\u0600-\u06ff]|[\u0750-\u077f]|[\ufb50-\ufc3f]|[\ufe70-\ufefc]");
    isStartWithArabic = regex.hasMatch(text.substring(0, 1));
    // printMsg("Test Arabic Or Not for $text as start with ${text.substring(0,1)} : $isStartWithArabic");
  }

  int maxLines = 2;

  void viewMore() {
    maxLines = maxLines == 2 ? 100 : 2;
    emit(AppChangeMaxLinesStates());
  }

  int seconds = 0;

  calculateTimeDifferenceBetween(
      {@required DateTime startDate, @required DateTime endDate}) {
    // print("S $startDate");
    // print("E $endDate");

    seconds = endDate.difference(startDate).inSeconds;
    // if (seconds < 60)
    //   return '$seconds second';
    // else if (seconds >= 60 && seconds < 3600)
    //   return '${startDate.difference(endDate).inMinutes.abs()} minute';
    // else if (seconds >= 3600 && seconds < 86400)
    //   return '${startDate.difference(endDate).inHours} hour';
    // else
    //   return '${startDate.difference(endDate).inDays} day';
    // getTaskProgress(seconds);
    emit(AppGetTaskTimeDifferenceStates());
  }

  int getRandomId() {
    var rng = Random();
    int randomInt = 0;
    for (var i = 0; i < 10; i++) {
      {
        randomInt = rng.nextInt(100);
      }
    }
    return randomInt;
  }
  void launchProfile() async {
    Uri uri = Uri.parse('https://github.com/AbdoBarakatDev');
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.inAppWebView,
        webViewConfiguration: const WebViewConfiguration(
            headers: <String, String>{'my_header_key': 'my_header_value'}),
      );
    } else {
      throw 'Could not launch $uri';
    }
  }

}
