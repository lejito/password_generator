import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class PasswordGenerator extends StatefulWidget {
  @override
  _PasswordGeneratorState createState() => _PasswordGeneratorState();
}

enum Difficulty { easyToSay, allCharacters }

class _PasswordGeneratorState extends State<PasswordGenerator> {
  String _generatedPassword = '';
  double _passwordLength = 8;
  final double _minPasswordLength = 4;
  final double _maxPasswordLength = 20;
  final TextEditingController _passwordLengthController =
      TextEditingController();

  Difficulty _difficulty = Difficulty.allCharacters;
  bool _isUppercase = true;
  bool _isLowercase = true;
  bool _isNumbers = true;
  bool _isSymbols = true;

  @override
  void initState() {
    super.initState();
    _passwordLengthController.text = '8';
  }

  bool _validateInput(String value) {
    int? numberValue = int.tryParse(value);
    return numberValue != null &&
        numberValue >= _minPasswordLength &&
        numberValue <= _maxPasswordLength;
  }

  void _generatePassword() {
    String upper = _isUppercase ? 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' : '';
    String lower = _isLowercase ? 'abcdefghijklmnopqrstuvwxyz' : '';
    String numbers = _isNumbers ? '0123456789' : '';
    String symbols = _isSymbols ? '!@#%^&*()_+' : '';
    String chars = '$upper$lower$numbers$symbols';

    Random rnd = Random.secure();

    setState(() {
      _generatedPassword = String.fromCharCodes(Iterable.generate(
        _passwordLength.toInt(),
        (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
      ));
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _generatedPassword));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contraseña copiada al portapapeles'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _passwordLength,
                    min: _minPasswordLength,
                    max: _maxPasswordLength,
                    divisions: 16,
                    label: _passwordLength.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _passwordLength = value;
                        _passwordLengthController.text =
                            value.round().toString();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _passwordLengthController,
                    keyboardType: TextInputType.number,
                    onSubmitted: (String value) {
                      if (_validateInput(value)) {
                        setState(() {
                          _passwordLength = double.tryParse(value) ?? 8;
                        });
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                    decoration: InputDecoration(
                      errorText: _validateInput(_passwordLengthController.text)
                          ? null
                          : 'El valor debe estar entre $_minPasswordLength y $_maxPasswordLength',
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                RadioListTile<Difficulty>(
                  title: const Text('Fácil de decir'),
                  value: Difficulty.easyToSay,
                  groupValue: _difficulty,
                  onChanged: (Difficulty? value) {
                    setState(() {
                      _difficulty = value!;
                      _isUppercase = true;
                      _isLowercase = true;
                      _isNumbers = false;
                      _isSymbols = false;
                    });
                  },
                ),
                RadioListTile<Difficulty>(
                  title: const Text('Todos los caracteres'),
                  value: Difficulty.allCharacters,
                  groupValue: _difficulty,
                  onChanged: (Difficulty? value) {
                    setState(() {
                      _difficulty = value!;
                      _isUppercase = true;
                      _isLowercase = true;
                      _isNumbers = true;
                      _isSymbols = true;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Mayúsculas'),
                  value: _isUppercase,
                  onChanged: (bool? value) {
                    setState(() {
                      if (!value! &&
                          !_isLowercase &&
                          !_isNumbers &&
                          !_isSymbols) {
                        return;
                      }
                      _isUppercase = value;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Minúsculas'),
                  value: _isLowercase,
                  onChanged: (bool? value) {
                    setState(() {
                      if (!value! &&
                          !_isUppercase &&
                          !_isNumbers &&
                          !_isSymbols) {
                        return;
                      }
                      _isLowercase = value;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Números'),
                  value: _isNumbers,
                  onChanged: (bool? value) {
                    setState(() {
                      if (!value! &&
                          !_isUppercase &&
                          !_isLowercase &&
                          !_isSymbols) {
                        return;
                      }
                      _isNumbers = value;
                    });
                  },
                  enabled: _difficulty == Difficulty.allCharacters,
                ),
                CheckboxListTile(
                  title: const Text('Símbolos'),
                  value: _isSymbols,
                  onChanged: (bool? value) {
                    setState(() {
                      if (!value! &&
                          !_isUppercase &&
                          !_isLowercase &&
                          !_isNumbers) {
                        return;
                      }
                      _isSymbols = value;
                    });
                  },
                  enabled: _difficulty == Difficulty.allCharacters,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _generatePassword,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: const Text(
                'Generar contraseña',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Aquí aparecerá la contraseña generada',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: _copyToClipboard,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                controller: TextEditingController(text: _generatedPassword),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
