import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:reddit_app/src/helpers/http.dart';
import 'package:reddit_app/src/models/error_response_model.dart';
import 'package:reddit_app/src/models/listing_response_model.dart';
import 'package:reddit_app/src/utils/metadata_fetch/metadata_fetch.dart';
import 'package:collection/collection.dart';

part 'listing_state.dart';

class ListingCubit extends Cubit<ListingState> {
  ListingCubit() : super(const ListingState());

  Future<void> fetchInitial({String? subreddit}) async {
    try {
      final rawResponse = await http().get('/r/$subreddit.json', queryParameters: {'count': 25});

      final response = ListingResponse.fromJson(rawResponse.data);
      List<String?> urls = [];
      response.data?.children?.forEach((child) {
        urls.add(child.data?.urlOverriddenByDest);
      });
      final metaDatas = await Future.wait<Metadata?>(urls.map((url) => MetadataFetch.extract('$url')));
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

  Future<void> fetchMore({String? subreddit}) async {
    try {
      if (isClosed) return;
      emit(state.copyWith(isFetching: true));
      final rawResponse =
          await http().get('/r/$subreddit.json', queryParameters: {'count': 25, 'after': state.pages?.last});

      final response = ListingResponse.fromJson(rawResponse.data);
      List<String?> urls = [];
      response.data?.children?.forEach((child) {
        urls.add(child.data?.urlOverriddenByDest);
      });
      final metaDatas = await Future.wait<Metadata?>(urls.map((url) => MetadataFetch.extract('$url')));
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
