import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

class NfcScreen extends StatelessWidget {
  TextEditingController result_controller = new TextEditingController();

  NfcScreen({Key key}) : super(key: key);
  ValueNotifier<dynamic> result = ValueNotifier(null);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FutureBuilder(
      future: NfcManager.instance.isAvailable(),
      builder: (context, snapshot) {
        if (snapshot.data != true) {
          return Center(
              child: Text('NfcManager.isAvailable(): ${snapshot.data}'));
        } else {
          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.vertical,
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.all(4),
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(border: Border.all()),
                  child: SingleChildScrollView(
                    child: ValueListenableBuilder<dynamic>(
                      valueListenable: result,
                      builder: (context, value, _) => Column(
                        children: [
                          Text('${value ?? ''}'),
                          Container(
                            margin: EdgeInsets.only(
                                top: 10, left: 20, right: 20, bottom: 10),
                            child: TextField(
                              controller: result_controller,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: GridView.count(
                  padding: EdgeInsets.all(4),
                  crossAxisCount: 2,
                  childAspectRatio: 4,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  children: [
                    ElevatedButton(
                        child: Text('Leer tag'), onPressed: _tagRead),
                    // ElevatedButton(
                    //     child: Text('Limpia'),
                    //     onPressed: () {
                    //       result_controller.clear();
                    //     }),
                    // ElevatedButton(     child: Text('Ndef Write'), onPressed: _ndefWrite),
                    // ElevatedButton(
                    //     child: Text('Ndef Write Lock'),
                    //     onPressed: _ndefWriteLock),
                  ],
                ),
              ),
            ],
          );
        }
      },
    ));
  }

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      var ndef = Ndef.from(tag);
      var identifier = (NfcA.from(tag)?.identifier ??
          NfcB.from(tag)?.identifier ??
          NfcF.from(tag)?.identifier ??
          NfcV.from(tag)?.identifier ??
          Uint8List(0));

      print(identifier.runtimeType);
      for (var i in identifier) {
        print(i.toRadixString(16));
      }

      var _identifier =
          identifier.map((e) => e.toRadixString(16)).join(" ").toUpperCase();
      result_controller.text = _identifier;
      NfcManager.instance.stopSession();
    });
  }

  void _ndefWrite() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        result.value = 'Tag is not ndef writable';
        NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createText('Hello World!'),
        NdefRecord.createUri(Uri.parse('https://flutter.dev')),
        NdefRecord.createMime(
            'text/plain', Uint8List.fromList('Hello'.codeUnits)),
        NdefRecord.createExternal(
            'com.example', 'mytype', Uint8List.fromList('mydata'.codeUnits)),
      ]);

      try {
        await ndef.write(message);
        result.value = 'Success to "Ndef Write"';
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }

  void _ndefWriteLock() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null) {
        result.value = 'Tag is not ndef';
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }

      try {
        await ndef.writeLock();
        result.value = 'Success to "Ndef Write Lock"';
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }
}
