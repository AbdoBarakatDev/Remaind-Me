import 'package:bottom_nav_screens/shared/components/components.dart';
import 'package:bottom_nav_screens/shared/cubit/app_cubit.dart';
import 'package:bottom_nav_screens/shared/cubit/app_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewTasks extends StatelessWidget {
  static final String id = "New Tasks";

  @override
  Widget build(BuildContext context) {
    // print("New Tasks is :  ${AppCubit.get(context).newTasks}");
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          // print("New tasks Length: ${AppCubit.get(context).newTasks.length}");
          return buildDefaultTasksScreen(
              listOfTasks: AppCubit.get(context).newTasks, status: "New Tasks");
        });
  }
}
