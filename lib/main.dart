import 'package:flutter/material.dart';
import 'package:startup_namer/RandomWords.dart';


void main() => runApp(MyApp()); //"=>" especifica un método de una línea

/*Casi to-do en Flutter es un widget, incluyendo padding, layouts, o apps,
* como en este caso, gracias a la extensión de StatelessWidget*/
class MyApp extends StatelessWidget{

  //Sobreescritura de método build de StatelessWidget
  /*La principal función de un widget es ofrecer un método build() que describe
  * cómo desplegar el widget en términos de sus widgets de menor nivel*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(               //Flutter promueve Material Design
      title: 'Startup Name Generator',
      theme: ThemeData(             //Clase que permite modificar el tema de la app
        primaryColor: Colors.white
      ),
      home: RandomWords(),
    );
  }
}