import 'package:presupresto/models/dashboard.dart';
import 'package:presupresto/services/dashboard_service.dart';

class DashboardRepository {
  final DashBoardService _dashboardService;

  DashboardRepository({required DashBoardService dashboardService})
      : _dashboardService = dashboardService;

  Future<Dashboard> getDashboardData(
      String? token, Map<String, dynamic> filter) async {
    try {
      return await _dashboardService.getDashboardData(token!, filter);
    } catch (e) {
      // Log error if needed
      rethrow;
    }
  }
}
