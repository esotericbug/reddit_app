// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'listing_screen_cubit.dart';

class ListingScreenState extends Equatable {
  final bool floatingButtonVisible;
  final double scrollPosition;
  final double sliverAppBarHeight;
  final ScrollDirection lastScrollDirection;
  const ListingScreenState(
      {this.floatingButtonVisible = false,
      this.scrollPosition = 0,
      this.sliverAppBarHeight = 160,
      this.lastScrollDirection = ScrollDirection.forward});

  @override
  List<Object> get props => [floatingButtonVisible, scrollPosition, sliverAppBarHeight, lastScrollDirection];

  ListingScreenState copyWith({
    bool? floatingButtonVisible,
    double? scrollPosition,
    double? sliverAppBarHeight,
    ScrollDirection? lastScrollDirection,
  }) {
    return ListingScreenState(
      floatingButtonVisible: floatingButtonVisible ?? this.floatingButtonVisible,
      scrollPosition: scrollPosition ?? this.scrollPosition,
      sliverAppBarHeight: sliverAppBarHeight ?? this.sliverAppBarHeight,
      lastScrollDirection: lastScrollDirection ?? this.lastScrollDirection,
    );
  }
}
