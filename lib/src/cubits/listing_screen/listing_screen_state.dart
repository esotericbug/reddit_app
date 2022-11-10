// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'listing_screen_cubit.dart';

class ListingScreenState extends Equatable {
  final bool floatingButtonVisible;
  final double scrollPosition;
  const ListingScreenState({this.floatingButtonVisible = false, this.scrollPosition = 0});

  @override
  List<Object> get props => [floatingButtonVisible, scrollPosition];

  ListingScreenState copyWith({
    bool? floatingButtonVisible,
    double? scrollPosition,
  }) {
    return ListingScreenState(
      floatingButtonVisible: floatingButtonVisible ?? this.floatingButtonVisible,
      scrollPosition: scrollPosition ?? this.scrollPosition,
    );
  }
}
