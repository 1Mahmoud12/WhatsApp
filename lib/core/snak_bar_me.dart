import 'package:flutter/material.dart';

SnackBar snackBarMe({required Color color, required String text}) {
  return SnackBar(backgroundColor: color, content: Text(text));
}
