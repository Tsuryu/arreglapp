import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/models/user_profile.dart';
import 'package:arreglapp/src/pages/home_page.dart';
import 'package:arreglapp/src/pages/success_page.dart';
import 'package:arreglapp/src/pages/verification_code_page.dart';
import 'package:arreglapp/src/providers/otp_provider.dart';
import 'package:arreglapp/src/providers/session_provider_provider.dart';
import 'package:arreglapp/src/services/user_profile_service.dart';
import 'package:arreglapp/src/widgets/basic_card.dart';
import 'package:arreglapp/src/widgets/common_text_form_field.dart';
import 'package:arreglapp/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'external_background.dart';

class UserEnrollmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ExternalBackground(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: SliderPageWrapper(
            getChildren: () {
              return <Widget>[
                ChangeNotifierProvider(
                  create: (_) => _UserEnrollmentProvider(),
                  child: SafeArea(child: _Pages()),
                ),
              ];
            },
          ),
        ),
      ),
    );
  }
}

class _Pages extends StatefulWidget {
  @override
  __PagesState createState() => __PagesState();
}

class __PagesState extends State<_Pages> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final GlobalKey<FormState> _formKeyPersonalData = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyCredentials = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyTermsAndConditions = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final userEnrollmentProvider = Provider.of<_UserEnrollmentProvider>(context, listen: false);
    userEnrollmentProvider.personalDataFormKey = this._formKeyPersonalData;
    userEnrollmentProvider.credentialsFormKey = this._formKeyCredentials;
    userEnrollmentProvider.pageController = this._pageController;
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    final size = MediaQuery.of(context).size;
    final itemWidth = size.width * 0.1;

    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: itemWidth * 0.3,
      width: isActive ? itemWidth * 1.5 : itemWidth,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: size.height * 0.02),
          height: size.height * 0.85,
          child: PageView(
            physics: BouncingScrollPhysics(),
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.02),
                child: KeyboardVisibilityProvider(child: _UserInfoForm(formKey: _formKeyPersonalData)),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.40),
                child: _UserCredentialsForm(formKey: _formKeyCredentials),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.25),
                child: _TermsAndConditionsForm(formKey: _formKeyTermsAndConditions),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildPageIndicator(),
        ),
        _NextButton(pageController: _pageController, pages: _numPages, currentPage: _currentPage),
      ],
    );
  }
}

class _NextButton extends StatelessWidget {
  final int pages;
  final PageController pageController;
  final int currentPage;

  const _NextButton({this.pages, this.pageController, this.currentPage});

  @override
  Widget build(BuildContext context) {
    final lastPage = this.pages == this.currentPage + 1;
    final userEnrollmentProvider = Provider.of<_UserEnrollmentProvider>(context, listen: false);
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final otpProvider = Provider.of<OtpProvider>(context, listen: false);

    return Container(
      child: Align(
        alignment: FractionalOffset.bottomRight,
        child: FlatButton(
          onPressed: () async {
            if (!lastPage) {
              this.pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
              return;
            }

            if (!userEnrollmentProvider.isValidForm()) {
              showErrorSnackbar(context, "Datos invalidos");
              return;
            }

            var userProfile = userEnrollmentProvider.getUserProfile();
            var result = await UserProfileService().create(userProfile);

            if (result != null) {
              otpProvider.traceId = result;
              sessionProvider.userProfile = userProfile;
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext context) => VerificationCodePage(
                    page: SuccessPage(page: HomePage(), title: "exito"),
                    onValidationComplete: () async {
                      return await UserProfileService().activate(otpProvider.traceId, otpProvider.otp, userProfile);
                    },
                  ),
                ),
              );
            } else {
              showErrorSnackbar(context, 'Error creando el usuario, por favor intente mas tarde');
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: lastPage
                ? <Widget>[
                    Text('Finalizar', style: TextStyle(color: Colors.white, fontSize: 18.0)),
                  ]
                : <Widget>[
                    Text('Siguente', style: TextStyle(color: Colors.white, fontSize: 18.0)),
                    SizedBox(width: 5.0),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 24.0),
                  ],
          ),
        ),
      ),
    );
  }
}

