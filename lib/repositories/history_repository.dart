import 'package:presupresto/models/History.dart';

import '../services/history_service.dart';

class HistoryRepository {
  final HistoryService historyService;

  HistoryRepository({required this.historyService});

  Future<History> getHistory(
      String userId, DateTime startDate, DateTime endDate) async {
    return await historyService.getHistory(userId, {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    });
  }
}
