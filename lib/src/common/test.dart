import 'dart:convert';

import 'package:dart_des/dart_des.dart';

main() async {
  // var key = "cipher";
  // BlockCipher blockCipher = await BlockCipher(TripleDESEngine(), key);
  // print("1 works");
  // String message = "Driving in from the edge of town";
  // var ciphertext = blockCipher.encodeB64(message);
  // print("2 works");
  // var decoded = blockCipher.decodeB64(ciphertext);
  // print("3 works");

  // print("key: $key");
  // print("message: $message");
  // print("ciphertext (base64): $ciphertext");
  // print(blockCipher);

  // const string = "my name is flutter";
  // const keys = "702040801020305070B0D1101020305070B0D1112110D0B0";
  // const iv = "070B0D1101020305";

  // var encrypt = await Flutter3des.encrypt(string, keys, iv: iv);
  // var data = base64.encode(encrypt);
  // print(data);

  String key = '12345678'; // 8-byte
  String message = 'Driving in from the edge of town';
  List<int> encrypted;
  List<int> decrypted;
  print('key: $key');
  print('message: $message');

  DES desECB = DES(key: key.codeUnits, mode: DESMode.ECB);
  encrypted = desECB.encrypt(message.codeUnits);
  print('encrypted (base64): ${base64.encode(encrypted)}');
}
