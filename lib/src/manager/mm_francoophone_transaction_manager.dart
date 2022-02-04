import 'package:flutter/cupertino.dart' hide State, ConnectionState;
import 'package:flutter/material.dart' hide State, ConnectionState;
import 'package:flutterwave_payment/flutterwave_payment.dart';
import 'package:flutterwave_payment/src/blocs/connection_bloc.dart';
import 'package:flutterwave_payment/src/common/strings.dart';
import 'package:flutterwave_payment/src/dto/charge_request_body.dart';
import 'package:flutterwave_payment/src/exception/exception.dart';
import 'package:flutterwave_payment/src/manager/base_transaction_manager.dart';

class MMFrancophoneTransactionManager extends BaseTransactionManager {
  MMFrancophoneTransactionManager(
      {required BuildContext context,
      required TransactionComplete onTransactionComplete})
      : super(
          context: context,
          onTransactionComplete: onTransactionComplete,
        );

  @override
  charge() async {
    setConnectionState(ConnectionState.waiting);
    try {
      var response = await service!.charge(
        ChargeRequestBody.fromPayload(
            payload: payload!..isMobileMoneyFranco = true,
            type: "mobilemoneyfranco"),
      );
      setConnectionState(ConnectionState.done);

      flwRef = response.flwRef;

      if (!response.hasData) {
        handleError(e: RaveException(data: Strings.noResponseData));
        return;
      }

      onTransactionComplete(RaveResult(
          status: response.status!.toLowerCase() == "success"
              ? RaveStatus.success
              : RaveStatus.error,
          rawResponse: response.rawResponse,
          message: response.message));
    } on RaveException catch (e) {
      handleError(e: e);
    }
  }
}
