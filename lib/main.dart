import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:presupresto/blocs/Login/login_bloc.dart';
import 'package:presupresto/blocs/Login/login_event.dart';
import 'package:presupresto/repositories/user_repository.dart';
import 'package:presupresto/services/auth_service.dart';
import 'package:presupresto/ui/pages/budget_view.dart';
import 'package:presupresto/ui/pages/dashboard_view.dart';
import 'package:presupresto/ui/pages/history_view.dart';
import 'package:presupresto/ui/pages/home_view.dart';
import 'package:presupresto/ui/pages/login_view.dart';
import 'package:presupresto/ui/pages/signup_view.dart';
import 'package:presupresto/ui/pages/start_view.dart';
import 'package:presupresto/ui/pages/transaction_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final remoteUrl = 'https://api-express-holy-cloud-5609.fly.dev/api/v1';
  final localUrl = 'http://10.0.2.2:3000/api/v1';
  final baseUrl = localUrl;
  final authService = AuthService(baseUrl: baseUrl);
  final authRepo = AuthRepository(authService);

  runApp(
    BlocProvider(
      create: (_) {
        final bloc = AuthBloc(authRepo);
        bloc.add(AppStarted());
        return bloc;
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Presupresto',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.green, // o Colors.green[800]
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
        ),
      ),
      initialRoute: AppRoutes.start,
      routes: {
        '/': (context) => const HomeView(),
        AppRoutes.start: (context) => const StartView(),
        AppRoutes.home: (context) => const HomeView(),
        AppRoutes.dashboard: (context) => const DashboardView(),
        AppRoutes.transacciones: (context) => const TransactionView(),
        AppRoutes.presupuestos: (context) => const BudgetView(),
        AppRoutes.historico: (context) => const HistoryView(),
        AppRoutes.login: (context) =>
            const LoginView(), // TODO: Replace with LoginView
        AppRoutes.signup: (context) =>
            const SignupView(), // TODO: Replace with SignupView
      },
      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (_) => const DashboardView()),
    );
  }
}
