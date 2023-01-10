part of 'drawer_search_bloc.dart';

class DrawerSearchState extends Equatable {
  final bool isFetching;
  final List<SubredditResponse>? children;
  final ErrorResponse? error;

  const DrawerSearchState({
    this.isFetching = false,
    this.children,
    this.error,
  });

  @override
  List<Object?> get props => [isFetching, children, error];

  DrawerSearchState copyWith({
    bool? isFetching,
    List<SubredditResponse>? children,
    ErrorResponse? error,
  }) {
    return DrawerSearchState(
      isFetching: isFetching ?? this.isFetching,
      children: children,
      error: error ?? this.error,
    );
  }
}
