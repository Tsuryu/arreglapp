import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/models/user_profile.dart';
import 'package:arreglapp/src/pages/home_page.dart';
import 'package:arreglapp/src/providers/user_profile_provider.dart';
import 'package:arreglapp/src/services/user_profile_service.dart';
import 'package:arreglapp/src/theme/theme.dart';
import 'package:arreglapp/src/widgets/basic_card.dart';
import 'package:arreglapp/src/widgets/common_text_form_field.dart';
import 'package:arreglapp/src/widgets/plain_title_header.dart';
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
          header: _Header(),
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

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlainTitleHeader(title: 'Arreglapp');
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
    final userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);

    final size = MediaQuery.of(context).size;
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;

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
                Flexible(child: Container(), flex: 3),
                Flexible(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    child: RaisedButton(
                      elevation: 0.0,
                      child: Text('Ingresar', style: appTheme.textTheme.bodyText1),
                      onPressed: () async {
                        if (!_formKey.currentState.validate()) {
                          FocusManager.instance.primaryFocus.unfocus();
                          showErrorSnackbar(context, 'Datos incorrectos');
                          return;
                        }
                        final UserProfile result = await UserProfileServie().findBy(
                          context,
                          loginProvider.username,
                          loginProvider.password,
                        );

                        if (result == null) {
                          showErrorSnackbar(context, 'Datos incorrectos');
                        } else {
                          userProfileProvider.userProfile = result;
                          await Navigator.push(
                              context, CupertinoPageRoute(builder: (BuildContext context) => HomePage()));
                          FocusManager.instance.primaryFocus.unfocus();
                          _formKey.currentState.reset();
                          userProfileProvider.userProfile = null;
                        }
                      },
                    ),
                  ),
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
