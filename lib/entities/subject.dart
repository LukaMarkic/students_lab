class Subject{
late String title;
late String text;

Subject(this.title, this.text);

Subject.fromJson(Map<String, dynamic> json){
  title = json['title'];
  text = json['text'];
}

}