import 'package:bottom_nav_screens/shared/components/components.dart';
import 'package:bottom_nav_screens/shared/cubit/app_cubit.dart';
import 'package:bottom_nav_screens/shared/cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoneTasks extends StatelessWidget {
  static final String id = "Done Tasks";

  @override
  Widget build(BuildContext context) {
    // print("Done Tasks is :  ${AppCubit.get(context).doneTasks}");
    return  BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) => buildDefaultTasksScreen(
            listOfTasks: AppCubit.get(context).doneTasks, status: "Done Tasks",taskBackgroundColor: Colors.green));
  }
}
