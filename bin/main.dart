/*

  IMPLEMENTATION OF SPECK64/128 CIPHER IN DART PROGRAMMING LANGUAGE

  Main code
  
*/

import 'package:speck_cipher/speck_cipher.dart';

SpeckCipher speckCipher = new SpeckCipher();

void main(List<String> arguments) async {
  //reference key
  List<int> k = [
    0x00,
    0x01,
    0x02,
    0x03,
    0x08,
    0x09,
    0x0a,
    0x0b,
    0x10,
    0x11,
    0x12,
    0x13,
    0x18,
    0x19,
    0x1a,
    0x1b
  ];
  //reference plain text in bytes
  List<int> pt = [0x2d, 0x43, 0x75, 0x74, 0x74, 0x65, 0x72, 0x3b];
  //reference plain text in int32
  List<int> refPln = [0x7475432d, 0x3b726574];
  //reference encrypted text in int32
  List<int> refEnc = [0x454e028b, 0x8c6fa548];
  //will contain round key buffer in int32
  List<int> K = List<int>.filled(k.length ~/ 4, 0);
  //will contain plain text in int32
  List<int> Pt = List<int>.filled(pt.length ~/ 4, 0);

  print('IMPLEMENTATION OF SPECK64/128 CIPHER IN DART');
  // plain text: bytes -> int32
  speckCipher.bytesToWord32(pt, Pt);
  bool equal = true;
  print('Plaintext (in int32): ');
  print('Converted\tReference');
  for (int i = 0; i < Pt.length; i++) {
    print(Pt[i].toRadixString(16) + '\t' + refPln[i].toRadixString(16));
    if (Pt[i] != refPln[i]) equal = false;
  }
  print('Conversion correctly executed? $equal');

  //key
  speckCipher.bytesToWord32(k, K);
  /*
  print('Key (in int32): ');
  for (int i = 0; i < K.length; i++) {
    print(K[i].toRadixString(16));
  }
  */

  List<int> Ct = [0, 0];
  List<int> rk = List<int>.filled(27, 0);
  speckCipher.keySchedule(K, rk);
  speckCipher.encrypt(Pt, Ct, rk);

  equal = true;
  print('\nCipher text: (in int32): ');
  print('Encrypted\tReference');
  for (int i = 0; i < Ct.length; i++) {
    print(Ct[i].toRadixString(16) + '\t' + refEnc[i].toRadixString(16));
    if (Ct[i] != refEnc[i]) equal = false;
  }
  print('Encryption correctly executed? $equal');

  int l = Pt.length;
  Pt = List<int>.filled(l, 0);
  speckCipher.decrypt(Pt, Ct, rk);
  equal = true;
  print('\nReverted plain text: (in int32): ');
  print('Decrypted\tReference');
  for (int i = 0; i < Pt.length; i++) {
    print(Pt[i].toRadixString(16) + '\t' + refPln[i].toRadixString(16));
    if (Pt[i] != refPln[i]) equal = false;
  }
  print('Decryption correctly executed? $equal');
}
