import 'package:bottom_nav_screens/shared/components/components.dart';
import 'package:bottom_nav_screens/shared/cubit/app_cubit.dart';
import 'package:bottom_nav_screens/shared/cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArchivedTasks extends StatelessWidget {
  static final String id = "Archived Tasks";

  @override
  Widget build(BuildContext context) {
    // print("Archived Tasks is :  ${AppCubit.get(context).archivedTasks}");
    // print(
    //     "Archived Tasks length is :  ${AppCubit.get(context).archivedTasks.length}");

    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          print(AppCubit.get(context).archivedTasks);
          return buildDefaultTasksScreen(
              listOfTasks: AppCubit.get(context).archivedTasks,
              status: "Archived Tasks",taskBackgroundColor: Colors.red);
        });
  }
}
