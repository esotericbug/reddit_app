import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reddit_app/src/widgets/overlapping_panels.dart';

part 'overlapping_panels_state.dart';

class OverlappingPanelsCubit extends Cubit<OverlappingPanelsCubitState> {
  OverlappingPanelsCubit() : super(const OverlappingPanelsCubitState());

  updateTranslate(double value) {
    if (isClosed) return;
    emit(state.copyWith(translate: value));
  }

  updateDirection(DragDirection value) {
    if (isClosed) return;
    emit(state.copyWith(direction: value));
  }
}
