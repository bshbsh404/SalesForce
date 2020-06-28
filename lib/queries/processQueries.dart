import '../Plugins/Plugins.dart';
import '../Utils/constants.dart';
import './create.dart';

import '../staticdata/mockdata/customerlist.dart';
import '../staticdata/environments/wc.dart';

class ProcessQueries {
  checktablePresent() async {
    Map<String, dynamic> rslt = await Plugins.instance
        .excecute({'reqId': 'SQL', 'query': 'SELECT * FROM TB_TBL_VERSION'});
    if (rslt['status'] == false && rslt['errorCode'] == 'DB-001') {
      String createQuery = '';
      create.forEach((k, val) async {
        print(k.toString());
        createQuery = formCreateQuery(val);
        print("Creating table" + val['name']);
        if (createQuery != '') {
          await Plugins.instance.excecute({'reqId': SQL, 'query': createQuery});
          await Plugins.instance.excecute({
            'reqId': SQL,
            'query':
                'INSERT INTO TB_TBL_VERSION(TABLE_NAME,TABLE_VERSION)values("${val['name']}","${val['version'].toString()}")'
          });
        }
      });
    } else {
      //alter table has to be implemented on update of the table
    }
    createRecords();
  }

  createRecords() async{
    if (mockData) {
      await createMockdata(custList);
      await createMockdata(stocks);
      await createMockdata(items);
    }
  }

  createMockdata(tbdata) async {
    //drop the exsisting temp table
    String tbName = tbdata["name"] + "_TEMP";
    String dropQuery = dropTable(tbName);
    if (dropQuery != "") {
      await Plugins.instance.excecute({'reqId': SQL, 'query': dropQuery});
    }
    //creating the temp table
    String act = tbdata["name"];
    tbdata["name"] = act + "_TEMP";
    String createQuery = formCreateQuery(tbdata);
    print(createQuery.toString());
    if (createQuery != "") {
      await Plugins.instance.excecute({'reqId': SQL, 'query': createQuery});
      //inerting data into temp table
      String insertQuery = forminsertQuery(tbdata);
      print(insertQuery.toString());
      if (insertQuery != "") {
        await Plugins.instance.excecute({'reqId': SQL, 'query': insertQuery});
        //droping the actual table
        String tbactName = act;
        String dropActQuery = dropTable(tbactName);
        if (dropQuery != "") {
          await Plugins.instance
              .excecute({'reqId': SQL, 'query': dropActQuery});
        }
        //renaming temp table to actual table name
        String tbrName = act + "_TEMP";

        String renameQuery = renameTable(tbrName, act);
        if (renameQuery != "") {
          await Plugins.instance.excecute({'reqId': SQL, 'query': renameQuery});
        }
        String fetchcountQuerysql = fetchcountQuery(act);
        if (fetchcountQuerysql != "") {
          var rslt = await Plugins.instance.excecute({'reqId': SQL, 'query': fetchcountQuerysql});
          print(rslt.toString());
        }
      }
    }
  }

  String fetchcountQuery(table){
    return "SELECT COUNT(*) FROM $table";
  }

  String dropTable(tbName) {
    print("Droping table " + tbName);
    String renameQuery = "";
    if (tbName != "") {
      renameQuery = "DROP TABLE $tbName";
    }
    return renameQuery;
  }

  String renameTable(tbName, totbName) {
    print("rename table " + totbName);
    String renameQuery = "";
    if (tbName != "") {
      renameQuery = " ALTER TABLE $tbName RENAME TO $totbName";  
    }
    return renameQuery;
  }

  String formCreateQuery(val) {
    String createQuery = '';
    if (val['columns'].length > 0 && val['types'].length > 0) {
      createQuery = 'CREATE TABLE ';
      createQuery = createQuery + val['name'] + '(';
      for (var i = 0; i < val['columns'].length; i++) {
        createQuery = createQuery + val['columns'][i] + ' ';
        createQuery = createQuery + val['types'][i] + ',';
      }
      if (val['pk'].length > 0) {
        createQuery = createQuery + 'PRIMARY KEY(';
        for (var j = 0; j < val['pk'].length; j++) {
          createQuery = createQuery + val['pk'][j] + ',';
        }
        createQuery = createQuery.substring(0, createQuery.length - 1);
        createQuery = createQuery + ')';
      } else {
        createQuery = createQuery.substring(0, createQuery.length - 1);
      }
      createQuery = createQuery + ')';
    }
    return createQuery;
  }
}

formalterQuery(val) {}

String forminsertQuery(queryData) {
  String finalQuery = "";
  if (queryData["columns"].length > 0 && queryData["values"].length > 0) {
    finalQuery = "INSERT INTO ${queryData["name"]} (";
    for (int i = 0; i < queryData["columns"].length; i++) {
      finalQuery += "'";
      finalQuery += queryData["columns"][i];
      finalQuery += "',";
    }
    finalQuery = finalQuery.substring(0, finalQuery.length - 1);
    finalQuery += ")values(";
    for (int j = 0; j < queryData["values"].length; j++) {
      for (int k = 0; k < queryData["values"][j].length; k++) {
        finalQuery += "'";
        finalQuery += queryData["values"][j][k] == null ? "" :  queryData["values"][j][k];
        if (k == queryData["values"][j].length - 1) {
          finalQuery += "'),(";
        } else {
          finalQuery += "',";
        }
      }
    }
    finalQuery = finalQuery.substring(0, finalQuery.length - 2);
    finalQuery += ";";
  }
  return finalQuery;
}
