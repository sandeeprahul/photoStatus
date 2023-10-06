import 'package:flutter/material.dart';

Future<T?> showLoaderDialog<T>(BuildContext context, {String? text}) {
  return showDialog<T>(
    useRootNavigator: true,
    context: context,
    barrierDismissible: false,
    builder: (context) => WillPopScope(
      onWillPop: () => Future.value(false),
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 8.0),
              const CircularProgressIndicator.adaptive(),
              const SizedBox(width: 24.0),
              Flexible(child: Text(text ?? "Please Wait...")),
              const SizedBox(width: 8.0),
            ],
          ),
        ),
      ),
    ),
  );
}