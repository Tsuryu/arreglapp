import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/pages/verification_code_page.dart';
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
import 'new_password_page.dart';

class ResetPasswordEmailPage extends StatelessWidget {
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
              child: _Form(),
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
    final otpProvider = Provider.of<OtpProvider>(context, listen: false);
    return Form(
      key: _formKey,
      child: Flex(
        direction: Axis.vertical,
        children: [
          SizedBox(height: size.height * 0.02),
          CommonTextFormField(
            label: 'Correo electronico',
            validateEmpty: true,
            noSpaces: true,
            icon: FontAwesomeIcons.envelope,
            onChange: (String value) {
              otpProvider.email = value;
            },
          ),
          Text(
            'Para restablecer la contrseña ingresa tu dirección de correo electrónico y te enviaremos un código de verificación.',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: size.height * 0.04),
          Align(
            alignment: Alignment.centerRight,
            child: CommonButton(
              text: 'Continuar',
              mainButton: false,
              withBorder: false,
              height: size.height * 0.075,
              width: size.width * 0.4,
              onPressed: () async {
                if (!_formKey.currentState.validate()) {
                  FocusManager.instance.primaryFocus.unfocus();
                  showErrorSnackbar(context, 'Datos incorrectos');
                  return;
                }
                otpProvider.traceId = await UserProfileService().resetPassword(otpProvider.email);

                if (otpProvider.traceId == null) {
                  showErrorSnackbar(context, 'El correo no está registrado en el sistema');
                } else {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (BuildContext context) => VerificationCodePage(page: NewPasswordPage()),
                    ),
                  );
                }
              },
            ),
          ),
          SizedBox(height: size.height * 0.04),
        ],
      ),
    );
  }
}
