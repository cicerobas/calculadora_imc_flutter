import 'package:calculadora_imc_flutter/models/imc_model.dart';
import 'package:calculadora_imc_flutter/utils/sqlite_database.dart';
import 'package:flutter/material.dart';

class IMCRepository {
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

  Future<void> registrarImc(double peso, double altura) async {
    final db = await SQLiteDatabase().getDb();
    double imc = setImc(peso, altura);
    String status = setStatus(imc);
    var novoIMC = IMCModel(null, peso, altura, imc, status, statusCor[status]!);
    await db.insert('imcs', novoIMC.imcToMap());
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

  Future<List<IMCModel>> getImcs() async {
    final db = await SQLiteDatabase().getDb();
    final List<Map<String, dynamic>> map = await db.query('imcs');
    return List.generate(map.length, (index) {
      return IMCModel(
          map[index]['id'],
          map[index]['peso'],
          map[index]['altura'],
          map[index]['imc'],
          map[index]['status'],
          Color(map[index]['cor']));
    });
  }
}
