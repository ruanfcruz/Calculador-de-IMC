import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String _result = 'Informe seus dados';

  @override
  void initState() {
    super.initState();
    resetFields();
  }

  void resetFields() {
    _weightController.text = '';
    _heightController.text = '';
    setState(() {
      _result = 'Informe seus dados';
    });
  }

  void calculateImc() {
    double weight = double.tryParse(_weightController.text) ?? 0;
    double height = (double.tryParse(_heightController.text) ?? 0) / 100.0;

    if (weight <= 0 || height <= 0) {
      setState(() {
        _result = 'Valores inválidos';
      });
      return;
    }

    double imc = weight / (height * height);

    setState(() {
      _result = "IMC = ${imc.toStringAsPrecision(4)}\n";
      if (imc < 18.6)
        _result += "Abaixo do peso";
      else if (imc < 25.0)
        _result += "Peso ideal";
      else if (imc < 30.0)
        _result += "Levemente acima do peso";
      else if (imc < 35.0)
        _result += "Obesidade Grau I";
      else if (imc < 40.0)
        _result += "Obesidade Grau II";
      else
        _result += "Obesidade Grau III";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: buildForm(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Calculadora de IMC'),
      backgroundColor: Colors.blue,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: resetFields,
        ),
      ],
    );
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildTextFormField(
            label: "Peso (kg)",
            error: "Insira seu peso!",
            controller: _weightController,
          ),
          buildTextFormField(
            label: "Altura (cm)",
            error: "Insira uma altura!",
            controller: _heightController,
          ),
          buildTextResult(),
          buildCalculateButton(),
        ],
      ),
    );
  }

  Padding buildCalculateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            calculateImc();
          }
        },
        child: const Text(
          'CALCULAR',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Padding buildTextResult() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36.0),
      child: Text(
        _result,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  TextFormField buildTextFormField({
    required TextEditingController controller,
    required String error,
    required String label,
  }) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      controller: controller,
      validator: (text) {
        if (text == null || text.isEmpty) {
          return error;
        }
        return null;
      },
    );
  }
}
