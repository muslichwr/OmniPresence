part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadStudentDashboard extends DashboardEvent {}

class LoadTeacherDashboard extends DashboardEvent {}

class LoadAdminDashboard extends DashboardEvent {}

class RefreshDashboard extends DashboardEvent {}
