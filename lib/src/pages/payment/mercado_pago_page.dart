import 'dart:convert';
import 'dart:io';

import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/pages/external_background.dart';
import 'package:arreglapp/src/pages/home_page.dart';
import 'package:arreglapp/src/pages/login_page.dart';
import 'package:arreglapp/src/pages/success_page.dart';
import 'package:arreglapp/src/providers/request_provider.dart';
import 'package:arreglapp/src/providers/session_provider_provider.dart';
import 'package:arreglapp/src/services/job_request_service.dart';
import 'package:arreglapp/src/theme/theme.dart';
import 'package:arreglapp/src/widgets/common_button.dart';
import 'package:arreglapp/src/widgets/common_card.dart';
import 'package:arreglapp/src/widgets/plain_title_header.dart';
import 'package:arreglapp/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MercadoPagoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExternalBackground(
        child: SliderPageWrapper(
          header: _Header(),
          getChildren: () {
            return <Widget>[
              _Title(),
              _FeeImagePicker(),
            ];
          },
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left: size.width * 0.03, right: size.width * 0.03, top: size.height * 0.02),
      child: Text(
        '    Envianos tu comprobante de pago para registrar la operacion.',
        style: appTheme.currentTheme.textTheme.bodyText1.copyWith(
          fontSize: 20.0,
        ),
      ),
    );
  }
}

class _FeeImagePicker extends StatefulWidget {
  @override
  __FeeImagePickerState createState() => __FeeImagePickerState();
}

class __FeeImagePickerState extends State<_FeeImagePicker> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    // final pickedFile = await picker.getImage(source: ImageSource.camera);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: size.height * 0.05),
      child: Flex(
        direction: Axis.vertical,
        children: [
          Container(
            constraints: BoxConstraints(maxHeight: size.height * 0.4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: _image == null
                  ? Image(
                      image: AssetImage('assets/images/no-image.png'),
                      fit: BoxFit.fitHeight,
                      color: Colors.transparent,
                      // color: appTheme.currentTheme.scaffoldBackgroundColor,
                      colorBlendMode: BlendMode.multiply,
                    )
                  : Image.file(_image),
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CommonButton(onPressed: getImage, text: 'Subir archivo', width: size.width * 0.4, mainButton: false, withBorder: false),
              CommonButton(
                onPressed: () async {
                  final requestProvider = Provider.of<RequestProvider>(context, listen: false);
                  final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
                  final bytes = this._image.readAsBytesSync();
                  String img64 = base64Encode(bytes);
                  final result = await JobRequestService().transactionFeePay(sessionProvider.session.jwt, requestProvider.jobRequest.id, img64);

                  if (result) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (BuildContext context) => SuccessPage(page: HomePage(), title: 'Su comprobante fue enviado correctamente'),
                      ),
                    );
                  } else {
                    showErrorSnackbar(context, "No se pudo enviar el comprobante");
                  }
                },
                text: 'Enviar',
                width: size.width * 0.4,
                mainButton: false,
                withBorder: false,
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),
          CommonCard(
            hideTrailing: true,
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
              const url = 'https://mpago.la/1eFThD7';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
              // if (myRequest) {
              //   showInfoSnackbar(context, "En construccion");
              //   return;
              // }
              // await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => MercadoPagoPage()));
            },
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;

  const _Header({this.title});

  @override
  Widget build(BuildContext context) {
    return PlainTitleHeader(title: "Pago de de comision");
  }
}
