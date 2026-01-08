import 'package:equatable/equatable.dart';
import '../../models/user.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String token;
  final User? user;
  AuthAuthenticated({required this.token, this.user});
  @override
  List<Object?> get props => [token, user];
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
  @override
  List<Object?> get props => [message];
}
