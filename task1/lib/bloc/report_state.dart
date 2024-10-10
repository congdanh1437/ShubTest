part of 'report_bloc.dart';

@immutable
abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportLoaded extends ReportState {
  final List<Map<String, dynamic>> reportData;

  ReportLoaded(this.reportData);
}

class ReportFiltered extends ReportState {
  final List<Map<String, dynamic>> filteredData;

  ReportFiltered(this.filteredData);
}

class ReportError extends ReportState {
  final String errorMessage;

  ReportError(this.errorMessage);
}