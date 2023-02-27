// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_cubit.dart';

class SearchState extends Equatable {
  final bool isFetching;
  final List<String?>? pages;
  final List<LinkResponse>? children;
  final String? subreddit;
  final String? after;
  final String? before;
  final ErrorResponse? error;
  const SearchState({
    this.children,
    this.error,
    this.pages,
    this.isFetching = true,
    this.subreddit,
    this.after,
    this.before,
  });

  @override
  List<Object?> get props => [pages, children, error, subreddit, isFetching, after, before];

  SearchState copyWith({
    bool? isFetching,
    List<String?>? pages,
    List<LinkResponse>? children,
    String? subreddit,
    String? after,
    String? before,
    ErrorResponse? error,
  }) {
    return SearchState(
      isFetching: isFetching ?? this.isFetching,
      pages: pages ?? this.pages,
      children: children ?? this.children,
      subreddit: subreddit ?? this.subreddit,
      after: after ?? this.after,
      before: before ?? this.before,
      error: error ?? this.error,
    );
  }
}
