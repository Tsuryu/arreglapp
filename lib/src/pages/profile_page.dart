import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/models/user_profile.dart';
import 'package:arreglapp/src/pages/external_background.dart';
import 'package:arreglapp/src/pages/home_page.dart';
import 'package:arreglapp/src/pages/success_page.dart';
import 'package:arreglapp/src/providers/session_provider_provider.dart';
import 'package:arreglapp/src/services/user_profile_service.dart';
import 'package:arreglapp/src/widgets/basic_card.dart';
import 'package:arreglapp/src/widgets/common_button.dart';
import 'package:arreglapp/src/widgets/common_text_form_field.dart';
import 'package:arreglapp/src/widgets/loading.dart';
import 'package:arreglapp/src/widgets/plain_title_header.dart';
import 'package:arreglapp/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExternalBackground(
        child: SliderPageWrapper(
          header: _Header(),
          getChildren: () {
            return <Widget>[_ProfileCard()];
          },
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    return FutureBuilder(
      future: UserProfileService().findMyProfile(sessionProvider.session.jwt),
      builder: (BuildContext context, AsyncSnapshot<UserProfile> snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          return BasicCard(
            title: "Perfil",
            child: ChangeNotifierProvider(
              create: (_) => _ProfileProvider(),
              child: _ProfileForm(userProfile: snapshot.data),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}

class _ProfileForm extends StatefulWidget {
  final UserProfile userProfile;

  const _ProfileForm({this.userProfile});

  @override
  __ProfileFormState createState() => __ProfileFormState();
}

class __ProfileFormState extends State<_ProfileForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final profileProvider = Provider.of<_ProfileProvider>(context, listen: false);
    profileProvider.userProfile = widget.userProfile;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final profileProvider = Provider.of<_ProfileProvider>(context, listen: false);
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    print(sessionProvider.userProfile);

    return Form(
      key: _formKey,
      child: Flex(
        direction: Axis.vertical,
        children: [
          SizedBox(height: size.height * 0.02),
          CommonTextFormField(
            initialvalue: profileProvider.userProfile.firstName,
            label: 'Nombre/s',
            validateEmpty: true,
            icon: FontAwesomeIcons.addressCard,
            onChange: (String value) {
              profileProvider.userProfile.firstName = value;
            },
          ),
          CommonTextFormField(
            initialvalue: profileProvider.userProfile.lastName,
            label: 'Apellido/s',
            validateEmpty: true,
            icon: FontAwesomeIcons.solidAddressCard,
            onChange: (String value) {
              profileProvider.userProfile.lastName = value;
            },
          ),
          CommonTextFormField(
            initialvalue: profileProvider.userProfile.email,
            label: 'Email',
            validateEmpty: true,
            noSpaces: true,
            icon: FontAwesomeIcons.envelope,
            onChange: (String value) {
              profileProvider.userProfile.email = value;
            },
          ),
          CommonTextFormField(
            initialvalue: profileProvider.userProfile.phone,
            label: 'Telefono',
            validateEmpty: true,
            noSpaces: true,
            icon: FontAwesomeIcons.phone,
            onChange: (String value) {
              profileProvider.userProfile.phone = value;
            },
          ),
          CommonTextFormField(
            initialvalue: profileProvider.userProfile.address,
            label: 'Direccion',
            validateEmpty: true,
            icon: FontAwesomeIcons.mapMarkerAlt,
            onChange: (String value) {
              profileProvider.userProfile.address = value;
            },
          ),
          CommonButton(
            text: 'Guardar',
            onPressed: () async {
              FocusManager.instance.primaryFocus.unfocus();
              final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
              final result = await UserProfileService().update(profileProvider.userProfile, sessionProvider.session.jwt);
              if (result) {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (BuildContext context) => SuccessPage(page: HomePage(), title: 'Su perfil se actualizo correctamente'),
                  ),
                );
              } else {
                showErrorSnackbar(context, "No se actualizar su perfil");
              }
            },
            mainButton: false,
            withBorder: false,
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlainTitleHeader(title: 'Mis datos', backButton: true);
  }
}

class _ProfileProvider with ChangeNotifier {
  UserProfile _userProfile = UserProfile();

  get userProfile => this._userProfile;

  set userProfile(UserProfile value) {
    this._userProfile = value;
  }
}
