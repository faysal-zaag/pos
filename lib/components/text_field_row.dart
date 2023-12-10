import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:pos/components/test_receipt.dart';

class TextFieldRow extends StatefulWidget {
  const TextFieldRow({super.key});

  @override
  _TextFieldRowState createState() => _TextFieldRowState();
}

class _TextFieldRowState extends State<TextFieldRow> {

  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final TextEditingController controller3 = TextEditingController();
  final TextEditingController controller4 = TextEditingController();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();

  @override
  void initState() {
    super.initState();
    controller1.addListener(_onTextChanged);
    controller2.addListener(_onTextChanged);
    controller3.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();

    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();

    super.dispose();
  }

  void _onTextChanged() {
    if (controller3.text.length >= 3) {
      FocusScope.of(context).requestFocus(focusNode4);
    } else if (controller2.text.length >= 3) {
      FocusScope.of(context).requestFocus(focusNode3);
    } else if (controller1.text.length >= 3) {
      FocusScope.of(context).requestFocus(focusNode2);
    }
  }

  String message = "";
  String ipAddress = "";
  bool success = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: controller1,
                  focusNode: focusNode1,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  style: const TextStyle(fontSize: 20.0),
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: controller2,
                  focusNode: focusNode2,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  style: const TextStyle(fontSize: 20.0),
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: controller3,
                  focusNode: focusNode3,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  style: const TextStyle(fontSize: 20.0),
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: controller4,
                  focusNode: focusNode4,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  style: const TextStyle(fontSize: 20.0,),
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

          ],
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              loading = true;
              setState(() {
                ipAddress =
                "${controller1.text}.${controller2.text}.${controller3.text}.${controller4.text}";
              });

              const PaperSize paper = PaperSize.mm80;
              final profile = await CapabilityProfile.load();
              final printer = NetworkPrinter(paper, profile);

              final PosPrintResult res =
              await printer.connect(ipAddress, port: 9100);

              if (res == PosPrintResult.success) {
                setState(() {
                  success = true;
                  message = "Printer Connected Successfully";
                  loading = false;
                });
              }
              else{
                setState(() {
                  message = "Printer Not Found!!!";
                  loading = false;
                });
              }
            },
            child: const Text('Connect'),
          ),
        ),
        Container(margin:const EdgeInsets.symmetric(vertical: 20),child: loading ? const CircularProgressIndicator(color: Colors.red,) : Text(message)),
        // success ?
        // ElevatedButton.icon(
        //   onPressed: () async{
        //     loading = true;
        //     const PaperSize paper = PaperSize.mm80;
        //     final profile = await CapabilityProfile.load();
        //     final printer = NetworkPrinter(paper, profile);
        //
        //     final PosPrintResult res =
        //         await printer.connect(ipAddress, port: 9100);
        //
        //     if (res == PosPrintResult.success) {
        //       testReceipt(printer);
        //     }
        //     else{
        //       setState(() {
        //         message = "Printer Not Connected";
        //         loading = false;
        //       });
        //     }
        //   },
        //   label: const Text("Print"),
        //   icon: const Icon(Icons.print),
        // )
        // : Container(),
      ],
    );
  }
}
