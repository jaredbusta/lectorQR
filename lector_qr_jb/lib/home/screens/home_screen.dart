import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_des/flutter_des.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

const String _texto_para_encriptar = """
Esta es la cadena que se supone que va a encriptar 
Java, android, ios, get the same result by DES encryption and decryption.""";

class _HomeScreenState extends State<HomeScreen> {
  static const _key = "jared_pass";
  // static const _iv = "12345678";
  final TextEditingController _controller = TextEditingController();
  String _encryptBase64 = '';
  String _decryptBase64 = '';
  String _text = _texto_para_encriptar;

  Future<void> crypt() async {
    if (_text.isEmpty) {
      _text = _texto_para_encriptar;
    }
    print("dentro decrypt()");
    try {
      // iv: _iv
      _encryptBase64 = await FlutterDes.encryptToBase64(_text, _key);
      _decryptBase64 = await FlutterDes.decryptFromBase64(_encryptBase64, _key);
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    crypt();
    _controller.addListener(() {
      _text = _controller.text;
      crypt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(
        child: ListView(
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  _controller.text =
                      "Ahora este es el texto encriptado ${DateTime.now()}";
                });
              },
              child: Container(
                margin: const EdgeInsets.all(20),
                child: const Text("botonazo para cambiar la cadena"),
              ),
            ),
            const Chip(
              labelPadding: EdgeInsets.all(5),
              avatar: CircleAvatar(
                child: Text('key'),
              ),
              label: Text(_key),
            ),
            // const Chip(
            //   avatar: CircleAvatar(
            //     backgroundColor: Colors.red,
            //     child: Text('iv'),
            //   ),
            //   label: Text(_iv),
            // ),
            _build('Base64', _encryptBase64, _decryptBase64 ?? ''),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Widget _build(String tag, String string, String result) {
    return Row(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: 60,
            padding: const EdgeInsets.all(3.0),
            color: Colors.grey.shade800,
            child: Text(
              tag,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              print("on tap");
              await Clipboard.setData(ClipboardData(text: string));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("copiado"),
                duration: Duration(milliseconds: 200),
              ));
            },
            child: Column(
              children: <Widget>[
                Text(
                  string,
                  softWrap: true,
                  maxLines: 100,
                ),
                const Divider(),
                Text(
                  result,
                  softWrap: true,
                  maxLines: 100,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
