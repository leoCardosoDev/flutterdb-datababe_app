import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco.db");

    var db = await openDatabase(
      localBancoDados,
      version: 1,
      onCreate: (db, dbVersaoRecente){
        String sql = "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)";
        db.execute(sql);
      },
    );

    //print("ABERTO: " + retorno.isOpen.toString());
    return db;
  }


  _salvar() async {
    Database db = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {
      "nome" : "Priscila Cardoso",
      "idade": 38
    };

    int id = await db.insert('usuarios',  dadosUsuario);
    print("Usuário CRIADO COM SUCESSO: ID -> " + id.toString());
  }



  @override
  Widget build(BuildContext context) {

    //_recuperarBancoDados();
    _salvar();

    return Container();
  }
}
