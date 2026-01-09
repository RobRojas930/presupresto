import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:presupresto/blocs/Login/login_event.dart';
import 'package:presupresto/blocs/Login/login_state.dart';
import 'package:presupresto/repositories/user_repository.dart';
import '../../models/user.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAppStarted(AppStarted _, Emitter<AuthState> emit) async {
    final token = await _storage.read(key: 'token');
    if (token != null) {
      // si guardas user en storage, podrías leerlo; aquí asumimos sólo token
      emit(AuthAuthenticated(token: token));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final data = await repository.login(event.email, event.password);
      final token = data['token'] as String?;
      final user = repository.parseUser(data['data']);
      if (token == null) throw Exception('Token no recibido');
      await _storage.write(key: 'token', value: token);
      emit(AuthAuthenticated(token: token, user: user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignupRequested(
      SignupRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final data =
          await repository.signup(event.name, event.email, event.password);
      final token = data['token'] as String?;
      final user = repository.parseUser(data);
      if (token == null) throw Exception('Token no recibido');
      await _storage.write(key: 'token', value: token);
      emit(AuthAuthenticated(token: token, user: user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested _, Emitter<AuthState> emit) async {
    await _storage.delete(key: 'token');
    emit(AuthUnauthenticated());
  }
}
