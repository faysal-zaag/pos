import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_iot_wifi/flutter_iot_wifi.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos/components/printer.dart';
import 'package:pos/components/text_field_row.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.red,
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          )),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ))),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String? _printerChoose;
  String selectedPrinter = "";
  List<dynamic> printerList = [];

  // void addPrinter(){
  //   setState(() {
  //     printerList.add(PrinterModel("name", "ipAddress", 9100));
  //   });
  // }

  void _onDropDownItemSelected(String newSelectedPrinter) {
    setState(() {
      selectedPrinter = newSelectedPrinter;
      _printerChoose = newSelectedPrinter;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndList();
  }

  Future<void> _checkPermissionsAndList() async {
    if (Platform.isIOS || await Permission.location.request().isGranted) {
      await FlutterIotWifi.scan();
      await _list(); // Await the _list function
      setState(() {
        // Update the widget to reflect the changes in wifiList
      });
    } else {
      print("Don't have permission");
    }
  }

  Future<void> _list() async {
    printerList = await FlutterIotWifi.list();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {

              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("POS System"),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton.icon(
            //     onPressed: () {
            //       _showAlertDialog(context, printerList, addPrinter);
            //     },
            //     label: const Text("Add Printer"),
            //     icon: const Icon(Icons.add),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.red),
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<dynamic>(
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontFamily: "verdana_regular",
                          ),
                          hint: const Text(
                            "Select Network",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontFamily: "verdana_regular",
                            ),
                          ),
                          items: printerList
                              .map<DropdownMenuItem<dynamic>>(
                                  (dynamic value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value)
                                );
                              }).toList(),
                          isExpanded: true,
                          isDense: true,
                          onChanged: (dynamic newSelectedPrinter) {
                            _onDropDownItemSelected(newSelectedPrinter!);
                            _showAlertDialog(context, newSelectedPrinter);
                          },
                          value: _printerChoose,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _showAlertDialog(BuildContext context, dynamic printerName) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter IP Address for $printerName'),
        content: const SingleChildScrollView(
          child: TextFieldRow(),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Add'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}