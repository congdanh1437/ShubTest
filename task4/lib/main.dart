// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/data_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Query Processor',
      home: BlocProvider(
        create: (context) => DataBloc()..add(FetchDataEvent()),
        child: QueryScreen(),
      ),
    );
  }
}

class QueryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Query Processor')),
      body: BlocBuilder<DataBloc, DataState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.error != null) {
            return Center(child: Text(state.error!));
          } else if (state.results != null) {
            return ListView.builder(
              itemCount: state.results!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Result ${index + 1}: ${state.results![index]}'),
                );
              },
            );
          }
          return Center(child: Text('No results'));
        },
      ),
    );
  }
}
