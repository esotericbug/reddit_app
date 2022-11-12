library overlapping_panels;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:core';
import 'package:reddit_app/src/cubits/overlapping_panels/overlapping_panels_cubit.dart';

const double bleedWidth = 20;

const double defaultDrawerWidth = 304;

/// Display sections
enum RevealSide { left, right, main }

enum DragDirection { left, right, none }

/// Widget to display three view panels with the [OverlappingPanels.main] being
/// in the center, [OverlappingPanels.left] and [OverlappingPanels.right] also
/// revealing from their respective sides. Just like you will see in the
/// Discord mobile app's navigation.
class OverlappingPanels extends StatefulWidget {
  /// The left panel
  final Widget? left;

  /// The main panel
  final Widget main;

  /// The right panel
  final Widget? right;

  /// The offset to use to keep the main panel visible when the left or right
  /// panel is revealed.
  final double drawerWidth;

  /// A callback to notify when a panel reveal has completed.
  final ValueChanged<RevealSide>? onSideChange;

  const OverlappingPanels(
      {this.left, required this.main, this.right, this.drawerWidth = defaultDrawerWidth, this.onSideChange, Key? key})
      : super(key: key);

  static OverlappingPanelsState? of(BuildContext context) {
    return context.findAncestorStateOfType<OverlappingPanelsState>();
  }

  @override
  State<StatefulWidget> createState() {
    return OverlappingPanelsState();
  }
}

class OverlappingPanelsState extends State<OverlappingPanels> with TickerProviderStateMixin {
  AnimationController? controller;
  GlobalKey leftKey = GlobalKey();
  GlobalKey rightKey = GlobalKey();
  GlobalKey mainKey = GlobalKey();

  double _calculateGoal(double width, int multiplier) {
    return (multiplier * width) +
        (-multiplier *
            (MediaQuery.of(context).size.width -
                getPanelWidth(context.read<OverlappingPanelsCubit>().state.direction)));
  }

  List<double> getSizes(GlobalKey key) {
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size;
    return [size?.width ?? 0, size?.height ?? 0];
  }

  List<double> getPositions(GlobalKey key) {
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset.zero);
    return [position?.dx ?? 0, position?.dy ?? 0];
  }

  double getPanelWidth(DragDirection direction) {
    if (direction == DragDirection.right && widget.left != null) {
      return getSizes(leftKey).first;
    } else if (direction == DragDirection.left && widget.right != null) {
      return getSizes(rightKey).first;
    } else {
      return 0;
    }
  }

  void _onApplyTranslation() {
    final mediaWidth = MediaQuery.of(context).size.width;

    final animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        FocusManager.instance.primaryFocus?.unfocus();
        if (widget.onSideChange != null) {
          widget.onSideChange!(context.read<OverlappingPanelsCubit>().state.translate == 0
              ? RevealSide.main
              : (context.read<OverlappingPanelsCubit>().state.translate > 0 ? RevealSide.left : RevealSide.right));
        }
        animationController.dispose();
      }
    });

    if (context.read<OverlappingPanelsCubit>().state.translate.abs() >= mediaWidth / 2) {
      final multiplier = (context.read<OverlappingPanelsCubit>().state.translate > 0 ? 1 : -1);
      final goal = _calculateGoal(mediaWidth, multiplier);
      final Tween<double> tween = Tween(begin: context.read<OverlappingPanelsCubit>().state.translate, end: goal);

      final animation = tween.animate(animationController);

      animation.addListener(() {
        context.read<OverlappingPanelsCubit>().updateTranslate(animation.value);
      });
    } else {
      final animation = Tween<double>(begin: context.read<OverlappingPanelsCubit>().state.translate, end: 0)
          .animate(animationController);

      animation.addListener(() {
        context.read<OverlappingPanelsCubit>().updateTranslate(animation.value);
      });
    }

    animationController.forward();
  }

  void reveal(RevealSide direction) {
    if (context.read<OverlappingPanelsCubit>().state.translate != 0) {
      return;
    }

    final mediaWidth = MediaQuery.of(context).size.width;

    final multiplier = (direction == RevealSide.left ? 1 : -1);
    final goal = _calculateGoal(mediaWidth, multiplier);

    final animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onApplyTranslation();
        animationController.dispose();
      }
    });

    final animation = Tween<double>(begin: context.read<OverlappingPanelsCubit>().state.translate, end: goal)
        .animate(animationController);

    animation.addListener(() {
      context.read<OverlappingPanelsCubit>().updateTranslate(animation.value);
    });

    animationController.forward();
  }

  void onTranslate(double delta) {
    final translate = context.read<OverlappingPanelsCubit>().state.translate + delta;
    if (translate.abs() <= getPanelWidth(context.read<OverlappingPanelsCubit>().state.direction) &&
        (translate < 0 && widget.right != null || translate > 0 && widget.left != null)) {
      context.read<OverlappingPanelsCubit>().updateTranslate(translate);
    }
  }

  void closePanel() {
    FocusManager.instance.primaryFocus?.unfocus();
    final animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    final animation = Tween<double>(begin: context.read<OverlappingPanelsCubit>().state.translate, end: 0)
        .animate(animationController);
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (widget.onSideChange != null) {
          widget.onSideChange!(RevealSide.main);
        }
        animationController.dispose();
      }
    });

    animation.addListener(() {
      context.read<OverlappingPanelsCubit>().updateTranslate(animation.value);
    });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverlappingPanelsCubit, OverlappingPanelsCubitState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            if (state.translate == 0) {
              return true;
            }
            closePanel();
            return false;
          },
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (getPositions(mainKey).first > 0) {
                context.read<OverlappingPanelsCubit>().updateDirection(DragDirection.right);
              } else if (getPositions(mainKey).first < 0) {
                context.read<OverlappingPanelsCubit>().updateDirection(DragDirection.left);
              } else {
                context.read<OverlappingPanelsCubit>().updateDirection(DragDirection.right);
              }
              onTranslate(details.delta.dx);
            },
            onHorizontalDragEnd: (details) {
              _onApplyTranslation();
            },
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Offstage(
                    offstage: state.translate < 0,
                    child: SizedBox(
                      key: leftKey,
                      child: widget.left,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Offstage(
                    offstage: state.translate > 0,
                    child: SizedBox(
                      key: rightKey,
                      child: widget.right,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(state.translate, 0),
                  child: Container(
                    key: mainKey,
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: closePanel,
                      child: Builder(
                        builder: (context) {
                          final calculatedOpacity = 1 -
                              (!(state.translate.abs() /
                                              getPanelWidth(context.read<OverlappingPanelsCubit>().state.direction))
                                          .isNaN
                                      ? (state.translate.abs() /
                                          getPanelWidth(context.read<OverlappingPanelsCubit>().state.direction))
                                      : 0)
                                  .toDouble();
                          return Opacity(
                            opacity: calculatedOpacity <= 0.3 ? 0.3 : calculatedOpacity,
                            child: IgnorePointer(
                              ignoring: state.translate != 0 ? true : false,
                              child: widget.main,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
