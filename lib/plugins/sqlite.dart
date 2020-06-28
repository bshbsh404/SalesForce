import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/constants.dart';
import './PluginException.dart';

class DatabaseHelper {
  
  static final _databaseName = CNST_DB_NAME;
  static final _databaseVersion = CNST_DB_VERSION;


  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }
  
  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {}
  
 
  Future<int> insert(Map<String, dynamic> row,String table) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> executeQuery(String query) async {
    try{
      Database db = await instance.database;
      return await db.rawQuery(query);
    }on DatabaseException catch(e){
      if(e.isNoSuchTableError()){
        print("isNoSuchTableError");
          throw new PluginException("DB-001","Table dose not exsists",e.toString());
      }else if(e.isDatabaseClosedError()){
        print("isDatabaseClosedError");
        throw new PluginException("DB-002","DataBase closed",e.toString());
      }else if(e.isSyntaxError()){
        print("isSyntaxError");
        throw new PluginException("DB-003","Syntax error",e.toString());
      }else if(e.isUniqueConstraintError()){
        print("isUniqueConstraintError");
        throw new PluginException("DB-004","Unique Constraint error",e.toString());
      }else if(e.isReadOnlyError()){
        print("isReadOnlyError");
        throw new PluginException("DB-005","Table read only",e.toString());
      }
    }on Exception catch(e){
      print("Unknown Exception" + e.toString());
    }
  }

  // All of the rows are returned as a list of maps, where each map is 
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> queryRowCount(table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(table,columnId,Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id,table,columnId) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
