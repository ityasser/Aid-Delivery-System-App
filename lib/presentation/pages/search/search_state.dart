import 'package:aid_registry_flutter_app/data/project.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/person.dart';
enum SearchStatus {
  initial,
  searching,
  success,
  notFound,
  error,
}
class SearchState {
  SearchStatus status;
  Person? person;
  List<Project> projects;
  List<Project> selectedProjects;
  String? errorMessage;

  SearchState({
    required this.status,
    this.person,
    required this.projects,
    required this.selectedProjects,
    this.errorMessage,
  });
  SearchState copyWith({
    Person? person,
    List<Project>? projects,
    List<Project>? selectedProjects,
    SearchStatus? status,
    String? errorMessage,
  }) {
    return SearchState(
      person: person ?? this.person,
      projects: projects ?? this.projects,
      selectedProjects: selectedProjects ?? this.selectedProjects,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  factory SearchState.initial() =>
      SearchState(status: SearchStatus.initial,projects: [],selectedProjects:[]);

  factory SearchState.searching() =>
      SearchState(status: SearchStatus.searching,projects: [],selectedProjects:[]);

  factory SearchState.success(Person person,projects,selectedProjects) =>
      SearchState(status: SearchStatus.success, person: person,projects: projects,selectedProjects:selectedProjects);

  factory SearchState.notFound() =>
      SearchState(status: SearchStatus.notFound,projects: [],selectedProjects:[]);

  factory SearchState.error(String msg) =>
      SearchState(status: SearchStatus.error, errorMessage: msg,projects: [],selectedProjects:[]);
}
