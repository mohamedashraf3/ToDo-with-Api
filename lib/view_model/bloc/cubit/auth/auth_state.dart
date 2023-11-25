part of 'auth_cubit.dart';
abstract class AuthState {}
class AuthInitial extends AuthState {}
class LoginLoadingState extends AuthState{}
class LoginSuccessState extends AuthState{}
class LoginErrorState extends AuthState{}
class LogoutLoadingState extends AuthState{}
class LogoutSuccessState extends AuthState{}
class LogoutErrorState extends AuthState{}
class RegisterLoadingState extends AuthState{}
class RegisterSuccessState extends AuthState{}
class RegisterErrorState extends AuthState{}
