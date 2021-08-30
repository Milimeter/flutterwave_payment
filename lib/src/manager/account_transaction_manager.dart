import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutterwave_payment/src/blocs/connection_bloc.dart';
import 'package:flutterwave_payment/src/common/strings.dart';
import 'package:flutterwave_payment/src/common/validator_utills.dart';
import 'package:flutterwave_payment/src/dto/charge_request_body.dart';
import 'package:flutterwave_payment/src/exception/exception.dart';
import 'package:flutterwave_payment/src/manager/base_transaction_manager.dart';

class AccountTransactionManager extends BaseTransactionManager {
  AccountTransactionManager(
      {@required BuildContext context,
      @required TransactionComplete onTransactionComplete})
      : super(context: context, onTransactionComplete: onTransactionComplete);

  @override
  charge() async {
    setConnectionState(ConnectionState.waiting);
    try {
      var response = await service.charge(
        ChargeRequestBody.fromPayload(payload: payload, type: "account"),
      );
      setConnectionState(ConnectionState.done);

      flwRef = response.flwRef;

      if (response.hasData) {
        final authUrl = response.authUrl;
        final authUrlIsValid = ValidatorUtils.isUrlValid(authUrl);
        if (authUrlIsValid) {
          showWebAuthorization(authUrl);
        } else {
          if (response.validateInstruction != null) {
            onOtpRequested(response.validateInstruction);
          } else if (response.validateInstructions != null) {
            onOtpRequested(response.validateInstructions);
          } else {
            onOtpRequested();
          }
        }
      } else {
        handleError(e: RaveException(data: Strings.noResponseData));
      }
    } on RaveException catch (e) {
      handleError(e: e);
    }
  }
}
