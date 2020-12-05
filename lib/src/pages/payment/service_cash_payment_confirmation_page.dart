import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/pages/budget_page.dart';
import 'package:arreglapp/src/pages/external_background.dart';
import 'package:arreglapp/src/pages/home_page.dart';
import 'package:arreglapp/src/pages/success_page.dart';
import 'package:arreglapp/src/providers/request_provider.dart';
import 'package:arreglapp/src/providers/session_provider_provider.dart';
import 'package:arreglapp/src/services/job_request_service.dart';
import 'package:arreglapp/src/widgets/common_button.dart';
import 'package:arreglapp/src/widgets/plain_title_header.dart';
import 'package:arreglapp/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceCashPaymentConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExternalBackground(
        child: SliderPageWrapper(
          header: _Header(),
          getChildren: () {
            return <Widget>[
              BudgetForm(myRequest: true),
              _ConfirmButton(),
            ];
          },
        ),
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: size.height * 0.02),
      child: CommonButton(
        mainButton: false,
        withBorder: false,
        text: "Confirmar",
        onPressed: () async {
          final requestProvider = Provider.of<RequestProvider>(context, listen: false);
          final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
          final result = await JobRequestService().confirmPayment(sessionProvider.session.jwt, requestProvider.jobRequest.id);

          if (!result) {
            showErrorSnackbar(context, 'No se pudo realizar el pago');
          } else {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (BuildContext context) => SuccessPage(page: HomePage(), title: 'Tu pago fue realizado.'),
              ),
            );
          }
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;

  const _Header({this.title});

  @override
  Widget build(BuildContext context) {
    return PlainTitleHeader(title: "Pago de servicio");
  }
}
