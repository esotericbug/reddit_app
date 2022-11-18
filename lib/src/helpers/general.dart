import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html/parser.dart' as htmlparser;

final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

class Dev {
  static log(dynamic value) => dev.log('$value');
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

String parseHTMLToString(String? value) => '${htmlparser.parse(value).documentElement?.text}';

MarkdownStyleSheet markdownDefaultTheme(BuildContext context) => MarkdownStyleSheet.fromTheme(
      Theme.of(context),
    ).copyWith(
      blockquotePadding: const EdgeInsets.only(left: 14),
      blockquoteDecoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.grey.shade300, width: 4),
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

extension StringExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}
