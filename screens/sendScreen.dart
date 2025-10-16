import 'dart:io';
import 'package:excel/excel.dart' as excell;
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quadsender/classes/variables.dart';
import 'package:quadsender/screens/sendScreen.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({Key? key}) : super(key: key);

  @override
  State<SendScreen> createState() => SendScreenState();
}

bool isenabled2 = true;
bool isenabled = true;
String url = Variables().url;
Map<String, bool> numbers = {};
class SendScreenState extends State<SendScreen> {
  

  int totalNumbers = 0; // Total numbers to send
  int sentCount = 0;
  bool sending = false;
  bool mediaDragAreaActive = false;
  String path = "";
  String name = "";

  bool mediaDragAreaActive2 = false;
  String path2 = "";
  String name2 = "";

  
  Map<String, bool> sentNumbers = {};
  int currentIndex = 0;
  TextEditingController messageController = TextEditingController();
  TextEditingController secondsController = TextEditingController(text: "7");
  sendMessages() async {
    // print("Here");
    if (sending) {
      String phone = numbers.keys.elementAt(currentIndex);
      // print(phone);
      try {
        if (path != "") {
          // has media
          http.Response sendMessage = await http.get(Uri.parse(
              "$url/sendMedia?phone=$phone&message=${messageController.text}&media=$path"));
          // print(
          //     "$url/sendMedia?phone=$phone&message=${messageController.text}&media=$path");
          if (sendMessage.statusCode == 202) {
            sentNumbers.addAll({phone: true});
          } else {
            sentNumbers.addAll({phone: false});
          }
        } else {
          // hasnot media
          http.Response sendMessage = await http.get(Uri.parse(
              "$url/send?phone=$phone&message=${messageController.text}"));
          // print("$url/send?phone=$phone&message=${messageController.text}");
          if (sendMessage.statusCode == 202) {
            sentNumbers.addAll({phone: true});
          } else {
            sentNumbers.addAll({phone: false});
          }
        }
      } catch (e) {
        setState(() {
          sending != sending;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
      await Future.delayed(Duration(
          seconds: int.parse(secondsController.text))); // Simulate delay
      setState(() {
        sentCount++;
        currentIndex++;
      });
      await sendMessages();
    }
  }
  addNumbers(List numbers2) {
    // setState(() {
      for (String number in numbers2) {
        numbers.addAll({number: false});
      }
    // });
  }
  @override
  Widget build(BuildContext context) {
    
    return Wrap(children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.5 - 10,
        height: 300,
        child: TextField(
          controller: messageController,
          decoration: InputDecoration(
            labelText: "Type Message....",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.green.shade900, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.green.shade900, width: 2),
            ),
          ),
          minLines: 15,
          maxLines: 1000,
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width * 0.5 - 10,
        height: 300,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: mediaDragAreaActive
                ? Colors.blue.withOpacity(0.7)
                : Colors.transparent,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            border: Border(
              bottom: BorderSide(color: Colors.green.shade900, width: 2),
              top: BorderSide(color: Colors.green.shade900, width: 2),
              left: BorderSide(color: Colors.green.shade900, width: 2),
              right: BorderSide(color: Colors.green.shade900, width: 2),
            )),
        child: Center(
          child: DropTarget(
            enable: isenabled,
            onDragEntered: (value) async {
              // print("HERE");
              setState(() {
                mediaDragAreaActive = true;
              });
              // print(mediaDragAreaActive);
            },
            onDragExited: (detail) {
              setState(() {
                mediaDragAreaActive = false; // Set hover state to false
              });
            },
            onDragDone: (value) {
              setState(() {
                path = value.files.first.path;
                name = value.files.first.name;
                // mediaDragAreaActive = !mediaDragAreaActive;
              });
            },
            child: name == ""
                ? const Text("Drop Media Here")
                : TextButton(
                    onPressed: () {
                      setState(() {
                        name = "";
                        path = "";
                      });
                    },
                    child: Image.file(File(path))),
          ),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width * 0.5 - 10,
        height: 300,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: mediaDragAreaActive2
                ? Colors.blue.withOpacity(0.7)
                : Colors.transparent,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            border: Border(
              bottom: BorderSide(color: Colors.green.shade900, width: 2),
              top: BorderSide(color: Colors.green.shade900, width: 2),
              left: BorderSide(color: Colors.green.shade900, width: 2),
              right: BorderSide(color: Colors.green.shade900, width: 2),
            )),
        child: Center(
          child: DropTarget(
              enable: isenabled2,
              onDragEntered: (value) async {
                // print("HERE");
                setState(() {
                  mediaDragAreaActive2 = true;
                });
                // print(mediaDragAreaActive);
              },
              onDragExited: (detail) {
                setState(() {
                  mediaDragAreaActive2 = false; // Set hover state to false
                });
              },
              onDragDone: (value) async {
                setState(() {
                  path2 = value.files.first.path;
                  name2 = value.files.first.name;
                  // mediaDragAreaActive = !mediaDragAreaActive;
                });
                numbers = await Variables().readExcell(path2);
                setState(() {});
              },
              child: numbers.isEmpty
                  ? const Text("Drop Excel Numbers Here")
                  : !sending
                      ? ListView.builder(
                          shrinkWrap: true,
                          // reverse: true,
                          itemCount: numbers.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${index + 1}"),
                                // VerticalDivider(color: Colors.grey,width: 1,thickness: 1),
                                Text(numbers.keys.elementAt(index))
                              ],
                            );
                          })
                      : ListView.builder(
                          itemCount: sentNumbers.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            bool success = sentNumbers.values.elementAt(index);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                      color:
                                          success ? Colors.green : Colors.red),
                                ),
                                // VerticalDivider(color: Colors.grey,width: 1,thickness: 1),
                                Text(
                                  sentNumbers.keys.elementAt(index),
                                  style: TextStyle(
                                      color:
                                          success ? Colors.green : Colors.red),
                                )
                              ],
                            );
                          })),
        ),
      ),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5 - 10,
              // height: 300,
              child: TextField(
                controller: secondsController,
                decoration: InputDecoration(
                  labelText: "Delay in Seconds",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        BorderSide(color: Colors.green.shade900, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        BorderSide(color: Colors.green.shade900, width: 2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
            width: MediaQuery.of(context).size.width * 0.5 - 20,
            child: LinearProgressIndicator(
              value:
                  sending ? (sentCount / numbers.length) : 0, // Update progress
              backgroundColor: Colors.grey,
              color: Colors.green,
            ),
          ),
          // SizedBox(
          //   height:10,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text("0"),
          //       Text(numbers.length.toString())
          //     ]
          //   )
          // ),
          // const SizedBox(height: 10,),
          SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width * 0.5 - 20,
              child: Text(numbers.isNotEmpty
                  ? "Sent: $sentCount From ${numbers.length} (${(sentCount % numbers.length)}%)"
                  : "")),
          TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    !sending ? Colors.green.shade700 : Colors.red.shade700),
                overlayColor: MaterialStateProperty.all(
                    !sending ? Colors.green.shade900 : Colors.red.shade900),
              ),
              onPressed: () async {
                setState(() {
                  sending = !sending;
                });
                await sendMessages();
              },
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    !sending ? "Start Sending" : "Stop Sending",
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                  ))),
        ],
      ),
    ]);
  }
}
