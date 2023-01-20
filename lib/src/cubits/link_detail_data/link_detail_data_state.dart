// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'link_detail_data_cubit.dart';

class LinkDetailDataState extends Equatable {
  final bool isFetching;
  final LinkDetailResponse? linkDetailData;
  final ErrorResponse? error;
  const LinkDetailDataState({
    this.linkDetailData,
    this.error,
    this.isFetching = true,
  });

  @override
  List<Object?> get props => [linkDetailData, error, isFetching];

  LinkDetailDataState copyWith({
    bool? isFetching,
    LinkDetailResponse? linkDetailData,
    ErrorResponse? error,
  }) {
    return LinkDetailDataState(
      isFetching: isFetching ?? this.isFetching,
      linkDetailData: linkDetailData ?? this.linkDetailData,
      error: error ?? this.error,
    );
  }
}
