import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_dashboard_movies_usecase.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitialState extends DashboardState {
  const DashboardInitialState();
}

class DashboardLoadingState extends DashboardState {
  const DashboardLoadingState();
}

class DashboardLoadedState extends DashboardState {
  final DashboardData data;

  const DashboardLoadedState({required this.data});

  @override
  List<Object?> get props => [data];
}

class DashboardErrorState extends DashboardState {
  final String message;

  const DashboardErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