class _TermsAndConditionsForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const _TermsAndConditionsForm({Key key, this.formKey}) : super(key: key);

  @override
  __TermsAndConditionsFormState createState() => __TermsAndConditionsFormState();
}

class __TermsAndConditionsFormState extends State<_TermsAndConditionsForm> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userEnrollmentProvider = Provider.of<_UserEnrollmentProvider>(context);

    return BasicCard(
      title: "Terminos y condiciones",
      child: Container(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        child: Form(
          key: this.widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Aviso de privacidad', style: TextStyle(fontWeight: FontWeight.w800)),
              SizedBox(height: size.height * 0.02),
              Text('Al aceptar y enviar el formulario de registro de Arreglapp. Acepto expresamente a la recolección y ' +
                  ' procesamiento de datos que Arreglaapp y sus prestadores de servicios haga de mis datos personales, ' +
                  ' con la finalidad de evaluar mi elegibilidad para usar, o continuar usando, la plataforma Arreglapp.'),
              SizedBox(height: size.height * 0.02),
              // Expanded(child: Container()),
              Text('Acepto terminos y condiciones', style: TextStyle(fontWeight: FontWeight.w800)),
              Row(
                children: [
                  Text('NO'),
                  Switch(
                    value: userEnrollmentProvider.termsAndConditions,
                    onChanged: (value) {
                      userEnrollmentProvider.termsAndConditions = value;
                    },
                  ),
                  Text('SI'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserInfoForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const _UserInfoForm({this.formKey});

  @override
  __UserInfoFormState createState() => __UserInfoFormState();
}

class __UserInfoFormState extends State<_UserInfoForm> with AutomaticKeepAliveClientMixin {
  final _controller = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BasicCard(
      withExpanded: true,
      scrollController: _controller,
      title: "Datos personales",
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Form(
            key: this.widget.formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
              child: _GeneralDataFields(scrollController: _controller),
            ),
          );
        },
      ),
    );
  }
}

class _GeneralDataFields extends StatelessWidget {
  final ScrollController scrollController;

  const _GeneralDataFields({this.scrollController});

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(context);
    final size = MediaQuery.of(context).size;
    final userEnrollmentProvider = Provider.of<_UserEnrollmentProvider>(context);
    return Column(
      children: [
        CommonTextFormField(
          initialvalue: userEnrollmentProvider.firstName,
          label: 'Nombre/s',
          validateEmpty: true,
          noSpaces: true,
          icon: FontAwesomeIcons.addressCard,
          onChange: (String value) {
            userEnrollmentProvider.firstName = value;
          },
        ),
        CommonTextFormField(
          initialvalue: userEnrollmentProvider.lastName,
          label: 'Apellido/s',
          validateEmpty: true,
          noSpaces: true,
          icon: FontAwesomeIcons.solidAddressCard,
          onChange: (String value) {
            userEnrollmentProvider.lastName = value;
          },
        ),
        CommonTextFormField(
          initialvalue: userEnrollmentProvider.email,
          label: 'Email',
          validateEmpty: true,
          noSpaces: true,
          icon: FontAwesomeIcons.envelope,
          onChange: (String value) {
            userEnrollmentProvider.email = value;
          },
        ),
        CommonTextFormField(
          initialvalue: userEnrollmentProvider.phone,
          label: 'Telefono',
          validateEmpty: true,
          noSpaces: true,
          icon: FontAwesomeIcons.phone,
          onChange: (String value) {
            userEnrollmentProvider.phone = value;
          },
        ),
        CommonTextFormField(
          initialvalue: userEnrollmentProvider.city,
          label: 'Ciudad',
          validateEmpty: true,
          icon: FontAwesomeIcons.city,
          onChange: (String value) {
            userEnrollmentProvider.city = value;
          },
        ),
        CommonTextFormField(
          // onFocusChange: (hasFocus) {
          //   if (hasFocus) {
          //     scrollDownOnKeyboard(scrollController);
          //   }
          // },
          initialvalue: userEnrollmentProvider.address,
          label: 'Direccion',
          validateEmpty: true,
          icon: FontAwesomeIcons.mapMarkerAlt,
          onChange: (String value) {
            userEnrollmentProvider.address = value;
          },
        ),
        SizedBox(height: isKeyboardVisible ? size.height * 0.25 : 0.0),
      ],
    );
  }
}

