import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterwave_payment/flutterwave_payment.dart';

import 'button_widget.dart';
import 'switch_widget.dart';
import 'vendor_widget.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(secondary: Colors.pink)),
      home: const HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var autoValidate = false;
  bool acceptCardPayment = true;
  bool acceptAccountPayment = true;
  bool acceptMpesaPayment = false;
  bool shouldDisplayFee = true;
  bool acceptAchPayments = false;
  bool acceptGhMMPayments = false;
  bool acceptUgMMPayments = false;
  bool acceptMMFrancophonePayments = false;
  bool live = false;
  bool preAuthCharge = false;
  bool addSubAccounts = false;
  List<SubAccount> subAccounts = [];
  String email;
  double amount;
  String publicKey = "PASTE PUBLIC KEY HERE";
  String encryptionKey = "PASTE ENCRYPTION KEY HERE";
  String txRef;
  String orderRef;
  String narration;
  String currency;
  String country;
  String firstName;
  String lastName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: <Widget>[
                SwitchWidget(
                  value: acceptCardPayment,
                  title: 'Accept card payments',
                  onChanged: (value) =>
                      setState(() => acceptCardPayment = value),
                ),
                SwitchWidget(
                  value: acceptAccountPayment,
                  title: 'Accept account payments',
                  onChanged: (value) =>
                      setState(() => acceptAccountPayment = value),
                ),
                SwitchWidget(
                  value: acceptMpesaPayment,
                  title: 'Accept Mpesa payments',
                  onChanged: (value) =>
                      setState(() => acceptMpesaPayment = value),
                ),
                SwitchWidget(
                  value: shouldDisplayFee,
                  title: 'Should Display Fee',
                  onChanged: (value) =>
                      setState(() => shouldDisplayFee = value),
                ),
                SwitchWidget(
                  value: acceptAchPayments,
                  title: 'Accept ACH payments',
                  onChanged: (value) =>
                      setState(() => acceptAchPayments = value),
                ),
                SwitchWidget(
                  value: acceptGhMMPayments,
                  title: 'Accept GH Mobile money payments',
                  onChanged: (value) =>
                      setState(() => acceptGhMMPayments = value),
                ),
                SwitchWidget(
                  value: acceptUgMMPayments,
                  title: 'Accept UG Mobile money payments',
                  onChanged: (value) =>
                      setState(() => acceptUgMMPayments = value),
                ),
                SwitchWidget(
                  value: acceptMMFrancophonePayments,
                  title: 'Accept Mobile money Francophone Africa payments',
                  onChanged: (value) =>
                      setState(() => acceptMMFrancophonePayments = value),
                ),
                SwitchWidget(
                  value: live,
                  title: 'Live',
                  onChanged: (value) => setState(() => live = value),
                ),
                SwitchWidget(
                  value: preAuthCharge,
                  title: 'Pre Auth Charge',
                  onChanged: (value) => setState(() => preAuthCharge = value),
                ),
                SwitchWidget(
                    value: addSubAccounts,
                    title: 'Add subaccounts',
                    onChanged: onAddAccountsChange),
                buildVendorRefs(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Form(
                    key: formKey,
                    autovalidateMode: autoValidate
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(hintText: 'Email'),
                          onSaved: (value) => email = value,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration:
                              const InputDecoration(hintText: 'Amount to charge'),
                          onSaved: (value) => amount = double.tryParse(value),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(hintText: 'txRef'),
                          onSaved: (value) => txRef = value,
                          initialValue:
                              "rave_flutter-${DateTime.now().toString()}",
                          validator: (value) =>
                              value.trim().isEmpty ? 'Field is required' : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(hintText: 'orderRef'),
                          onSaved: (value) => orderRef = value,
                          initialValue:
                              "rave_flutter-${DateTime.now().toString()}",
                          validator: (value) =>
                              value.trim().isEmpty ? 'Field is required' : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(hintText: 'Narration'),
                          onSaved: (value) => narration = value,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(
                              hintText: 'Currency code e.g NGN'),
                          onSaved: (value) => currency = value,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration:
                              const InputDecoration(hintText: 'Country code e.g NG'),
                          onSaved: (value) => country = value,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(hintText: 'First name'),
                          onSaved: (value) => firstName = value,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(hintText: 'Last name'),
                          onSaved: (value) => lastName = value,
                        ),
                      ],
                    ),
                  ),
                ),
                Button(text: 'Start Payment', onPressed: validateInputs)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildVendorRefs() {
    if (!addSubAccounts) {
      return const SizedBox();
    }

    addSubAccount() async {
      var subAccount = await showDialog<SubAccount>(
          context: context, builder: (context) => const AddVendorWidget());
      if (subAccount != null) {
        subAccounts ??= [];
        setState(() => subAccounts.add(subAccount));
      }
    }

    var buttons = <Widget>[
      Button(
        onPressed: addSubAccount,
        text: 'Add vendor',
      ),
      const SizedBox(
        width: 10,
        height: 10,
      ),
      Button(
        onPressed: () => onAddAccountsChange(false),
        text: 'Clear',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Your current vendor refs are: ${subAccounts.map((a) => '${a.id}(${a.transactionSplitRatio})').join(', ')}',
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Platform.isIOS
                ? Column(
                    children: buttons,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: buttons,
                  ),
          )
        ],
      ),
    );
  }

  onAddAccountsChange(bool value) {
    setState(() {
      addSubAccounts = value;
      if (!value) {
        subAccounts.clear();
      }
    });
  }

  void validateInputs() {
    var formState = formKey.currentState;
    if (!formState.validate()) {
      setState(() => autoValidate = true);
      return;
    }

    formState.save();
    startPayment();
  }

  void startPayment() async {
    var initializer = RavePayInitializer(
        amount: amount,
        publicKey: publicKey,
        encryptionKey: encryptionKey,
        subAccounts: subAccounts.isEmpty ? null : null)
      ..country =
          country = country != null && country.isNotEmpty ? country : "NG"
      ..currency = currency != null && currency.isNotEmpty ? currency : "NGN"
      ..email = email
      ..fName = firstName
      ..lName = lastName
      ..narration = narration ?? ''
      ..txRef = txRef
      ..orderRef = orderRef
      ..acceptMpesaPayments = acceptMpesaPayment
      ..acceptAccountPayments = acceptAccountPayment
      ..acceptCardPayments = acceptCardPayment
      ..acceptAchPayments = acceptAchPayments
      ..acceptGHMobileMoneyPayments = acceptGhMMPayments
      ..acceptUgMobileMoneyPayments = acceptUgMMPayments
      ..acceptMobileMoneyFrancophoneAfricaPayments = acceptMMFrancophonePayments
      ..displayEmail = false
      ..displayAmount = false
      ..staging = !live
      ..isPreAuth = preAuthCharge
      ..displayFee = shouldDisplayFee;

    var response = await RavePayManager()
        .prompt(context: context, initializer: initializer);
    print(response);
    scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(response?.message)));
  }
}
