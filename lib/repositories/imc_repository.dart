import 'package:calculadora_imc_flutter/models/imc_model.dart';
import 'package:flutter/material.dart';

/*
 < 16        | Magreza grave
 16 a < 17   | Magreza moderada
 17 a < 18,5 | Magreza leve
 18,5 a < 25 | Saldável
 25 a < 30   | Sobrepeso
 30 a < 35   | Obesidade Grau 1
 35 a < 40   | Obesidade Grau 2 (severa)
 >= 40       | Obesidade Grau 3 (mórbida)

 IMC = peso(Kg) / altura²(m)
 
 */

class IMCRepository {
  List<IMCModel> _imcs = [];

  Map<String, Color> statusCor = {
    'Magreza Grave': const Color(0xffC7731B),
    'Magreza Moderada': const Color(0xff7AA2CB),
    'Magreza Leve': const Color(0xff7AA2CB),
    'Saldável': const Color(0xff76A67E),
    'Sobrepeso': const Color(0xffE3C651),
    'Obesidade I': const Color(0xffC23723),
    'Obesidade II Severa': const Color(0xffC22339),
    'Obesidade III Mórbida': const Color(0xffC22339),
  };

  void registrarImc(double peso, double altura) {
    double imc = setImc(peso, altura);
    String status = setStatus(imc);
    _imcs.add(IMCModel(peso, altura, imc, status, statusCor[status]!));
  }

  double setImc(double peso, double altura) => peso / (altura * altura);

  String setStatus(double imc) {
    switch (imc) {
      case < 16:
        return "Magreza Grave";
      case < 17:
        return "Magreza Moderada";
      case < 18.5:
        return "Magreza Leve";
      case < 25:
        return "Saldável";
      case < 30:
        return "Sobrepeso";
      case < 35:
        return "Obesidade I";
      case < 40:
        return "Obesidade II Severa";
      default:
        return "Obesidade III Mórbida";
    }
  }

  List<IMCModel> getImcs() => _imcs;
}
