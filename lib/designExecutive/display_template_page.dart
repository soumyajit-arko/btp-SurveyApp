import 'package:flutter/material.dart';
import 'dart:convert';

class TemplateSourcePage extends StatefulWidget {
  final String templateSource;
  final String pageTitle;
  TemplateSourcePage(this.pageTitle,this.templateSource);

  @override
  State<TemplateSourcePage> createState() => _TemplateSourcePageState();
}

class _TemplateSourcePageState extends State<TemplateSourcePage> {
  List<Map<String, dynamic>> questions = [];
  @override
  void initState() {
    super.initState();
    displayTemplate();
  }

  void displayTemplate() async {
    final data = json.decode(widget.templateSource);
    List<Map<String, dynamic>> mapList =
        data.cast<Map<String, dynamic>>().toList();

    setState(() {
      questions = mapList;
    });
  }

  Widget _buildSmallTextField(String questionText, String hintText) {
    return Expanded(
      child: Container(
        height: 50,
        child: TextField(
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageTitle),
      ),
      // body: Stack(
      //   children: <Widget>[
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 500,
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  final questionText = question['question'];
                  final questionType = question['type'];
                  final options_ = question['options'];
                  final options = options_.split(',');
                  Widget? questionWidget;
                  if (questionType == 'Single Choice') {
                    questionWidget = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(questionText, style: TextStyle(fontSize: 18)),
                        SizedBox(
                          height: 10,
                        ),
                        for (var option in options)
                          RadioListTile<String>(
                            title: Text(option),
                            value: option,
                            groupValue: null,
                            onChanged: (value) {},
                          ),
                      ],
                    );
                  } else if (questionType == 'Multiple Choice') {
                    questionWidget = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(questionText, style: TextStyle(fontSize: 18)),
                        SizedBox(
                          height: 10,
                        ),
                        for (var option in options)
                          CheckboxListTile(
                            title: Text(option),
                            value: false,
                            onChanged: (selected) {},
                          ),
                      ],
                    );
                  } else if (questionType == 'Text Answer' ||
                      questionType == 'Integer Answer') {
                    // final tempUtil = TextEditingController();
                    // textControllers.add(tempUtil);
                    // count++;
                    questionWidget = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(questionText, style: TextStyle(fontSize: 18)),
                            SizedBox(
                                width:
                                    10), // Add spacing between the Text and TextField
                            _buildSmallTextField(
                                questionText, 'Enter your answer'),
                          ],
                        )
                      ],
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: questionWidget,
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ),
    );
  }
}
