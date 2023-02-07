import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:reddit_app/src/helpers/http.dart';
import 'package:reddit_app/src/models/error_response_model.dart';
import 'package:reddit_app/src/models/search_response_model.dart';

part 'drawer_search_event.dart';
part 'drawer_search_state.dart';

class DrawerSearchBloc extends Bloc<DrawerSearchEvent, DrawerSearchState> {
  DrawerSearchBloc() : super(const DrawerSearchState()) {
    on<DrawerSearchItems>((event, emit) async {
      emit(state.copyWith(isFetching: true));
      if (event.query?.isNotEmpty ?? false) {
        try {
          final rawResponse = await http().get('/api/subreddit_autocomplete_v2.json', queryParameters: {
            'query': event.query ?? '',
            'limit': 10,
            'include_over_18': true,
            'typeahead_active': true,
          });

          final response = SearchResponse.fromJson(rawResponse.data);
          if (isClosed) return;
          emit(state.copyWith(
            children: response.data?.children,
            error: null,
            isFetching: false,
          ));
        } on DioError catch (e) {
          final errorResponse = ErrorResponse.fromJson(e.response?.data);
          if (isClosed) return;
          emit(state.copyWith(
            children: null,
            error: errorResponse,
            isFetching: false,
          ));
        }
      } else {
        emit(
          state.copyWith(
            children: null,
            error: null,
            isFetching: false,
          ),
        );
      }
    }, transformer: restartable());
  }
}
