import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html/parser.dart' as htmlparser;

final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

extension StringExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
  String useCorrectEllipsis() => replaceAll('', '\u200B');
}

class Dev {
  static log([dynamic value, dynamic value1]) => dev.log('$value ${value1 ?? ''}');
}

class AddBorder extends StatelessWidget {
  const AddBorder({this.child, Key? key}) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

String sanitize(String s) => s.replaceAllMapped(
      RegExp(r'\\u([0-9a-fA-F]{4})'),
      (Match m) => String.fromCharCode(int.parse(m.group(1)!, radix: 16)),
    );

String parseHTMLToString(String? value) => '${htmlparser.parse((value) ?? '').documentElement?.text}';

MarkdownStyleSheet markdownDefaultTheme(BuildContext context) => MarkdownStyleSheet.fromTheme(
      Theme.of(context),
    ).copyWith(
      blockquotePadding: const EdgeInsets.only(left: 14),
      blockquoteDecoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 3,
          ),
        ),
      ),
    );

showSnackBar(
    {required Widget value,
    Duration duration = const Duration(milliseconds: 1000),
    Color? color,
    VoidCallback? whenDone,
    SnackBarAction? action}) {
  snackbarKey.currentState?.clearSnackBars();
  snackbarKey.currentState
      ?.showSnackBar(
        SnackBar(
          duration: duration,
          content: value,
          backgroundColor: color,
          behavior: SnackBarBehavior.fixed,
          action: action,
        ),
      )
      .closed
      .then((value) {
    whenDone?.call();
  });
}

class CalcPosition {
  final double x;
  final double y;
  CalcPosition({
    required this.x,
    required this.y,
  });
}

class CalcSize {
  final double width;
  final double height;
  CalcSize({
    required this.width,
    required this.height,
  });
}

class BoundingMeasurements {
  static CalcPosition position(GlobalKey key) {
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset.zero);
    return CalcPosition(x: position?.dx ?? 0, y: position?.dy ?? 0);
  }

  static CalcSize size(GlobalKey key) {
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size;
    return CalcSize(width: size?.width ?? 0, height: size?.height ?? 0);
  }
}

Future<bool> showExitPopup(BuildContext context) async {
  if (ModalRoute.of(context)?.isFirst ?? false) {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text(
              'Do you want to exit this app?',
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
            ],
          ),
        ) ??
        false;
  } else {
    return true;
  }
}

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class ImageWithLoader extends StatelessWidget {
  final String? url;
  final num? width;
  final num? height;
  final bool withCacheHeight;
  const ImageWithLoader(
    this.url, {
    this.width,
    this.height,
    this.withCacheHeight = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (url == null || (url?.isEmpty ?? true)) {
      return const SizedBox.shrink();
    }
    return LayoutBuilder(
      builder: (context, contraints) {
        return AspectRatio(
          aspectRatio: ((width ?? (contraints.maxWidth.isFinite ? contraints.maxWidth.toInt() : 1)).toDouble()) /
              ((height ?? 200).toDouble()),
          child: Image.network(
            '$url',
            fit: BoxFit.contain,
            cacheHeight: contraints.maxWidth.isFinite && withCacheHeight ? contraints.maxWidth.toInt() * 2 : null,
            loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null)
                ? child
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        );
      },
    );
  }
}

String getFormattedDuration(Duration duration) {
  String twoDigits(int n, {int? padLeft}) => n.toString().padLeft(padLeft ?? (n == 0 ? 1 : 2), "0");
  String twoDigitHours = twoDigits(duration.inHours);
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60), padLeft: 2);
  return "${duration.inHours != 0 ? '$twoDigitHours:' : ''}$twoDigitMinutes:$twoDigitSeconds";
}

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

// Helper functions for validator and sanitizer.
shift(List l) {
  if (l.isNotEmpty) {
    var first = l.first;
    l.removeAt(0);
    return first;
  }
  return null;
}

Map<String, Object> merge(Map<String, Object>? obj, Map<String, Object> defaults) {
  if (obj == null) {
    return defaults;
  }
  defaults.forEach((key, val) => obj.putIfAbsent(key, () => val));
  return obj;
}
