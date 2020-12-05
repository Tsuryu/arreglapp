import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CommonTextFormField extends StatelessWidget {
  final Function onChange;
  final Function onFocusChange;
  final bool validateEmpty;
  final String label;
  final bool noSpaces;
  final String hint;
  final bool password;
  final String initialvalue;
  final IconData icon;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool readOnly;
  final int maxLines;
  final bool autoFocus;

  const CommonTextFormField({
    this.maxLines = 1,
    this.validateEmpty = false,
    this.onChange,
    this.label = '',
    this.noSpaces = false,
    this.hint,
    this.password = false,
    this.initialvalue,
    this.icon,
    this.onFocusChange,
    this.keyboardType = TextInputType.multiline,
    this.controller,
    this.readOnly = false,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.01),
      child: Focus(
        onFocusChange: this.onFocusChange,
        child: TextFormField(
          autofocus: this.autoFocus,
          maxLines: this.maxLines,
          showCursor: this.readOnly,
          readOnly: this.readOnly,
          controller: this.controller,
          keyboardType: this.keyboardType,
          // minLines: 1,
          // maxLines: 5,
          initialValue: this.initialvalue,
          inputFormatters: this.noSpaces ? [FilteringTextInputFormatter(RegExp(r'[a-zA-Z0-9-_@.]'), allow: true)] : [],
          decoration: InputDecoration(
            isDense: true,
            labelText: this.label,
            border: OutlineInputBorder(),
            helperText: '',
            hintText: this.hint,
            labelStyle: appTheme.textTheme.bodyText2,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: appTheme.textTheme.bodyText2.color,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: appTheme.textTheme.bodyText2.color,
                width: 0.5,
              ),
            ),
            prefixIcon: this.icon == null
                ? null
                : Icon(
                    this.icon,
                    size: size.height * 0.04,
                    color: appTheme.primaryColor,
                  ),
            hintStyle: appTheme.textTheme.bodyText2,
          ),
          validator: this.validateEmpty ? Util.formValidateEmpty : null,
          onChanged: this.onChange != null ? this.onChange : () {},
          style: appTheme.textTheme.bodyText2,
          obscureText: this.password,
        ),
      ),
    );
  }
}
