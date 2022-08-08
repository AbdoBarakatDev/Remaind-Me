import 'package:bottom_nav_screens/layouts/todo_app/home_layout.dart';
import 'package:bottom_nav_screens/modules/bottom_nav_screens/archived_tasks/archived_tasks.dart';
import 'package:bottom_nav_screens/modules/bottom_nav_screens/done_tasks/done_tasks.dart';
import 'package:bottom_nav_screens/modules/bottom_nav_screens/new_tasks/new_tasks.dart';
import 'package:bottom_nav_screens/modules/version_screen/version_screen.dart';
import 'package:bottom_nav_screens/shared/bloc_observer.dart';
import 'package:bottom_nav_screens/shared/cubit/app_cubit.dart';
import 'package:bottom_nav_screens/shared/cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocOverrides.runZoned(
    () {
      runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new MultiProvider(
        providers: [
          BlocProvider<AppCubit>(
            create: (context) => AppCubit()..createDB(),
          ),
        ],
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Remainder App',
              home: HomeLayout(),
              initialRoute: HomeLayout.id,
              routes: {
                ArchivedTasks.id: (context) => ArchivedTasks(),
                NewTasks.id: (context) => NewTasks(),
                DoneTasks.id: (context) => DoneTasks(),
                HomeLayout.id: (context) => HomeLayout(),
                VersionScreen.id: (context) => VersionScreen(),
              },
            );
          },
        ),
      ),
      title: new Text(
        'Remainder Me',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image: new Image.asset('assets/images/remainder_me.png'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      useLoader: false,
      // onClick: () => print("Splash Clicked"),
      // loaderColor: Colors.red
    );
  }
}
