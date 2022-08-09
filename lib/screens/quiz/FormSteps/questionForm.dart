import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:students_lab/screens/quiz/FormSteps/quizFormSteps.dart';
import 'package:students_lab/widgets/buttons/addButtonWidget.dart';

import '../../../models.dart';
import '../../../shared/methods/ungroupedSharedMethods.dart';


class QuestionForm extends StatefulWidget {

  final formKey = GlobalKey<FormState>();
  QuestionForm(
      {Key? key, required this.question, required this.onRemove, this.index=0, })
      : super(key: key);

  late int index;
  Question question;
  final Function onRemove;
  final state = _QuestionFormState();


  @override
  State<StatefulWidget> createState() {
    return state;
  }

  TextEditingController _titleController = TextEditingController();
  List<TextEditingController> _answerControllers = <TextEditingController>[TextEditingController(), TextEditingController()];

  bool isValidated() => state.validate();

}

class _QuestionFormState extends State<QuestionForm> {

  int _correctIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 6),
      child: Material(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: widget.formKey,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(12)),

            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pitanje ${widget.index}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.amber
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                widget.question.questionField = "";
                                widget._titleController.clear();
                                widget._answerControllers.forEach((element) {element.clear();});
                                widget.question.answers = [Answer().toJson(), Answer().toJson()];
                              });
                            },
                            child: Text(
                              "Očisti",
                              style: TextStyle(color: Colors.lightBlue.shade100),
                            )),
                        TextButton(
                            onPressed: () {
                             widget.onRemove();
                            },
                            child: Text(
                              "Ukloni",
                              style: TextStyle(color: Colors.blue),
                            )),
                      ],
                    ),
                  ],
                ),
                TextFormField(
                  validator: (description) => description != null && description.isEmpty ? 'Potrebno unijeti pitanje' : null,
                  controller: widget._titleController,
                  // initialValue: widget.contactModel.name,
                  onChanged: (value) => widget.question.questionField = value,
                  onSaved: (value) => widget.question.questionField = value!,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                    hintText: "Unesite pitanje",
                    labelText: "Pitanje",
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(padding: EdgeInsets.only(top: 2),
                  child:  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.question.answers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title:
                          TextFormField(
                              validator: (description) => description != null && description.isEmpty ? 'Potrebno unijeti odgovor' : null,
                              controller: widget._answerControllers[index],
                            minLines: 1,
                            maxLines: 2,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              labelText: 'Odgovor ${index + 1}',
                              hintText: "Unesite odgovor",
                              icon: IconButton(onPressed: (){
                                setState(() {
                                  if(widget.question.answers.length < 3){
                                    Fluttertoast.showToast(msg: 'Nije moguće izbrisati, potrebna su najamanje dva odgovora');
                                  }else{
                                    widget.question.answers.removeAt(index);
                                    widget._answerControllers.removeAt(index);
                                  }
                                });
                              }, icon: Icon(Icons.delete, size: 20,
                                color: Colors.grey[700],
                              ),),),
                            onChanged: (value) {
                              setState(
                                      () {
                                        var answer = Answer();
                                        answer.answer = value.trim();
                                        if(_correctIndex == index) answer.isRight = true;
                                        Map<String, dynamic> temp = answer.toJson();
                                        widget.question.answers[index] = temp;
                                      }
                              );
                            },
                              onSaved: (value) {
                                var answer = Answer();
                                answer.answer = value!.trim();
                                if(_correctIndex == index) answer.isRight = true;
                                Map<String, dynamic> temp = answer.toJson();
                                widget.question.answers[index] = temp;
                              }
                          ),
                          trailing: _correctIndex == index ? IconButton(onPressed: (){
                          }, icon: Icon(
                            Icons.check_circle,
                            color: Colors.green[700],
                          ),)
                              : IconButton(onPressed: (){
                            setState(() {
                              _correctIndex = index;
                              var temp = Answer.fromJson(widget.question.answers[_correctIndex]);
                              temp.isRight = true;
                              widget.question.answers[_correctIndex] = temp.toJson();
                            });
                          }, icon: Icon(
                            Icons.check_circle_outline,
                            color: Colors.grey,
                          ),)
                      );
                    },
                  ),
                ),
                AddButton(message: 'Dodaj ponuđeni odgovor',
                  buttonColor: Colors.transparent,
                  onPress: (){
                  setState(() {
                    widget._answerControllers.add(TextEditingController());
                    widget.question.answers.add(Answer().toJson());
                  });
                },
                ),
              ],
            ),
          ),
        ),
      ),
    ),);
  }

  bool validate() {
    //Validate Form Fields by form key
    bool validate = widget.formKey.currentState!.validate();
    if (validate) widget.formKey.currentState?.save();
    return validate;
  }


}