class _UserCredentialsForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const _UserCredentialsForm({this.formKey});

  @override
  __UserCredentialsFormState createState() => __UserCredentialsFormState();
}

class __UserCredentialsFormState extends State<_UserCredentialsForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userEnrollmentProvider = Provider.of<_UserEnrollmentProvider>(context);

    return BasicCard(
      title: "Credenciales",
      child: Container(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        child: Form(
          key: this.widget.formKey,
          child: Column(
            children: [
              CommonTextFormField(
                initialvalue: userEnrollmentProvider.username,
                label: 'Usuario',
                validateEmpty: true,
                noSpaces: true,
                icon: FontAwesomeIcons.user,
                onChange: (String value) {
                  userEnrollmentProvider.username = value;
                },
              ),
              CommonTextFormField(
                initialvalue: userEnrollmentProvider.password,
                password: true,
                label: 'Contraseña',
                validateEmpty: true,
                noSpaces: true,
                icon: FontAwesomeIcons.key,
                onChange: (String value) {
                  userEnrollmentProvider.password = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserEnrollmentProvider with ChangeNotifier {
  PageController _pageController;
  GlobalKey<FormState> _personalDataFormKey;
  GlobalKey<FormState> _credentialsFormKey;
  String _username;
  String _password;
  String _firstName;
  String _lastName;
  String _email;
  String _phone;
  String _city;
  String _address;
  bool _termsAndConditions = false;

  get username => this._username;
  get password => this._password;
  get firstName => this._firstName;
  get lastName => this._lastName;
  get phone => this._phone;
  get city => this._city;
  get address => this._address;
  get termsAndConditions => this._termsAndConditions;
  get email => this._email;

  set username(String value) {
    this._username = value;
  }

  set password(String value) {
    this._password = value;
  }

  set firstName(String value) {
    this._firstName = value;
  }

  set lastName(String value) {
    this._lastName = value;
  }

  set phone(String value) {
    this._phone = value;
  }

  set city(String value) {
    this._city = value;
  }

  set address(String value) {
    this._address = value;
  }

  set termsAndConditions(bool value) {
    this._termsAndConditions = value;
    notifyListeners();
  }

  set personalDataFormKey(GlobalKey<FormState> value) {
    this._personalDataFormKey = value;
  }

  set credentialsFormKey(GlobalKey<FormState> value) {
    this._credentialsFormKey = value;
  }

  set pageController(PageController value) {
    this._pageController = value;
  }

  set email(String value) {
    this._email = value;
  }

  bool isValidForm() {
    if (!this._personalDataFormKey.currentState.validate()) {
      this._pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
      return false;
    }

    if (!this._credentialsFormKey.currentState.validate()) {
      this._pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.ease);
      return false;
    }

    if (!this.termsAndConditions) {
      return false;
    }

    return true;
  }

  UserProfile getUserProfile() {
    UserProfile userProfile = UserProfile();

    userProfile.firstName = this._firstName;
    userProfile.lastName = this._lastName;
    userProfile.username = this._username;
    userProfile.password = this._password;
    userProfile.email = this._email;
    userProfile.phone = this._phone;
    userProfile.city = this._city;
    userProfile.address = this._address;

    return userProfile;
  }
}
