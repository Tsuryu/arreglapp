import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/models/user_profile.dart';
import 'package:arreglapp/src/services/user_profile_service.dart';
import 'package:arreglapp/src/theme/theme.dart';
import 'package:arreglapp/src/widgets/basic_card.dart';
import 'package:arreglapp/src/widgets/common_header.dart';
import 'package:arreglapp/src/widgets/common_text_form_field.dart';
import 'package:arreglapp/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientEnrollmentPage extends StatelessWidget {
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
              ChangeNotifierProvider(
                create: (_) => _ClientEnrollmentProvider(),
                child: _Pages(),
              ),
            ];
          },
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
    final clientEnrollmentProvider = Provider.of<_ClientEnrollmentProvider>(context, listen: false);
    clientEnrollmentProvider.personalDataFormKey = this._formKeyPersonalData;
    clientEnrollmentProvider.credentialsFormKey = this._formKeyCredentials;
    clientEnrollmentProvider.pageController = this._pageController;
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
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final itemWidth = size.width * 0.1;

    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: itemWidth * 0.3,
      width: isActive ? itemWidth * 1.5 : itemWidth,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : appTheme.primaryColor,
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
          height: size.height * 0.7,
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
                child: _ClientInfoForm(formKey: _formKeyPersonalData),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.25),
                child: _ClientCredentialsForm(formKey: _formKeyCredentials),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.15),
                child: _TermsAndConditionsForm(formKey: _formKeyTermsAndConditions),
              ),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.03),
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
    final clientEnrollmentProvider = Provider.of<_ClientEnrollmentProvider>(context, listen: false);

    return Container(
      child: Align(
        alignment: FractionalOffset.bottomRight,
        child: FlatButton(
          onPressed: () async {
            if (!lastPage) {
              this.pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
              return;
            }

            if (!clientEnrollmentProvider.isValidForm()) {
              showErrorSnackbar(context, "Datos invalidos");
              return;
            }

            var userProfile = clientEnrollmentProvider.getUserProfile();
            var result = await UserProfileServie().create(context, userProfile);

            if (result) {
              showSuccessSnackbar(context, "Usuario creado");
              Navigator.pop(context, true);
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
    final clientEnrollmentProvider = Provider.of<_ClientEnrollmentProvider>(context);

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
              Text('Acepto terminos y condiciones', style: TextStyle(fontWeight: FontWeight.w800)),
              Row(
                children: [
                  Text('NO'),
                  Switch(
                    value: clientEnrollmentProvider.termsAndConditions,
                    onChanged: (value) {
                      clientEnrollmentProvider.termsAndConditions = value;
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

class _ClientInfoForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const _ClientInfoForm({this.formKey});

  @override
  __ClientInfoFormState createState() => __ClientInfoFormState();
}

class __ClientInfoFormState extends State<_ClientInfoForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final clientEnrollmentProvider = Provider.of<_ClientEnrollmentProvider>(context);

    return BasicCard(
      title: "Datos personales",
      child: Container(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        child: Form(
          key: this.widget.formKey,
          child: Column(
            children: [
              CommonTextFormField(
                initialvalue: clientEnrollmentProvider.firstName,
                label: 'Nombre/s',
                validateEmpty: true,
                noSpaces: true,
                onChange: (String value) {
                  clientEnrollmentProvider.firstName = value;
                },
              ),
              CommonTextFormField(
                initialvalue: clientEnrollmentProvider.lastName,
                label: 'Apellido/s',
                validateEmpty: true,
                noSpaces: true,
                onChange: (String value) {
                  clientEnrollmentProvider.lastName = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClientCredentialsForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const _ClientCredentialsForm({this.formKey});

  @override
  __ClientCredentialsFormState createState() => __ClientCredentialsFormState();
}

class __ClientCredentialsFormState extends State<_ClientCredentialsForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final clientEnrollmentProvider = Provider.of<_ClientEnrollmentProvider>(context);

    return BasicCard(
      title: "Credenciales",
      child: Container(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        child: Form(
          key: this.widget.formKey,
          child: Column(
            children: [
              CommonTextFormField(
                initialvalue: clientEnrollmentProvider.username,
                label: 'Usuario',
                validateEmpty: true,
                noSpaces: true,
                onChange: (String value) {
                  clientEnrollmentProvider.username = value;
                },
              ),
              CommonTextFormField(
                initialvalue: clientEnrollmentProvider.password,
                password: true,
                label: 'Contraseña',
                validateEmpty: true,
                noSpaces: true,
                onChange: (String value) {
                  clientEnrollmentProvider.password = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClientEnrollmentProvider with ChangeNotifier {
  PageController _pageController;
  GlobalKey<FormState> _personalDataFormKey;
  GlobalKey<FormState> _credentialsFormKey;
  String _username;
  String _password;
  String _firstName;
  String _lastName;
  bool _termsAndConditions = false;

  get username => this._username;
  get password => this._password;
  get firstName => this._firstName;
  get lastName => this._lastName;
  get termsAndConditions => this._termsAndConditions;

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

    return userProfile;
  }
}
