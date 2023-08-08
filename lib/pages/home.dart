import 'package:calculadora_imc_flutter/models/imc_model.dart';
import 'package:calculadora_imc_flutter/repositories/imc_repository.dart';
import 'package:calculadora_imc_flutter/utils/shared_prefs.dart';
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
  String? nomeUsuario;

  TextEditingController alturaController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController nomeController = TextEditingController();

  void registrarImc() async {
    double? peso = double.tryParse(pesoController.text.replaceAll(',', '.'));
    double? altura =
        double.tryParse(alturaController.text.replaceAll(',', '.'));

    if (peso != null && altura != null) {
      imcRepository.registrarImc(peso, altura);
      carregarDados();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Peso ou Altura inválidos!'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  void carregarDados() async {
    nomeUsuario = await SharedPrefs.getUsername();
    _imcs = await imcRepository.getImcs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Olá ${nomeUsuario ?? ''}, registre seu IMC!',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text(
                              'Configurações',
                              textAlign: TextAlign.center,
                            ),
                            content: Wrap(
                              children: [
                                TextField(
                                  controller: nomeController,
                                  decoration:
                                      const InputDecoration(hintText: "Nome"),
                                )
                              ],
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    SharedPrefs.setUsername(
                                        nomeController.text);
                                    Navigator.pop(context);
                                    carregarDados();
                                  },
                                  child: const Text('Salvar'))
                            ],
                          );
                        });
                  },
                  child: const Icon(Icons.settings)),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            pesoController.text = '';
            alturaController.text = '';

            showDialog(
                context: context,
                builder: (_) {
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
                  return Dismissible(
                    key: Key(registro.id.toString()),
                    onDismissed: (_) async {
                      await imcRepository.deletarImc(registro.id!);
                      carregarDados();
                    },
                    confirmDismiss: (_) async {
                      return await showDialog(
                          context: context,
                          builder: (BuildContext bc) {
                            return AlertDialog(
                              title: const Text(
                                'Deletar esse registro?',
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(bc).pop(false),
                                        child: const Row(
                                          children: [
                                            Icon(Icons.cancel, size: 36),
                                            Text(
                                              'Cancelar',
                                              style: TextStyle(fontSize: 18),
                                            )
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(bc).pop(true),
                                        child: const Row(
                                          children: [
                                            Icon(Icons.delete, size: 36),
                                            Text(
                                              'Deletar',
                                              style: TextStyle(fontSize: 18),
                                            )
                                          ],
                                        )),
                                  ],
                                )
                              ],
                            );
                          });
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 8),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: registro.corStatus.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: registro.corStatus, width: 8),
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }));
  }
}
