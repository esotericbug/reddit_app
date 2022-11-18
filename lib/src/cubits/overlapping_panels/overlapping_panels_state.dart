// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'overlapping_panels_cubit.dart';

class OverlappingPanelsCubitState extends Equatable {
  final double translate;
  final DragDirection direction;
  final bool isDragging;
  const OverlappingPanelsCubitState({this.translate = 0, this.direction = DragDirection.left, this.isDragging = false});

  @override
  List<Object> get props => [translate, direction, isDragging];

  OverlappingPanelsCubitState copyWith({
    double? translate,
    DragDirection? direction,
    bool? isDragging,
  }) {
    return OverlappingPanelsCubitState(
      translate: translate ?? this.translate,
      direction: direction ?? this.direction,
      isDragging: isDragging ?? this.isDragging,
    );
  }
}
