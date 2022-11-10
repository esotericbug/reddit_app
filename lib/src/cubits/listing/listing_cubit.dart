import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:reddit_app/src/helpers/http.dart';
import 'package:reddit_app/src/models/error_response_model.dart';
import 'package:reddit_app/src/models/listing_response_model.dart';

part 'listing_state.dart';

class ListingCubit extends Cubit<ListingState> {
  ListingCubit() : super(const ListingState());

  Future<void> fetchInitial({String subreddit = 'popular'}) async {
    try {
      final rawResponse = await http().get('/r/$subreddit.json', queryParameters: {'count': 25});

      final response = ListingResponse.fromJson(rawResponse.data);
      emit(state.copyWith(
        children: response.data?.children,
        error: null,
        isFetching: false,
        subreddit: subreddit,
        after: response.data?.after,
        before: response.data?.before,
        pages: [response.data?.after],
      ));
    } on DioError catch (e) {
      final errorResponse = ErrorResponse.fromJson(e.response?.data);
      emit(state.copyWith(
        children: null,
        error: errorResponse,
        isFetching: false,
        pages: null,
      ));
    }
  }

  Future<void> fetchMore({String subreddit = 'popular'}) async {
    try {
      // if(state.pages?.last == state.after){

      // }
      final rawResponse =
          await http().get('/r/$subreddit.json', queryParameters: {'count': 25, 'after': state.pages?.last});

      final response = ListingResponse.fromJson(rawResponse.data);
      emit(state.copyWith(
        children: [...?(state.children), ...(response.data?.children ?? [])],
        error: null,
        isFetching: false,
        subreddit: subreddit,
        pages: [response.data?.after],
      ));
    } on DioError catch (e) {
      final errorResponse = ErrorResponse.fromJson(e.response?.data);
      emit(state.copyWith(
        children: null,
        error: errorResponse,
        isFetching: false,
        pages: null,
      ));
    }
  }
}
