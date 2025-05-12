import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(ClimaApp());
}

class ClimaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClimaApp',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ClimaHomePage(),
    );
  }
}

class ClimaHomePage extends StatefulWidget {
  @override
  _ClimaHomePageState createState() => _ClimaHomePageState();
}

class _ClimaHomePageState extends State<ClimaHomePage> {
  final TextEditingController _controller = TextEditingController();
  String _resultado = '';
  bool _carregando = false;

  Future<void> _buscarClima(String cidade) async {
    setState(() {
      _carregando = true;
    });

    final apiKey = 'dfeb4719a35a4f8fced8f85d48c47aa4';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cidade&appid=$apiKey&lang=pt_br&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        final temp = data['main']['temp'];
        final descricao = data['weather'][0]['description'];

        setState(() {
          _resultado = 'Temperatura em $cidade: ${temp}°C\nTempo: $descricao';
        });
      } else {
        setState(() {
          _resultado = 'Cidade não encontrada.';
        });
      }
    } catch (e) {
      setState(() {
        _resultado = 'Erro ao buscar o clima.';
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ClimApp')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Digite o nome da cidade',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _carregando
                  ? null
                  : () {
                      _buscarClima(_controller.text);
                    },
              child: Text('Buscar'),
            ),
            SizedBox(height: 24),
            if (_carregando) CircularProgressIndicator(),
            if (_resultado.isNotEmpty) Text(_resultado, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
