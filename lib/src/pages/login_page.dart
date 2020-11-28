import 'dart:convert';

import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/models/job_request.dart';
import 'package:arreglapp/src/models/session.dart';
import 'package:arreglapp/src/models/user_profile.dart';
import 'package:arreglapp/src/pages/home_page.dart';
import 'package:arreglapp/src/pages/requests/job_request_page.dart';
import 'package:arreglapp/src/pages/reset_password_page.dart';
import 'package:arreglapp/src/pages/user_enrollment_page.dart';
import 'package:arreglapp/src/providers/push_notifications_provider.dart';
import 'package:arreglapp/src/providers/request_provider.dart';
import 'package:arreglapp/src/providers/session_provider_provider.dart';
import 'package:arreglapp/src/services/session_service.dart';
import 'package:arreglapp/src/widgets/basic_card.dart';
import 'package:arreglapp/src/widgets/common_button.dart';
import 'package:arreglapp/src/widgets/common_text_form_field.dart';
import 'package:arreglapp/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'external_background.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final pushProvider = Provider.of<PushNotificationsProvider>(context);
    if (pushProvider.event != null) {
      final event = pushProvider.event;
      pushProvider.event = null;
      final jobRequest = JobRequest.fromJson(jsonDecode(pushProvider.message));
      final requestProvider = Provider.of<RequestProvider>(context, listen: false);
      final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
      requestProvider.jobRequest = jobRequest;

      if (event == "onResume") {
        Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => JobRequestPage(index: 0, myRequest: true, title: "test")));
      }

      if (event == "onMessage") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showYesNoDialog(
            context: context,
            content: 'Quieres ver la actualizacion ahora?',
            title: 'Estado de solicitud',
            onCancel: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            onConfirm: () {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext context) => JobRequestPage(
                    index: 0,
                    myRequest: requestProvider.jobRequest.username == sessionProvider.userProfile.username,
                    title: "Mis solicitudes",
                    returnHome: true,
                  ),
                ),
              );
            },
          );
        });
      }
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: ExternalBackground(
          backButton: false,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: SliderPageWrapper(
              header: Container(),
              getChildren: () {
                return <Widget>[
                  _BasicInfoForm(),
                ];
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _BasicInfoForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        right: size.width * 0.02,
        left: size.width * 0.02,
        // top: size.height * 0.05,
      ),
      child: BasicCard(
        title: "Login",
        child: ChangeNotifierProvider(
          create: (_) => _LoginProvider(),
          child: _LoginForm(),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  __LoginFormState createState() => __LoginFormState();
}

class __LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<_LoginProvider>(context);
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CommonTextFormField(
              label: 'Username',
              validateEmpty: true,
              noSpaces: true,
              icon: FontAwesomeIcons.user,
              onChange: (String value) {
                loginProvider.username = value;
              },
            ),
            CommonTextFormField(
              password: true,
              label: 'Password',
              validateEmpty: true,
              noSpaces: true,
              icon: FontAwesomeIcons.key,
              onChange: (String value) {
                loginProvider.password = value;
              },
            ),
            _LoginButton(formKey: _formKey),
            SizedBox(height: size.height * 0.02),
            Flex(
              direction: Axis.horizontal,
              children: [
                _ResetPasswordButton(formKey: _formKey),
                Expanded(child: Container()),
                _RegisterButton(formKey: _formKey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ResetPasswordButton extends StatelessWidget {
  const _ResetPasswordButton({@required GlobalKey<FormState> formKey}) : _formKey = formKey;
  final GlobalKey<FormState> _formKey;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CommonButton(
      text: 'Recuperar contraseña',
      withBorder: false,
      height: size.height * 0.075,
      width: size.width * 0.4,
      onPressed: () async {
        FocusManager.instance.primaryFocus.unfocus();
        await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => ResetPasswordEmailPage()));
        _formKey.currentState.reset();
      },
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton({@required GlobalKey<FormState> formKey}) : _formKey = formKey;
  final GlobalKey<FormState> _formKey;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CommonButton(
      text: 'Registrarse',
      withBorder: false,
      height: size.height * 0.075,
      width: size.width * 0.4,
      onPressed: () async {
        FocusManager.instance.primaryFocus.unfocus();
        await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => UserEnrollmentPage()));
        _formKey.currentState.reset();
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({@required GlobalKey<FormState> formKey}) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return CommonButton(
      text: 'Ingresar',
      mainButton: false,
      height: size.height * 0.075,
      width: double.infinity,
      materialEffect: false,
      onPressed: () async {
        final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
        final loginProvider = Provider.of<_LoginProvider>(context, listen: false);
        final pushNotificationsProvider = Provider.of<PushNotificationsProvider>(context, listen: false);

        FocusManager.instance.primaryFocus.unfocus();
        if (!_formKey.currentState.validate()) {
          showErrorSnackbar(context, 'Datos incorrectos');
          return;
        }
        final Session result = await SessionService().login(loginProvider.username, loginProvider.password, pushNotificationsProvider.token);

        if (result == null) {
          showErrorSnackbar(context, 'Credenciales invalidas');
        } else {
          if (sessionProvider.userProfile == null) {
            sessionProvider.userProfile = UserProfile();
          }
          sessionProvider.userProfile.username = loginProvider.username;
          sessionProvider.session = result;
          await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => HomePage()));
          FocusManager.instance.primaryFocus.unfocus();
          _formKey.currentState.reset();
          sessionProvider.session = null;
        }
      },
    );
  }
}

class _LoginProvider with ChangeNotifier {
  String _username;
  String _password;

  get username => this._username;
  get password => this._password;

  set username(String value) {
    this._username = value;
  }

  set password(String value) {
    this._password = value;
  }

  login() {
    return true;
  }
}
