import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:reddit_app/src/cubits/listing/listing_cubit.dart';
import 'package:reddit_app/src/helpers/http.dart';
import 'package:reddit_app/src/models/error_response_model.dart';
import 'package:reddit_app/src/models/listing_response_model.dart';
import 'package:reddit_app/src/utils/metadata_fetch/metadata_fetch.dart';
import 'package:collection/collection.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchState());

  Future<void> search({String? subreddit, String? query, bool? restrict}) async {
    try {
      final queryUrl = (subreddit == null || subreddit.isEmpty) ? '/search.json' : '/r/$subreddit/search.json';
      final rawResponse = await http().get(queryUrl, queryParameters: {
        'restrict_sr': restrict,
        'q': query ?? '',
      });

      final response = ListingResponse.fromJson(rawResponse.data);
      List<String?> urls = [];
      response.data?.children?.forEach((child) {
        urls.add(child.data?.urlOverriddenByDest);
      });
      final metaDatas = await Future.wait<Metadata?>(urls.map((url) {
        // Dev.log(computeMeta(url));
        return computeMeta(url);
      }).toList());
      final children = response.data?.children?.mapIndexed((index, child) {
        child.data?.linkMeta = metaDatas[index];
        return child;
      }).toList();
      if (isClosed) return;
      emit(state.copyWith(
        children: children,
        error: null,
        isFetching: false,
        subreddit: subreddit,
        after: response.data?.after,
        before: response.data?.before,
        pages: [response.data?.after],
      ));
    } on DioError catch (e) {
      final errorResponse = ErrorResponse.fromJson(e.response?.data);
      if (isClosed) return;
      emit(
        state.copyWith(
          children: null,
          error: errorResponse,
          isFetching: false,
          pages: null,
        ),
      );
    }
  }

  Future<void> fetchMoreSearch({String? subreddit, String? query, bool? restrict}) async {
    try {
      if (isClosed) return;
      emit(state.copyWith(isFetching: true));
      final queryUrl = (subreddit == null || subreddit.isEmpty) ? '/search.json' : '/r/$subreddit/search.json';
      final rawResponse = await http()
          .get(queryUrl, queryParameters: {'restrict_sr': restrict, 'q': query ?? '', 'after': state.pages?.last});
      final response = ListingResponse.fromJson(rawResponse.data);
      List<String?> urls = [];
      response.data?.children?.forEach((child) {
        urls.add(child.data?.urlOverriddenByDest);
      });
      final metaDatas = await Future.wait<Metadata?>(urls.map((url) => computeMeta('$url')));
      final children = response.data?.children?.mapIndexed((index, child) {
        child.data?.linkMeta = metaDatas[index];
        return child;
      }).toList();
      if (isClosed) return;
      emit(state.copyWith(
        children: [...?(state.children), ...?(children)],
        error: null,
        isFetching: false,
        subreddit: subreddit,
        pages: [...?(state.pages), response.data?.after],
      ));
    } on DioError catch (e) {
      final errorResponse = ErrorResponse.fromJson(e.response?.data);
      if (isClosed) return;
      emit(state.copyWith(
        children: null,
        error: errorResponse,
        isFetching: false,
        pages: null,
      ));
    }
  }
}
