import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

SnackBar SnackBanner (String title,String content,String type){
  return  SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: content,
      /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
      contentType:
      type=='success'? ContentType.success:type=='warning'?ContentType.warning
          :type=='failure'?ContentType.failure:ContentType.help,
      // to configure for material banner
      inMaterialBanner: true,
    ),
  );
}

void showSnackBar(BuildContext context, String title, String message, String type) {
  final snackBar = SnackBanner(title, message, type);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}