import 'dart:async';
import 'dart:developer';

import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/pages/error_page.dart';
import 'package:arreglapp/src/providers/otp_provider.dart';
import 'package:arreglapp/src/services/transaction_service.dart';
import 'package:arreglapp/src/theme/theme.dart';
import 'package:arreglapp/src/types/common-type.dart';
import 'package:arreglapp/src/widgets/common_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:provider/provider.dart';

class VerificationCodePage extends StatelessWidget {
  final Widget page;
  final FutureBoolCallback onValidationComplete;

  const VerificationCodePage({@required this.page, this.onValidationComplete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PinCodeVerificationScreen(this.page, this.onValidationComplete),
      ),
    );
  }
}

class PinCodeVerificationScreen extends StatefulWidget {
  final Widget page;
  final FutureBoolCallback onValidationComplete;

  PinCodeVerificationScreen(this.page, this.onValidationComplete);

  @override
  _PinCodeVerificationScreenState createState() => _PinCodeVerificationScreenState(this.onValidationComplete);
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  final Future<bool> Function() onValidationComplete;
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController()..text = "";

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  _PinCodeVerificationScreenState(this.onValidationComplete);

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;
    final otpProvider = Provider.of<OtpProvider>(context, listen: false);

    return Scaffold(
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: size.height,
          width: size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: size.height * 0.08),
              _FlareAnimation(),
              SizedBox(height: size.height * 0.03),
              _Title(),
              _Subtitle(widget: widget, appTheme: appTheme),
              SizedBox(height: size.height * 0.02),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v.length < 6) {
                          return "Por favor ingrese el codigo apropiadamente";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: appTheme.accentColor,
                        // on focus lost
                        inactiveFillColor: appTheme.accentColor,
                        inactiveColor: appTheme.primaryColor,
                        // on focus
                        activeColor: appTheme.primaryColor,
                        selectedColor: Colors.white,
                        // on selected to write
                        selectedFillColor: appTheme.accentColor,
                      ),
                      animationDuration: Duration(milliseconds: 300),
                      backgroundColor: appTheme.scaffoldBackgroundColor,
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      onCompleted: (v) {
                        print("Completed");
                      },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          otpProvider.otp = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        return true;
                      },
                    )),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: size.height * 0.02, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  child: CommonButton(
                    mainButton: true,
                    text: "ENVIAR",
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        try {
                          final result = await TransactionService().confirm(otpProvider.otp, otpProvider.traceId);

                          if (!result) {
                            setState(() {
                              hasError = true;
                            });
                            showErrorSnackbar(context, "Codigo de activacion invalido");
                            return;
                          }

                          Widget nextPage = widget.page;
                          if (widget.onValidationComplete != null && !await widget.onValidationComplete()) {
                            nextPage = ErrorPage();
                          }

                          Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => nextPage));
                        } catch (e) {
                          log(e);
                        }
                      } else {
                        setState(() {
                          hasError = true;
                        });
                      }
                    },
                  ),
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "No reciviste el codigo? ",
                  style: appTheme.textTheme.bodyText2,
                  children: [
                    TextSpan(text: " REENVIAR", recognizer: onTapRecognizer, style: appTheme.textTheme.bodyText1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle({@required this.widget, @required this.appTheme});

  final PinCodeVerificationScreen widget;
  final ThemeData appTheme;

  @override
  Widget build(BuildContext context) {
    final otpProvider = Provider.of<OtpProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1, vertical: 8),
      child: RichText(
        text: TextSpan(
          text: "Por favor ingrese el codigo de verificacion enviado a ",
          children: [
            TextSpan(text: otpProvider.email, style: appTheme.textTheme.bodyText1),
          ],
          style: appTheme.textTheme.bodyText2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text('Verificacion por cuenta de email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22), textAlign: TextAlign.center),
    );
  }
}

class _FlareAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height / 3,
      child: FlareActor("assets/flare/otp.flr", animation: "otp", fit: BoxFit.fitHeight, alignment: Alignment.center),
    );
  }
}
