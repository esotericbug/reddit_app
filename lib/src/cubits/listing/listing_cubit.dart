import 'dart:async';
import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:reddit_app/src/helpers/general.dart';
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

Future<Metadata?> computeMeta(String? url) async {
  return await compute<String, Metadata?>(MetadataFetch.extract, '$url');
}

class RequiredArgs {
  late final SendPort sendPort;
  late String url;

  RequiredArgs(this.url, this.sendPort);
}

entryPoint(RequiredArgs data) async {
  final metadata = await MetadataFetch.extract(data.url);
  data.sendPort.send(metadata);
}

Future<Metadata?> fetchMeta(String? url) async {
  final completer = Completer<Metadata?>();
  final recievePort = ReceivePort(); //creating new port to listen data
  RequiredArgs requiredArgs = RequiredArgs('$url', recievePort.sendPort);
  final isolate =
      await Isolate.spawn<RequiredArgs>(entryPoint, requiredArgs); //spawing/creating new thread as isolates.

  late StreamSubscription subscription;

  subscription = recievePort.listen((value) {
    final val = value as Metadata?;
    isolate.kill(priority: Isolate.immediate);
    recievePort.close();
    subscription.cancel();
    completer.complete(val);
  });

  return completer.future;
}
