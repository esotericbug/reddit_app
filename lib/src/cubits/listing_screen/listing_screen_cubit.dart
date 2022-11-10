import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'listing_screen_state.dart';

class ListingScreenCubit extends Cubit<ListingScreenState> {
  ListingScreenCubit() : super(const ListingScreenState());

  void updateFloatingVisibility(bool value) {
    emit(state.copyWith(floatingButtonVisible: value));
  }

  void updateScrollPosition(double value) {
    emit(state.copyWith(scrollPosition: value));
  }
}
