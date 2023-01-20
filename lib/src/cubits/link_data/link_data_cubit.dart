import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'link_data_state.dart';

class LinkDataCubit extends Cubit<LinkDataState> {
  LinkDataCubit() : super(const LinkDataState());
}
