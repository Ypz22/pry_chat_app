class Message {
  final String text;
  final String author;
  final int timestamp;
  
  Message({
    required this.text,
    required this.author,
    required this.timestamp,
  });

  //Aqui estamos creando un metodo factory para convertir un json en un objeto Message
  factory Message.fromJson(Map<dynamic, dynamic> json){
    return Message(
      text: json['texto'],
      author: json['author'], 
      timestamp: json['timestamp']);
  }

  //Aqui estamos creando un metodo para convertir un objeto Message en un json
  Map<String, dynamic> toJson(){
    return{
      'texto': text,
      'author': author,
      'timestamp': timestamp,
    };
  } 

}