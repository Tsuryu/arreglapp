import 'dart:async';

import 'package:arreglapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:provider/provider.dart';

class Util {
  static String formValidateEmpty(String value) {
    if (value.isEmpty) {
      return "Este campo es obligatorio";
    }
    return null;
  }
}

void changeStatusLight({Color color = Colors.transparent}) {
  services.SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: color, statusBarIconBrightness: Brightness.light),
  );
}

void changeStatusDark() {
  services.SystemChrome.setSystemUIOverlayStyle(services.SystemUiOverlayStyle.dark);
}

void showSuccessSnackbar(BuildContext context, String text) {
  Scaffold.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(text, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.green,
    ));
}

void showErrorSnackbar(BuildContext context, String text) {
  Scaffold.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(text, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.red,
    ));
}

void showInfoSnackbar(BuildContext context, String text) {
  Scaffold.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(text, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.lightBlue,
    ));
}

void removeNullAndEmptyParams(Map<String, Object> mapToEdit) {
// Remove all null values; they cause validation errors
  final keys = mapToEdit.keys.toList(growable: false);
  for (String key in keys) {
    final value = mapToEdit[key];
    if (value == null) {
      mapToEdit.remove(key);
    } else if (value is String) {
      if (value.isEmpty) {
        mapToEdit.remove(key);
      }
    } else if (value is Map) {
      removeNullAndEmptyParams(value);
    }
  }
}

void showModalPicker({
  @required BuildContext context,
  @required List options,
  @required List values,
  @required String field,
  @required Function onConfirm,
}) {
  final size = MediaQuery.of(context).size;
  final appTheme = Provider.of<ThemeChanger>(context, listen: false);

  Picker(
    adapter: PickerDataAdapter<String>(
      data: List.generate(
        options.length,
        (index) => PickerItem(
          text: Text(
            values.elementAt(index),
            style: TextStyle(
              fontSize: size.height * 0.04,
              color: appTheme.currentTheme.textTheme.bodyText1.color,
            ),
          ),
          value: values.elementAt(index),
        ),
      ),
    ),
    height: size.height * 0.2,
    changeToFirst: true,
    hideHeader: false,
    selectedTextStyle: TextStyle(color: Colors.blue),
    backgroundColor: appTheme.currentTheme.scaffoldBackgroundColor,
    confirmText: "Send",
    onConfirm: (Picker picker, List<int> value) async {
      onConfirm(options.elementAt(value.elementAt(0).toInt()));
      // final result = await TopicService()
      //     .copy(context, topic, baseUrl: environments.elementAt(value.elementAt(0).toInt()).baseUrl);
      // if (result != null) {
      //   showErrorSnackbar(context, result);
      // } else {
      //   showSuccessSnackbar(context, "Copy success");
      // }
    },
  ).showModal(context);
}

void scrollDownOnKeyboard(ScrollController scrollController, {position = 0.0}) {
  Timer(
    Duration(milliseconds: 200),
    () => {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent - position,
        curve: Curves.fastOutSlowIn,
        duration: Duration(seconds: 1),
      )
    },
  );
}

// ignore: missing_return
Function _default() {}

showYesNoDialog({BuildContext context, Function onCancel = _default, Function onConfirm = _default, String title, String content}) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("No"),
    onPressed: onCancel,
  );
  Widget continueButton = FlatButton(
    child: Text("Si"),
    onPressed: onConfirm,
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
