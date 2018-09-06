import 'package:flutter/material.dart';
import 'package:startup_namer/RandomWords.dart';

/*Importación de librería externa (ver archivo pubspec.yaml -> dependencies)*/
import 'package:english_words/english_words.dart';

/*Esta clase extiende la clase genérica State, que esta vez se especializa
* en RandomWords. La clase se encargará de 'mantener el estado' de RandomWords.
* Para ello, guardará los pares de palabras en inglés generadas ('infinitas',
* según el usuario scrollee) y los pares de palabras favoritas (según el
* usuario las gestione)*/

class RandomWordsState extends State<RandomWords>{

  final _sugerencias = <WordPair>[]; //"_" refuerza la privacidad en Dart, y "<WordPair>[]" es una lista
  final _fuenteGrande = const TextStyle(fontSize: 18.0);
  final _guardados = Set<WordPair>(); //Almacena los favoritos

  //Aquí se generarán los pares de palabras al azar
  @override
  Widget build(BuildContext context) {

    return Scaffold (     //Scaffold ofrece una estructura estándar para la app
      appBar: AppBar(     //Contiene una AppBar, un title y un body
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved) //ícono más evento
        ],
      ),
      body: _construirSugerencias(),  //El body es construido con un método
    );
  }

  /*Método que construirá un ListView que despliega los pares de palabras*/
  Widget _construirSugerencias(){

    return ListView.builder(

      padding: const EdgeInsets.all(16.0), //Contornos del ListView

      /*itemBuilder es llamado una vez por cada par de palabras, y pone
      cada sugerencia en una fila ListTile (creada por método _construirFila()).
      En las filas pares, la función agrega una fila ListTile al par.
      En las filas impares, la función agrega un widget Divider para separar
      visualmente las entradas.*/

      itemBuilder: (context, i){

        if (i.isOdd) return Divider(); //Agregar Divider de un pixel de ancho en impares

        final index = i ~/ 2; //Calcular número de pares de palabras en ListView, menos los Divider

        /*Si se llega al final de la lista de pares de palabras, generar otras
        * 10 más y agregarlas a la lista*/
        if (index >= _sugerencias.length){
          _sugerencias.addAll(generateWordPairs().take(10));
        }

        //Llamar a este método una vez por cada par de palabras
        return _construirFila(_sugerencias[index]);
      }
    );
  }

  /*Método que despliega los pares de palabras en la lista*/
  Widget _construirFila(WordPair pair) {

    final bool yaGuardado = _guardados.contains(pair); //Check

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _fuenteGrande,
      ),

      trailing: new Icon( //Ícono de corazón para guardar (sin interacción)
        yaGuardado? Icons.favorite : Icons.favorite_border,
        color: yaGuardado? Colors.red : null,
      ),

      onTap: (){  //Interactividad. Agregar o quitar de favoritos
        setState((){  //llama a build() para actualizar UI (reactividad)
          if(yaGuardado){
            _guardados.remove(pair);
          }else{
            _guardados.add(pair);
          }
        });
      },
    );
  }

  //Método que controla el click de botón de nueva página para ver favs
  void _pushSaved(){
    Navigator.of(context).push( //"Empuje" a la nueva route (página)
      new MaterialPageRoute<void>(
        builder: (BuildContext context){
          final Iterable<ListTile> tiles = _guardados.map(
              (WordPair pair){
                return new ListTile(
                  title: new Text(
                    pair.asPascalCase,
                    style: _fuenteGrande,
                  ),
                );
              },
          );
          final List<Widget> dividido = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          )
          .toList();

          return new Scaffold( //Estructura de la nueva route
            appBar: new AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: new ListView(children: dividido),
          );
        }
      )
    );
  }
}