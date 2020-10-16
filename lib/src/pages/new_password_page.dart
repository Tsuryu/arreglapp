import 'dart:developer';

import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/pages/login_page.dart';
import 'package:arreglapp/src/pages/success_page.dart';
import 'package:arreglapp/src/providers/otp_provider.dart';
import 'package:arreglapp/src/services/user_profile_service.dart';
import 'package:arreglapp/src/widgets/basic_card.dart';
import 'package:arreglapp/src/widgets/common_button.dart';
import 'package:arreglapp/src/widgets/common_text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'external_background.dart';

class NewPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ExternalBackground(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.1, horizontal: size.width * 0.02),
          child: SingleChildScrollView(
            child: BasicCard(
              title: "Restablecer contraseña",
              child: ChangeNotifierProvider(
                create: (_) => _NewPasswordProvider(),
                child: _Form(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<_NewPasswordProvider>(context, listen: false);
    final otpProvider = Provider.of<OtpProvider>(context, listen: false);
    return Form(
      key: _formKey,
      child: Flex(
        direction: Axis.vertical,
        children: [
          SizedBox(height: size.height * 0.02),
          CommonTextFormField(
            label: 'Nueva contraseña',
            validateEmpty: true,
            noSpaces: true,
            password: true,
            icon: FontAwesomeIcons.lock,
            onChange: (String value) {
              provider.newPassword = value;
            },
          ),
          CommonTextFormField(
            label: 'Confirmar contraseña',
            validateEmpty: true,
            noSpaces: true,
            password: true,
            icon: FontAwesomeIcons.lock,
            onChange: (String value) {
              provider.confirmPassword = value;
            },
          ),
          CommonButton(
            text: 'Finalizar',
            mainButton: false,
            height: size.height * 0.075,
            width: double.infinity,
            onPressed: () async {
              if (!_formKey.currentState.validate()) {
                FocusManager.instance.primaryFocus.unfocus();
                showErrorSnackbar(context, 'Datos incorrectos');
                return;
              }

              if (provider.confirmPassword != provider.newPassword) {
                FocusManager.instance.primaryFocus.unfocus();
                showErrorSnackbar(context, 'Las contraseñas no coinciden');
                return;
              }

              final result = await UserProfileService().updatePassword(
                otpProvider.traceId,
                otpProvider.otp,
                provider.newPassword,
                otpProvider.email,
              );

              if (!result) {
                showErrorSnackbar(context, 'No se pudo actualizar la contraseña');
              } else {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (BuildContext context) => SuccessPage(
                      page: LoginPage(),
                      title: 'La contraseña fue modificada correctamente',
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _NewPasswordProvider with ChangeNotifier {
  String _newPassword;
  String _confirmPassword;

  get newPassword => this._newPassword;
  get confirmPassword => this._confirmPassword;

  set newPassword(String value) {
    this._newPassword = value;
  }

  set confirmPassword(String value) {
    this._confirmPassword = value;
  }

  login() {
    return true;
  }
}
