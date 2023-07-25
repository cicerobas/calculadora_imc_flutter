import 'package:flutter/material.dart';

class IMCModel {
  final double _peso;
  final double _altura;
  final double _imc;
  final String _status;
  final Color _corStatus;

  IMCModel(this._peso, this._altura, this._imc, this._status, this._corStatus);

  double get peso => _peso;
  double get altura => _altura;
  double get imc => _imc;
  String get status => _status;
  Color get corStatus => _corStatus;
}
