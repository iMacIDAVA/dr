import 'package:flutter/material.dart';

Divider customDivider() {
  return const Divider(color: Colors.black12, height: 2, thickness: 1);
}

Divider customDividerRating() {
  return const Divider(
      color: Colors.black12,
      height: 2,
      indent: 80.0,
      endIndent: 20.0,
      thickness: 1);
}

Padding customPaddingRating() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 1.0),
    child: Container(
        height: 1.0,
        width: 240.0,
        //color:Colors.black12,
        color: const Color.fromRGBO(232, 236, 241, 1)),
  );
}

Padding customPaddingMeniuProfil() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 1.0),
    child: Container(
      height: 1.0,
      width: 345.0,
      //color:Colors.black12,
      color: const Color.fromRGBO(240, 242, 246, 1),
    ),
  );
}

Padding customPaddingProfilulMeu() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 1.0),
    child: Container(
      height: 1.0,
      width: 345.0,
      //color:Colors.black12,
      color: const Color.fromRGBO(240, 242, 246, 1),
    ),
  );
}

Padding customPaddingTermeniSiConditii() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 1.0),
    child: Container(
      height: 1.0,
      width: 345.0,
      //color:Colors.black12,
      color: const Color.fromRGBO(240, 242, 246, 1),
    ),
  );
}

Padding customPaddingChestionar() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 1.0),
    child: Container(
        height: 1.0,
        width: 341.0,
        //color:Colors.black12,
        color: const Color.fromRGBO(219, 220, 222, 1)),
  );
}
