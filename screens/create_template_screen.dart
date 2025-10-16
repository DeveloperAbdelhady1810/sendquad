import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:quadsender/adapters/template.dart';
import 'package:quadsender/classes/variables.dart';

class CreateTemplateScreen extends StatefulWidget {
  const CreateTemplateScreen(
      {super.key,
      required this.templateName,
      required this.templateDescription,
      required this.numbers});
  final String templateName;
  final String templateDescription;
  final numbers;
  @override
  State<CreateTemplateScreen> createState() => _CreateTemplateScreenState();
}

bool mediaDragAreaActive2 = false;
String path2 = "";
String name2 = "";
bool isenabled2 = true;
Map numbers = {};
TextEditingController templateNameController = TextEditingController(
    text: "Template No.${Variables().templates.length + 1}");
TextEditingController templateDescriptionController = TextEditingController();
bool buttonenebled = true;

class _CreateTemplateScreenState extends State<CreateTemplateScreen> {
  @override
  void initState() {
    if (widget.templateName.isNotEmpty) {
      setState(() {
        templateNameController.text = widget.templateName;
        templateDescriptionController.text = widget.templateDescription;
        // numbers = widget.numbers;
        for (var number in widget.numbers) {
          numbers.addAll({number: false});
        }
      });
    }
    print(widget.numbers);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.templateName.isNotEmpty
            ? "Edit ${widget.templateName}"
            : 'Create Template'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          TextField(
            controller: templateNameController,
            decoration: const InputDecoration(
              labelText: "Template Name",
            ),
            onChanged: (value) {
              if (Variables().templates.keys.contains(value)) {
                setState(() {
                  buttonenebled = false;
                });
              } else {
                setState(() {
                  buttonenebled = true;
                });
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: templateDescriptionController,
            decoration: const InputDecoration(
              labelText: "Template Description",
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.5 - 10,
            height: 300,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                color: mediaDragAreaActive2
                    ? const Color.fromARGB(183, 33, 149, 243)
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
                      : ListView.builder(
                          shrinkWrap: true,
                          // reverse: true,
                          itemCount: numbers.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${index + 1}"),
                                // VerticalDivider(color: Colors.grey,width: 1,thickness: 1),
                                Text(numbers.keys.elementAt(index)),
                                IconButton(onPressed: (){setState(() {
                                  numbers.remove(numbers.keys.elementAt(index));
                                });}, icon: const Icon(Icons.delete,color:Colors.red))
                              ],
                            );
                          })),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
              onPressed: () async {
                if (buttonenebled) {
                  Template template = Template(
                      descrption: templateDescriptionController.text,
                      name: templateNameController.text,
                      numbers: numbers.keys.toList());
                  await Variables()
                      .templates
                      .put(templateNameController.text, template);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("${templateNameController.text} saved")));
                  setState(() {
                    templateNameController.clear();
                    templateDescriptionController.clear();
                    numbers.clear();
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "${templateNameController.text} Is allready saved before")));
                }
              },
              child: const Text("Save"))
        ]),
      ),
    );
  }
}
