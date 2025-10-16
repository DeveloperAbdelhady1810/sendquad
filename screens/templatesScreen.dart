import 'package:flutter/material.dart';
import 'package:quadsender/adapters/template.dart';
import 'package:quadsender/classes/styles.dart';
import 'package:quadsender/classes/variables.dart';
import 'package:quadsender/screens/create_template_screen.dart';
import 'package:quadsender/screens/sendScreen.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({Key? key}) : super(key: key);

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 1.8),
        itemCount: Variables().templates.length + 1,
        itemBuilder: (context, index) {
          try {
            Template template = Variables().templates.values.elementAt(index);
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Colors.green,
                  width: 2,
                ),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(template.name,
                          style: Styles().style(20, Colors.black, true)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  Variables().templates.delete(template.name);
                                });
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                          Text(template.descrption,
                              style: Styles().style(15, Colors.black, false)),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CreateTemplateScreen(
                                                templateName: template.name,
                                                templateDescription:
                                                    template.descrption,
                                                numbers: template.numbers)));
                              },
                              icon: const Icon(Icons.edit))
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            SendScreenState().addNumbers(template.numbers);
                          },
                          child: const Text("Use")),
                      const Divider(
                        height: 2,
                        thickness: 2,
                        color: Colors.grey,
                      ),
                      ListView(
                        shrinkWrap: true,
                        children: template.numbers
                            .map((e) => Row(
                                  children: [
                                    Text(e),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            template.numbers.remove(e);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ))
                                  ],
                                ))
                            .toList(),
                      ),
                    ],
                  )),
            );
          } catch (e) {
            return TextButton(
                style: Styles().buttonStyle(Colors.blue, Colors.lightBlue, 18),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CreateTemplateScreen(
                            numbers: {},
                            templateDescription: "",
                            templateName: "",
                          )));
                },
                child: Text(
                  "Add New template",
                  style: Styles().style(30, Colors.white, true),
                ));
          }
        });
  }
}
