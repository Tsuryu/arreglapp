import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/pages/external_background.dart';
import 'package:arreglapp/src/pages/home_page.dart';
import 'package:arreglapp/src/pages/success_page.dart';
import 'package:arreglapp/src/providers/session_provider_provider.dart';
import 'package:arreglapp/src/services/support_request_service.dart';
import 'package:arreglapp/src/widgets/basic_card.dart';
import 'package:arreglapp/src/widgets/common_button.dart';
import 'package:arreglapp/src/widgets/common_text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ExternalBackground(
        child: SafeArea(child: _SupportRequestCard()),
      ),
    );
  }
}

class _SupportRequestCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        right: size.width * 0.02,
        left: size.width * 0.02,
        top: size.height * 0.1,
        bottom: size.height * 0.3,
      ),
      child: BasicCard(
        title: 'Soporte',
        withExpanded: true,
        child: _SupportRequestForm(),
      ),
    );
  }
}

class _SupportRequestForm extends StatefulWidget {
  @override
  __SupportRequestFormState createState() => __SupportRequestFormState();
}

class __SupportRequestFormState extends State<_SupportRequestForm> {
  final _formKey = GlobalKey<FormState>();
  String _detail;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonTextFormField(
              autoFocus: true,
              hint: "Escriba su mensaje aqui",
              maxLines: 8,
              label: 'Tipo de la solicitud',
              validateEmpty: true,
              onChange: (String value) {
                this._detail = value;
              },
            ),
            CommonButton(
              mainButton: false,
              withBorder: false,
              text: 'Enviar',
              onPressed: () async {
                FocusManager.instance.primaryFocus.unfocus();
                final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
                final result = await SupportRequestService().create(this._detail, sessionProvider.session.jwt);
                if (result) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (BuildContext context) => SuccessPage(
                          page: HomePage(), title: 'Tu reclamo ha sido enviado a nuestro equipo especializado. Nos pondremos en contacto antes de las 48 hs.'),
                    ),
                  );
                } else {
                  showErrorSnackbar(context, "No se pudo cargar tu peticion");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
