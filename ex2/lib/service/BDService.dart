import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class BDService {
  static final BDService _instance = BDService._internal();
  factory BDService() => _instance;
  BDService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'compras.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (bd, version) async {
        await bd.execute('''
          CREATE TABLE setores (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL UNIQUE
          )
        ''');
        await bd.execute('''
          CREATE TABLE listas_compra (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL UNIQUE
          )
        ''');
        await bd.execute('''
          CREATE TABLE itens_compra (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            comprado INTEGER NOT NULL DEFAULT 0,
            lista_compra_id INTEGER NOT NULL,
            setor_id INTEGER NOT NULL,
            FOREIGN KEY (lista_compra_id) REFERENCES listas_compra(id) ON DELETE CASCADE,
            FOREIGN KEY (setor_id) REFERENCES setores(id) ON DELETE RESTRICT
          )
        ''');
      },
    );
  }
}