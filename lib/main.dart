import 'package:flutter/material.dart';
import 'package:job_scheduler_app/providers/bottom_navigation_provider.dart';
import 'package:job_scheduler_app/providers/grouping_provider.dart';
import 'package:job_scheduler_app/providers/tab_provider.dart';
import 'package:job_scheduler_app/providers/vacancy_provider.dart';
import 'package:job_scheduler_app/screens/bottom_bar/roster_screen.dart';
import 'package:job_scheduler_app/screens/main_screen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TabProvider()),
        ChangeNotifierProvider(create: (context) => VacancyProvider()),
        ChangeNotifierProvider(create: (context) => BottomNavigationProvider()),
        ChangeNotifierProvider(create: (context) => GroupingProvider()),


      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // theme: ThemeData(
      // //  colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      //   useMaterial3: true,
      // ),
      home: const MainScreen(),
    );
  }
}


