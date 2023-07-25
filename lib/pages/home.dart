import 'package:calculadora_imc_flutter/models/imc_model.dart';
import 'package:calculadora_imc_flutter/repositories/imc_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var imcRepository = IMCRepository();
  var _imcs = <IMCModel>[];

  TextEditingController alturaController = TextEditingController();
  TextEditingController pesoController = TextEditingController();

  void registrarImc() {
    double? peso = double.tryParse(pesoController.text.replaceAll(',', '.'));
    double? altura =
        double.tryParse(alturaController.text.replaceAll(',', '.'));

    if (peso != null && altura != null) {
      imcRepository.registrarImc(peso, altura);
      setState(() {
        _imcs = imcRepository.getImcs();
      });
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Peso ou Altura inválidos!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Calculadora IMC',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            pesoController.text = '';
            alturaController.text = '';

            showDialog(
                context: context,
                builder: (BuildContext bc) {
                  return AlertDialog(
                    title: const Text(
                      'Registrar IMC',
                      textAlign: TextAlign.center,
                    ),
                    content: Wrap(
                      children: [
                        TextField(
                          controller: pesoController,
                          decoration:
                              const InputDecoration(hintText: "Peso (Kg)"),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))
                          ],
                        ),
                        TextField(
                          controller: alturaController,
                          decoration:
                              const InputDecoration(hintText: "Altura (m)"),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))
                          ],
                        )
                      ],
                    ),
                    actions: [
                      TextButton(
                          child: const Text("Cancelar"),
                          onPressed: () => Navigator.pop(context)),
                      TextButton(
                          child: const Text("Adicionar"),
                          onPressed: () {
                            registrarImc();
                          }),
                    ],
                  );
                });
          },
          child: const Icon(Icons.add),
        ),
        body: _imcs.isEmpty
            ? const Center(
                child: Text(
                  'Nenhum Registro',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                itemCount: _imcs.length,
                itemBuilder: (BuildContext bc, int index) {
                  var registro = _imcs[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: registro.corStatus.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: registro.corStatus, width: 8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Peso ${registro.peso.toString()} Kg',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Altura ${registro.altura.toString()} m',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'IMC ${registro.imc.toStringAsFixed(1)}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              Text(
                                registro.status,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }));
  }
}
