import 'package:flutter/material.dart';
import 'package:get/get.dart';

showError(String message) {
  var snackbar = SnackBar(
    backgroundColor: Colors.red,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Icon(
              Icons.error,
              color: Colors.white,
            ),
          ],
        ),
      ],
    ),
  );
  if (Get.isSnackbarOpen) Get.back();
  Get.rawSnackbar(
    backgroundColor: Colors.red,
    messageText: snackbar.content,
  );
}
