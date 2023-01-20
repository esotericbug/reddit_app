import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:reddit_app/src/helpers/http.dart';
import 'package:reddit_app/src/models/error_response_model.dart';
import 'package:reddit_app/src/models/link_data_model.dart';

part 'link_detail_data_state.dart';

class LinkDetailDataCubit extends Cubit<LinkDetailDataState> {
  LinkDetailDataCubit() : super(const LinkDetailDataState());

  Future<void> fetchLinkData({String? subreddit, String? article}) async {
    try {
      final rawResponse = await http().get('/r/$subreddit/comments/$article.json');
      final response = LinkDetailResponse.fromJson(rawResponse.data);
      if (isClosed) return;
      emit(
        state.copyWith(
          linkDetailData: response,
          error: null,
          isFetching: false,
        ),
      );
    } on DioError catch (e) {
      final errorResponse = ErrorResponse.fromJson(e.response?.data);
      if (isClosed) return;
      emit(
        state.copyWith(
          linkDetailData: null,
          error: errorResponse,
          isFetching: false,
        ),
      );
    }
  }
}
