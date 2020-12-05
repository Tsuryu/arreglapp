import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/pages/external_background.dart';
import 'package:arreglapp/src/pages/payment/mercado_pago_page.dart';
import 'package:arreglapp/src/pages/payment/service_cash_payment_confirmation_page.dart';
import 'package:arreglapp/src/theme/theme.dart';
import 'package:arreglapp/src/widgets/common_card.dart';
import 'package:arreglapp/src/widgets/plain_title_header.dart';
import 'package:arreglapp/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ServicePaymentPage extends StatelessWidget {
  final bool myRequest;

  const ServicePaymentPage({@required this.myRequest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExternalBackground(
        child: SliderPageWrapper(
          header: _Header(myRequest: this.myRequest),
          getChildren: () {
            return <Widget>[
              _ButtonList(myRequest: this.myRequest),
            ];
          },
        ),
      ),
    );
  }
}

class _ButtonList extends StatelessWidget {
  final bool myRequest;

  const _ButtonList({this.myRequest});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.75,
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _CashButton(myRequest: myRequest),
          _CardButton(myRequest: myRequest),
          _MercadoPagoButton(myRequest: myRequest),
        ],
      ),
    );
  }
}

class _CashButton extends StatelessWidget {
  final bool myRequest;

  const _CashButton({this.myRequest});

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return CommonCard(
      icon: Icon(FontAwesomeIcons.moneyBillWave, color: appTheme.primaryColor, size: 30.0),
      title: "Efectivo",
      onTap: () async {
        if (!myRequest) {
          showInfoSnackbar(context, "En construccion");
          return;
        }
        await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => ServiceCashPaymentConfirmationPage()));
      },
    );
  }
}

class _CardButton extends StatelessWidget {
  final bool myRequest;

  const _CardButton({this.myRequest});

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return CommonCard(
      icon: Icon(FontAwesomeIcons.creditCard, color: appTheme.primaryColor, size: 30.0),
      title: "Tarjeta de credito debito",
      onTap: () {
        showInfoSnackbar(context, "En construccion");
      },
    );
  }
}

class _MercadoPagoButton extends StatelessWidget {
  final bool myRequest;

  const _MercadoPagoButton({this.myRequest});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CommonCard(
      hidePadding: true,
      content: Container(
        padding: EdgeInsets.only(top: size.height * 0.015, bottom: size.height * 0.015, right: size.width * 0.01),
        height: size.height * 0.11,
        child: Image(
          image: AssetImage('assets/images/mercado-pago.png'),
          fit: BoxFit.fitHeight,
        ),
      ),
      onTap: () async {
        if (myRequest) {
          showInfoSnackbar(context, "En construccion");
          return;
        }
        await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => MercadoPagoPage()));
      },
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final bool myRequest;

  const _Header({this.title, this.myRequest});

  @override
  Widget build(BuildContext context) {
    return PlainTitleHeader(title: this.myRequest ? "Pago de servicio" : "Pago de comision");
  }
}
