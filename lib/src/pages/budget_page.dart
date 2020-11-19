import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/widgets/basic_card.dart';
import 'package:arreglapp/src/widgets/common_button.dart';
import 'package:arreglapp/src/widgets/common_text_form_field.dart';
import 'package:arreglapp/src/widgets/plain_title_header.dart';
import 'package:arreglapp/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'external_background.dart';

class BudgetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExternalBackground(
        child: SliderPageWrapper(
          header: _Header(),
          getChildren: () {
            return <Widget>[
              BasicCard(
                title: "Datos",
                child: ChangeNotifierProvider(
                  create: (_) => _BudgetProvider(),
                  child: _Form(),
                ),
              ),
            ];
          },
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<_BudgetProvider>(context, listen: false);

    return Form(
      key: _formKey,
      child: Flex(
        direction: Axis.vertical,
        children: [
          SizedBox(height: size.height * 0.02),
          CommonTextFormField(
            label: 'Monto',
            validateEmpty: true,
            noSpaces: true,
            keyboardType: TextInputType.number,
            icon: FontAwesomeIcons.dollarSign,
            onChange: (String value) {
              provider.amount = value;
            },
          ),
          CommonTextFormField(
            controller: _controller,
            label: 'Fecha',
            validateEmpty: true,
            noSpaces: true,
            icon: Icons.date_range,
            onChange: (String value) {},
          ),
          CommonButton(
            text: 'Finalizar',
            mainButton: false,
            height: size.height * 0.075,
            width: double.infinity,
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: provider.date,
                firstDate: DateTime(2015, 1),
                lastDate: DateTime(2100),
              );
              if (picked != null && picked != provider.date) {
                setState(() {
                  _controller.text = picked.toString();
                  provider.date = picked;
                });
              }
              // FocusManager.instance.primaryFocus.unfocus();
              // if (!_formKey.currentState.validate()) {
              //   showErrorSnackbar(context, 'Datos incorrectos');
              //   return;
              // }
            },
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlainTitleHeader(title: 'Presupuesto', backButton: true);
  }
}

class _BudgetProvider with ChangeNotifier {
  String _amount;
  DateTime _date = DateTime.now();

  get amount => this._amount;
  get date => this._date;

  set amount(String value) {
    this._amount = value;
  }

  set date(DateTime value) {
    this._date = value;
  }
}
