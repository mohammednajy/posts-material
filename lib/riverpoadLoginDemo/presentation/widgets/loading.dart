import 'package:flutter/material.dart';

loadingWithText(BuildContext context, {String? text}) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
            child: Dialog(
              alignment: Alignment.center,
              child: SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text ?? 'waiting ....',
                    ),
                    const CircularProgressIndicator.adaptive(),
                  ],
                ),
              ),
            ),
          ));
}
