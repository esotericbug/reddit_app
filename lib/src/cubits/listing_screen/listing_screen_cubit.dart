import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';

part 'listing_screen_state.dart';

class ListingScreenCubit extends Cubit<ListingScreenState> {
  ListingScreenCubit() : super(const ListingScreenState());

  void updateFloatingVisibility(bool value) {
    if (isClosed) return;
    emit(state.copyWith(floatingButtonVisible: value));
  }

  void updateScrollPosition(double value) {
    if (isClosed) return;
    emit(state.copyWith(scrollPosition: value));
  }

  void updateSliverAppBarHeight(double value) {
    if (isClosed) return;
    emit(state.copyWith(sliverAppBarHeight: value));
  }

  void updateScrollDirection(ScrollDirection value) {
    if (isClosed) return;
    emit(state.copyWith(lastScrollDirection: value));
  }
}
