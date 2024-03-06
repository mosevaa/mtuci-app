
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_of_mtuci/api.dart';
import 'package:voice_of_mtuci/src/pages/recorder/recorder_screen.dart';
import 'package:voice_of_mtuci/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  static const tokenKey = 'token';
  final formKey = GlobalKey<FormState>();
  String _token = '';
  String _name = '';

  @override
  void initState() {
    _initToken();
    super.initState();
  }

  Future _initToken() async {
    _token = await _getToken();
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey) ?? '';
  }

  Future _setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(tokenKey, token);
  }

  Future<void> loginHandler() async {
    final form = formKey.currentState;
    form!.save();
    await performLogin();
  }

  Future<void> performLogin() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    final api = MyApi();
    final res = await api.login(_token, _name);

    if (res.statusCode == 401) {
      print('401');
    } else if (res.statusCode == 204) {
      _setToken(_token);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RecorderScreen(),
          ));
    } else {
      print(res.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    _getToken().then((value) {
      if (value != '') {
        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RecorderScreen(),
                          ));
      }
    });
    return Scaffold(
                  body: SafeArea(
                child: Center(
                  child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 400.0,
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: "API токен"),
                              onSaved: (val) => _token = val!,
                            ),
                          ),
                          Container(
                            width: 400.0,
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: "Имя оператора"),
                              onSaved: (val) => _name = val ?? '',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25.0),
                            child: TextButton(
                              style: kButtonStyle,
                              onPressed: loginHandler,
                              child: const Text(
                                "ВХОД",
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ));
  }
}
