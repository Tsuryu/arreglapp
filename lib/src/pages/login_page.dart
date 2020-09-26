import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/models/session.dart';
import 'package:arreglapp/src/pages/enrollment_type_selection_page.dart';
import 'package:arreglapp/src/pages/home_page.dart';
import 'package:arreglapp/src/providers/user_profile_provider.dart';
import 'package:arreglapp/src/services/session_service.dart';
import 'package:arreglapp/src/widgets/basic_card.dart';
import 'package:arreglapp/src/widgets/common_button.dart';
import 'package:arreglapp/src/widgets/common_header.dart';
import 'package:arreglapp/src/widgets/common_text_form_field.dart';
import 'package:arreglapp/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SliderPageWrapper(
          header: CommonHeader(),
          getChildren: () {
            return <Widget>[
              _BasicInfoForm(),
            ];
          },
        ),
      ),
    );
  }
}

class _BasicInfoForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasicCard(
      title: "Login",
      child: ChangeNotifierProvider(
        create: (_) => _LoginProvider(),
        child: _LoginForm(),
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
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
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
              onChange: (String value) {
                loginProvider.username = value;
              },
            ),
            CommonTextFormField(
              password: true,
              label: 'Password',
              validateEmpty: true,
              noSpaces: true,
              onChange: (String value) {
                loginProvider.password = value;
              },
            ),
            Flex(
              direction: Axis.horizontal,
              children: [
                CommonButton(
                  text: 'Registrarse',
                  withBorder: false,
                  height: size.height * 0.075,
                  width: size.width * 0.4,
                  onPressed: () async {
                    await Navigator.push(
                        context, CupertinoPageRoute(builder: (BuildContext context) => EnrollmentTypeSelectionPage()));
                    _formKey.currentState.reset();
                  },
                ),
                Expanded(child: Container()),
                CommonButton(
                  text: 'Ingresar',
                  mainButton: false,
                  height: size.height * 0.075,
                  width: size.width * 0.4,
                  onPressed: () async {
                    if (!_formKey.currentState.validate()) {
                      FocusManager.instance.primaryFocus.unfocus();
                      showErrorSnackbar(context, 'Datos incorrectos');
                      return;
                    }
                    final Session result = await SessionService().login(
                      context,
                      loginProvider.username,
                      loginProvider.password,
                    );

                    if (result == null) {
                      showErrorSnackbar(context, 'Datos incorrectos');
                    } else {
                      sessionProvider.session = result;
                      await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => HomePage()));
                      FocusManager.instance.primaryFocus.unfocus();
                      _formKey.currentState.reset();
                      sessionProvider.session = null;
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
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
