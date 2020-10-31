import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/models/job_request.dart';
import 'package:arreglapp/src/pages/error_page.dart';
import 'package:arreglapp/src/pages/home_page.dart';
import 'package:arreglapp/src/providers/request_provider.dart';
import 'package:arreglapp/src/providers/session_provider_provider.dart';
import 'package:arreglapp/src/services/job_request_service.dart';
import 'package:arreglapp/src/widgets/basic_card.dart';
import 'package:arreglapp/src/widgets/common_button.dart';
import 'package:arreglapp/src/widgets/common_text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../external_background.dart';
import '../success_page.dart';

class JobRequestDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ExternalBackground(
        child: SafeArea(child: _RequestCard()),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        right: size.width * 0.02,
        left: size.width * 0.02,
        top: size.height * 0.05,
        bottom: size.height * 0.3,
      ),
      child: BasicCard(
        withExpanded: true,
        // height: size.height * 0.6,
        title: requestProvider.type,
        child: _RequestForm(),
      ),
    );
  }
}

class _RequestForm extends StatefulWidget {
  @override
  __RequestFormState createState() => __RequestFormState();
}

class __RequestFormState extends State<_RequestForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<RequestProvider>(context);
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextFormField(
              label: 'Tipo de la solicitud',
              validateEmpty: true,
              icon: Icons.title,
              onChange: (String value) {
                requestProvider.title = value;
              },
            ),
            CommonTextFormField(
              label: 'Descripcion del servicio',
              validateEmpty: true,
              icon: Icons.note,
              onChange: (String value) {
                requestProvider.description = value;
              },
            ),
            Text('Ubicacion'),
            Flex(
              direction: Axis.horizontal,
              children: [
                Text('NO'),
                Switch(
                  value: requestProvider.locationAccepted,
                  onChanged: (value) {
                    requestProvider.locationAccepted = value;
                  },
                ),
                Text('SI'),
              ],
            ),
            Align(alignment: Alignment.centerRight, child: _ConfirmButton(formKey: _formKey)),
          ],
        ),
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const _ConfirmButton({@required this.formKey});

  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    return Container(
      child: CommonButton(
        text: "Confirmar",
        mainButton: false,
        onPressed: () async {
          FocusManager.instance.primaryFocus.unfocus();
          if (!formKey.currentState.validate()) {
            showErrorSnackbar(context, "Hay campos obligatorios sin completar");
            return;
          }
          if (!requestProvider.locationAccepted) {
            showErrorSnackbar(context, "Debe aceptar el uso del GPS");
            return;
          }
          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

          var jobRequest = JobRequest();
          jobRequest.type = requestProvider.type;
          jobRequest.title = requestProvider.title;
          jobRequest.description = requestProvider.description;
          jobRequest.location = Location(longitude: position.longitude, latitude: position.latitude);
          jobRequest.username = sessionProvider.userProfile.username;
          final result = await JobRequestService().create(jobRequest, sessionProvider.session.jwt);

          Widget nextPage;
          if (result == null) {
            nextPage = ErrorPage(title: 'La solicitud no pudo ser creada, por favor intentelo devuelta mas tarde.');
          } else {
            nextPage = SuccessPage(page: HomePage(), title: 'Tu solicitud ha sido creada satisfactoriamente.');
          }

          requestProvider.locationAccepted = false;
          await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => nextPage));
        },
      ),
    );
  }
}
