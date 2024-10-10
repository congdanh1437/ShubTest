import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/report_bloc.dart'; // If using the Bloc pattern
import 'screen/report_screen.dart'; // Your custom screen with the Scaffold

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Excel Data Report',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => ReportBloc(),
        child: ReportScreen(), // Your screen containing the Scaffold widget
      ),
    );
  }
}
