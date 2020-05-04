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
      onCreate: (db, dbVersaoRecente) {
        String sql =
            "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)";
        db.execute(sql);
      },
    );

    //print("ABERTO: " + retorno.isOpen.toString());
    return db;
  }

  _salvar() async {
    Database db = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {
      "nome": "Usuario 3 para Deletar",
      "idade": 99
    };

    int id = await db.insert('usuarios', dadosUsuario);
    print("Usuário CRIADO COM SUCESSO: ID -> " + id.toString());
  }

  _listarUsuario() async {
    Database db = await _recuperarBancoDados();
    //String sql = "SELECT id, nome, idade FROM usuarios";
    //String sql = "SELECT id, nome, idade FROM usuarios WHERE ID = 5";
    String sql = "SELECT id, nome, idade FROM usuarios";
    List usuarios = await db.rawQuery(sql);

    //print("USUARIOS: " + usuarios.toString());

    for (var usuario in usuarios) {
      print(" ID: " +
          usuario['id'].toString() +
          "\n NOME: " +
          usuario['nome'] +
          "\n IDADE: " +
          usuario['idade'].toString());
    }
  }

  _listarUsuarioId(int id) async {
    Database db = await _recuperarBancoDados();
    List usuarios = await db.query("usuarios",
        columns: ["id", "nome", "idade"], where: "id = ?", whereArgs: [id]);

    for (var usuario in usuarios) {
      print(" ID: " +
          usuario['id'].toString() +
          "\n NOME: " +
          usuario['nome'] +
          "\n IDADE: " +
          usuario['idade'].toString());
    }
  }

  _excluirUsuario(int id) async {
    Database db = await _recuperarBancoDados();
    int retorno = await db.delete("usuarios", where: "id = ?", whereArgs: [id]);

    print("Quantidade de registro removido(s): $retorno" );
  }

  _atualizarUsuario(int id) async {
    Database db = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {
      "nome": "Jurema Cardoso de Oliveira",
      "idade": 1
    };

    int retorno = await db.update(
      "usuarios",
      dadosUsuario,
      where: "id = ?", whereArgs: [id]
    );

    print("Quantidade de usuario atualizado = $retorno" );
  }


  @override
  Widget build(BuildContext context) {
    //_recuperarBancoDados();
    //_salvar();
    //_listarUsuario();
    //_listarUsuarioId(6);
    //_excluirUsuario(8);
    //_atualizarUsuario(6);

    _listarUsuario();


    return Container();
  }
}
