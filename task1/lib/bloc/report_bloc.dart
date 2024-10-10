import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:collection';

import '../utils/file_utils.dart';
part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  List<Map<String, dynamic>> allData = [];

  ReportBloc() : super(ReportInitial()) {
    on<LoadReport>((event, emit) async {
      try {
        allData = await readExcelFile();
        emit(ReportLoaded(allData));
      } catch (e) {
        emit(ReportError("Failed to load file"));
      }
    });

    on<FilterReport>((event, emit) {
      List<Map<String, dynamic>> filteredData = allData.where((row) {
        DateTime time = DateTime.parse(row["time_column"]);
        return time.isAfter(event.startTime) && time.isBefore(event.endTime);
      }).toList();
      emit(ReportFiltered(filteredData));
    });
  }
}
