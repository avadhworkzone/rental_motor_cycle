abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportLoaded extends ReportState {
  final String selectedFilter;
  final Map<String, List<Map<String, dynamic>>> groupedTransactions;

  ReportLoaded({
    required this.selectedFilter,
    required this.groupedTransactions,
  });
}
