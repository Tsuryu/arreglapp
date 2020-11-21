import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/models/job_request.dart';
import 'package:arreglapp/src/providers/request_provider.dart';
import 'package:arreglapp/src/providers/session_provider_provider.dart';
import 'package:arreglapp/src/services/budget_service.dart';
import 'package:arreglapp/src/widgets/basic_card.dart';
import 'package:arreglapp/src/widgets/common_button.dart';
import 'package:arreglapp/src/widgets/common_text_form_field.dart';
import 'package:arreglapp/src/widgets/plain_title_header.dart';
import 'package:arreglapp/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'external_background.dart';

class BudgetPage extends StatelessWidget {
  final bool myRequest;

  const BudgetPage({this.myRequest});

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
                  child: _Form(myRequest: myRequest),
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
  final bool myRequest;

  const _Form({this.myRequest});

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
    final provider = Provider.of<_BudgetProvider>(context, listen: false);

    if (requestProvider.jobRequest.budget != null) {
      provider.amount = requestProvider.jobRequest.budget.amount.toString();
      provider.date = requestProvider.jobRequest.budget.date;
      _amountController.text = requestProvider.jobRequest.budget.amount.toString();
      _dateController.text = DateFormat('yyyy-MM-dd').format(requestProvider.jobRequest.budget.date);
    } else {
      final initialValue = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _dateController.text = initialValue;
    }
  }

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
            controller: _amountController,
            label: 'Monto',
            validateEmpty: true,
            noSpaces: true,
            readOnly: true,
            keyboardType: TextInputType.number,
            icon: FontAwesomeIcons.dollarSign,
            onFocusChange: widget.myRequest
                ? (bool value) {
                    FocusManager.instance.primaryFocus.unfocus();
                  }
                : (bool value) async {},
            onChange: (String value) {
              provider.amount = value;
            },
          ),
          CommonTextFormField(
            controller: _dateController,
            label: 'Fecha',
            icon: Icons.date_range,
            readOnly: true,
            onFocusChange: widget.myRequest
                ? (bool value) {
                    FocusManager.instance.primaryFocus.unfocus();
                  }
                : (bool value) async {
                    if (value) {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: provider.date,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      FocusManager.instance.primaryFocus.unfocus();
                      if (picked != null && picked != provider.date) {
                        setState(() {
                          _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
                          provider.date = picked;
                        });
                      }
                    }
                  },
            onChange: (String value) {},
          ),
          widget.myRequest
              ? Container()
              : CommonButton(
                  text: 'Enviar',
                  mainButton: false,
                  height: size.height * 0.075,
                  width: double.infinity,
                  onPressed: () async {
                    FocusManager.instance.primaryFocus.unfocus();
                    if (!_formKey.currentState.validate()) {
                      showErrorSnackbar(context, 'Datos incorrectos');
                      return;
                    }

                    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
                    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);

                    final budget = Budget(
                      amount: double.parse(provider.amount),
                      date: provider.date,
                    );

                    final result = await BudgetService().create(sessionProvider.session.jwt, requestProvider.jobRequest.id, budget);
                    if (result) {
                      requestProvider.jobRequest.budget = budget;
                      Navigator.pop(context, "Presupuesto enviado correctamente");
                    } else {
                      showErrorSnackbar(context, "No se pudo crear el presupuesto");
                    }
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
