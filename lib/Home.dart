
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';
const String kApplicationDocumentsPath = 'applicationDocumentsPath';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _listaTarefas = [];
  TextEditingController _controllerTarefa = TextEditingController();

  Future<File> _getFile() async{

    final diretorio = await getApplicationDocumentsDirectory();

    print("dados" + diretorio.path);

    return File("${diretorio.path}/dados.json");
  }

  _salvarTarefa(){

    String textoDigitado = _controllerTarefa.text;

    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"]  = textoDigitado;
    tarefa["realizada"]  = false;

    setState(() {
    _listaTarefas.add(tarefa);
    });
    _salvarArquivo();
    _controllerTarefa.text = "";
  }

  _salvarArquivo() async { //Salvar ou Recuperar arquivo usa o async

    var arquivo = await _getFile();
      String dados = json.encode(_listaTarefas);
      arquivo.writeAsString(dados);

      /*{titulo: "Ir ao mercado",
      * realizada: true
      * }
      * {titulo: "Estudar",
      * realizada: false
      * }
      * */
     // caminho/dados.json
    }

    _lerArquivo()async{

    try {
      final arquivo = await _getFile();
      return arquivo.readAsString();


    }catch(e){
      return null;
    }

    }

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lerArquivo().then((dados){
      setState(() {
        _listaTarefas = json.decode(dados);
      });
    });

  }


  @override
  Widget build(BuildContext context) {

     // _salvarArquivo();

    print("itens: " + _listaTarefas.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.purple,
      ),
      body: Column(

        children: [

          Expanded(
              child: ListView.builder(
                itemCount: _listaTarefas.length,
                  itemBuilder: (context, index){

                  return CheckboxListTile(
                    title: Text(_listaTarefas[index]['titulo']),
                      value: _listaTarefas[index]['realizada'],
                      onChanged: (valorAlterado){

                      setState(() {
                      _listaTarefas[index]['realizada'] = valorAlterado;
                      });
                      _salvarArquivo();

                      }
                  );

               /*   return ListTile(
                  title: Text(_listaTarefas[index]['titulo']),
                  );*/

                  }))
        ],

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 8,
        child: Icon(Icons.add),
        onPressed: (){
          
          showDialog(context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Adicionar Tarefa"),
              content: TextField(
                controller: _controllerTarefa,
                decoration: InputDecoration(
                  labelText: "Digite sua Tarefa"
                ),
                onChanged: (text){

                },
              ),
              actions: [
                FlatButton(
                    child: Text("Cancelar"),
                    onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                  child: Text("Salvar"),
                  onPressed: (){
                    //Salvar
                    _salvarTarefa();

                  Navigator.pop(context);
            },
                )
              ],
            );
          }
          );
        },
      ),
    );
  }
}
