import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/ui/navigation/main_navigation.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mainNavigation = MainNavigation();

    return MaterialApp(
      title: "To Do App",
      // home: Scaffold(body: TestGrid()),
      routes: mainNavigation.routes,
      initialRoute: MainNavigationRoutsName.groups,
      onGenerateRoute: mainNavigation.onGenerateRoute,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
    );
  }
}