import 'package:bottom_nav_screens/modules/bottom_nav_screens/new_tasks/remainder_cubit/task_alarm_notification_helper.dart';
import 'package:bottom_nav_screens/shared/cubit/app_cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

Widget defaultButton({
  Color buttonColor = Colors.cyanAccent,
  double height = 30,
  double width = double.infinity,
  @required String text,
  @required Function function,
  TextStyle textStyle = const TextStyle(
      color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
  double radius = 0,
}) =>
    Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: buttonColor,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );

Widget defaultTextFormField({
  bool enabled = true,
  Function onTab,
  Function onChange,
  Function onSubmited,
  @required String hintText,
  String labelText,
  @required IconData prefixIcon,
  Widget suffixIcon,
  Color textColor,
  Color hintColor,
  Color prefixIconColor = Colors.grey,
  Color suffixIconColor = Colors.grey,
  TextStyle hintStyle,
  TextStyle textStyle,
  TextEditingController controller,
  Function validatorFunction,
  double borderRadius = 0,
  Color borderColor = Colors.grey,
  double borderSize = 1,
  bool hidden = false,
  TextInputAction textInputAction,
  TextInputType textInputType,
  bool autoCorrect = false,
  int maxLines = 1,
  TextDirection textDirection = TextDirection.LTR,
  TextAlignVertical textAlignVertical = TextAlignVertical.center,
  TextAlign textAlign = TextAlign.left,
  Key textFieldKey,
  Color cursorColor,
  int maxLength,
  double height = 60,
  bool isDense = false,
  contentPadding = const EdgeInsets.symmetric(vertical: 10),
}) =>
    Container(
      height: height,
      child: TextFormField(
        textAlign: textAlign,
        textAlignVertical: textAlignVertical,
        // textDirection: textDirection,
        autocorrect: autoCorrect,
        maxLines: maxLines,
        key: textFieldKey,
        cursorColor: cursorColor,
        maxLength: maxLength,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        enabled: enabled,
        obscureText: hidden,
        style: textStyle,
        controller: controller,
        validator: validatorFunction,
        onTap: onTab,
        onChanged: onChange,
        onFieldSubmitted: onSubmited,
        decoration: InputDecoration(
          errorStyle: const TextStyle(fontSize: 0.01),
          // contentPadding: EdgeInsets.symmetric(vertical: 10),
          labelText: labelText,
          isDense: isDense,
          hintText: hintText,
          hintStyle: hintStyle,
          prefixIcon: Icon(
            prefixIcon,
            color: prefixIconColor,
          ),
          suffix: suffixIcon,

          border: OutlineInputBorder(
            borderSide: BorderSide(width: borderSize, color: borderColor),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: borderSize, color: borderColor),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: borderSize, color: borderColor),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );

buildDefaultNewTaskWidget(Map tasks, BuildContext context, String status,
    {taskBackgroundColor=Colors.grey}) {
  AppCubit.get(context).chekStartingWithArabic(tasks["title"]);
  print("Start is: ${AppCubit.get(context).isStartWithArabic}");
  return GestureDetector(
    onTap: () {
      AppCubit.get(context).viewMore();
    },
    child: Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 8, top: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            CircleAvatar(
              radius: 42,
              backgroundColor: taskBackgroundColor,
              child: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  "${tasks["time"]}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                radius: 38,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: AppCubit.get(context).isStartWithArabic
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      "${tasks["title"]}",
                      maxLines: AppCubit.get(context).maxLines,
                      textAlign: AppCubit.get(context).isStartWithArabic
                          ? TextAlign.right
                          : TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${tasks["date"]}",
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              icon: Icon(
                Icons.check_box,
                color: status == "done tasks" ? Colors.cyan : Colors.black45,
              ),
              onPressed: () {
                AppCubit.get(context)
                    .updateInDB(status: "done tasks", id: tasks["id"]);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.archive,
                color:
                    status == "archived Tasks" ? Colors.cyan : Colors.black45,
              ),
              onPressed: () {
                AppCubit.get(context)
                    .updateInDB(status: "archived Tasks", id: tasks["id"]);
              },
            ),
          ],
        ),
      ),
    ),
  );
}
LocalNotificationService service;
buildDefaultTasksScreen(
    {List<Map> listOfTasks, String status,Color taskBackgroundColor=Colors.grey}) {

  print("ListOFTasks $listOfTasks");
  return ConditionalBuilder(
    condition: listOfTasks.length > 0,
    builder: (context) => Container(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) => Dismissible(
          key: UniqueKey(),
          child: buildDefaultNewTaskWidget(
                  listOfTasks[index], context, listOfTasks[index]["status"],
                  taskBackgroundColor: taskBackgroundColor,),
          onDismissed: (direction) {
            showToast(
                message:
                    "Task (${listOfTasks[index]["title"].length > 10 ? listOfTasks[index]["title"].toString().substring(0, 10) + "...." : listOfTasks[index]["title"]}) Deleted Successfully");
            AppCubit.get(context).deleteFromDB(id: listOfTasks[index]['id']);
            service.cancelScheduledNotification(AppCubit.get(context).notificationsId["id"]);
          },
        ),
        itemCount: listOfTasks.length,
      ),
    ),
    fallback: (context) => Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_emotions_outlined,
            size: 50,
          ),
          Text(
            "There were not any $status...",
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    ),
  );
}

doNamedNavigation(BuildContext context, String routeName) =>
    Navigator.pushNamed(context, routeName);

doWidgetNavigation(BuildContext context, Widget screen) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));

doReplacementWidgetNavigation(BuildContext context, Widget screen) =>
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => screen));

enum SnackBarStates { SUCCESS, ERROR, WARNING }

Color chooseSnackBarColor(SnackBarStates states) {
  Color color;
  switch (states) {
    case SnackBarStates.ERROR:
      color = Colors.red;
      break;
    case SnackBarStates.WARNING:
      color = Colors.amber;
      break;
    case SnackBarStates.SUCCESS:
      color = Colors.green;
      break;
  }
  return color;
}

showSnackBar({
  @required BuildContext context,
  @required String message,
  @required SnackBarStates states,
  int seconds = 2,
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    duration: Duration(seconds: seconds),
    backgroundColor: chooseSnackBarColor(states),
  ));
}

showToast({
  String message = "Empty Message",
  Color textColor = Colors.white,
  Color backgroundColor = Colors.green,
  Toast toastLength = Toast.LENGTH_SHORT,
  ToastGravity toastGravity = ToastGravity.BOTTOM,
  fontSize = 16.0,
}) {
  return Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: toastGravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize);
}
