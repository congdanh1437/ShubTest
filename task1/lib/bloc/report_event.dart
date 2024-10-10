part of 'report_bloc.dart';

@immutable
abstract class ReportEvent {}

class LoadReport extends ReportEvent {}

class FilterReport extends ReportEvent {
  final DateTime startTime;
  final DateTime endTime;

  FilterReport(this.startTime, this.endTime);
}

