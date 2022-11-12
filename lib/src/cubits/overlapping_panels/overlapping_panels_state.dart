// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'overlapping_panels_cubit.dart';

class OverlappingPanelsCubitState extends Equatable {
  final double translate;
  final DragDirection direction;
  const OverlappingPanelsCubitState({this.translate = 0, this.direction = DragDirection.none});

  @override
  List<Object> get props => [translate, direction];

  OverlappingPanelsCubitState copyWith({
    double? translate,
    DragDirection? direction,
  }) {
    return OverlappingPanelsCubitState(
      translate: translate ?? this.translate,
      direction: direction ?? this.direction,
    );
  }
}
