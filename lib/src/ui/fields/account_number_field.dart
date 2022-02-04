import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterwave_payment/src/common/strings.dart';
import 'package:flutterwave_payment/src/common/validator_utills.dart';
import 'package:flutterwave_payment/src/ui/fields/base_field.dart';

class AccountNumberField extends BaseTextField {
  AccountNumberField({
    required FormFieldSetter<String> onSaved,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    ValueChanged<String>? onFieldSubmitted,
  }) : super(
          labelText: 'ACCOUNT NUMBER',
          hintText: '1234567789',
          onSaved: onSaved,
          validator: (String? value) => validatePhoneNum(value),
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          textInputAction: textInputAction,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10)
          ],
        );

  static String? validatePhoneNum(String? input) {
    return ValidatorUtils.isAccountValid(input)
        ? null
        : Strings.invalidAccountNumber;
  }
}
