// ignore_for_file: unused_local_variable, dead_code, prefer_collection_literals, unnecessary_new, prefer_typing_uninitialized_variables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

//exmaple calling DB  function
// Map<dynamic, dynamic> where = {
//   'table': "users",
//   'phone': '11199119911',
//   'gender': 'transgender',
//   'orderBy': 'phone',
//   'limit': 1,
// };

//dbSave(db, where);
//dbDelete(db, 'users', 'LQJbIfdB15SHDCf51p03');
//print(dbFindDynamic(db, where));

dbUpdate(db, where) {
  var returnData = '';
  if (where == null || where == '') {
    return "Map data is empty";
    return false;
  }

  if (where['table'] == null) {
    return "Table name required!!";
    return false;
  }

  var table = (where['table']);
  where.remove('table');

  if (where['id'] == null) {
    return "id required";
    return false;
  }
  var id = (where['id']);
  where.remove('id');

  db.collection(table).doc(id).update(where).then((value) {
    returnData = 'Updated';
  }).catchError((error) {
    returnData = "Updattion Failed: $error";
  });
}

dbSave(db, where) async {
  // srno manage
  var rData = await dbFindDynamic(db, {'table': 'sr_no'});
  var sr_id = 0;
  Map<String, dynamic> w = {};
  if (rData.isNotEmpty) {
    sr_id = w[where['table']] = (rData[0]['${where['table']}'] != null)
        ? int.parse(rData[0]['${where['table']}'].toString()) + 1
        : 1;
  }

  var returnData = '';
  if (where == null || where == '') {
    return "Map data is empty";
  }

  if (where['table'] == null) {
    return "Table name required!";
  }
  var table = (where['table']);
  where.remove('table');
  where['sr_no'] = sr_id;

  final data =
      await db.collection(table).add(where).then((DocumentReference doc) async {
    // update sr No
    if (w.isNotEmpty) {
      await db.collection('sr_no').doc(rData[0]['id']).update(w);
    }

    return doc.id;
  });

  return data;
}

dbFind(where) async {
  if (where == null || where == '') {
    return {'error': 'Array Required'};
  }

  if (where['table'] == null) {
    return {'error': 'Table name required!!'};
  }
  var table = (where['table']);

  if (where['id'] == null) {
    return {'error': 'Document ID Required'};
  }
  var id = (where['id']);

  where.remove('id');

  final data = await FirebaseFirestore.instance
      .collection(table)
      .doc(id)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      Map<int, dynamic> returnData2 = new Map();
      return documentSnapshot.data();
    } else {
      return 'Document does not exist on the database';
    }
  });

  return data;
}

dbFindDynamic(db, where) async {
  var returnData = '';
  if (where == null || where == '') {
    return {'error': 'Array Required'};
  }

  if (where['table'] == null) {
    return {'error': 'Table name required!!'};
  }
  var table = (where['table']);
  where.remove('table');

  var dbTable = db.collection(table);
  // Order by
  if (where['orderBy'] != null) {
    if (where['orderBy'].contains('-')) {
      //query = query.orderBy('dateAt', descending: true);
      dbTable = dbTable.orderBy(where['orderBy'].replaceAll("-", ""),
          descending: true);
    } else {
      //dbTable.orderBy(where['orderBy']);
    }
    where.remove('orderBy');
  }
  // Limit (limit must be integer formate)
  if (where['limit'] != null) {
    dbTable = dbTable.limit(where['limit']);
    where.remove('limit');
  }

  // Where Query
  var query;
  int i = 1;
  where.forEach((k, v) {
    //query.where('$k', isEqualTo: v);
    if (i == 1) {
      query = dbTable.where("$k", isEqualTo: "$v");
    } else {
      query = query.where("$k", isEqualTo: "$v");
    }
    i++;
  });

  query = (query == null || query == '') ? dbTable : query;

  final data = await query.get().then(
    (res) {
      Map<int, dynamic> returnData2 = new Map();
      int k = 0;
      for (var doc in res.docs) {
        //returnData2[doc.id] = doc.data();
        Map<String, dynamic> temp = doc.data();
        temp['id'] = doc.id;
        returnData2[k] = temp;
        k++;
      }
      return returnData2;
    },
    onError: (e) => print("Error completing: $e"),
  );

  return data;
}

//var query = await db.collection('order').where("$k", isEqualTo: "$v");
dbRawQuery(query) async {
  final data = await query.get().then(
    (res) {
      Map<int, dynamic> returnData2 = new Map();
      int k = 0;

      for (var doc in res.docs) {
        //returnData2[doc.id] = doc.data();
        Map<String, dynamic> temp = doc.data();
        // print("${doc.data()} =====j2 ");
        temp['id'] = doc.id;
        returnData2[k] = temp;
        k++;
      }

      return returnData2;
    },
    onError: (e) => print("Error completing: $e"),
  );
  return data;
}

// Delete function
dbDelete(db, where) {
  var returnData = '';
  if (where == null || where == '') {
    return "Map data is empty";
  }

  if (where['table'] == null) {
    return "Table name required!!";
  }

  db
      .collection(where['table'])
      .doc(where['id'])
      .delete()
      .then((value) {})
      .catchError((error) {
    returnData = "Updattion Failed: $error";
  });

  return returnData;
}

dbFindDynamicc(db, where) async {
  var returnData = '';
  if (where == null || where == '') {
    return {'error': 'Array Required'};
  }

  if (where['table'] == null) {
    return {'error': 'Table name required!!'};
  }
  var table = (where['table']);
  where.remove('table');

  var dbTable = await db.collection(table);

  // Order by
  if (where['orderBy'] != null) {
    if (where['orderBy'].contains('-')) {
      //query = query.orderBy('dateAt', descending: true);
      dbTable = dbTable.orderBy(where['orderBy'].replaceAll("-", ""),
          descending: true);
    } else {
      dbTable.orderBy(where['orderBy'], descending: true);
    }
    where.remove('orderBy');
  }
  // Limit (limit must be integer formate)
  if (where['limit'] != null) {
    dbTable = dbTable.limit(where['limit']);

    where.remove('limit');
  }

  // Where Query
  var query;
  int i = 1;
  where.forEach((k, v) {
    //query.where('$k', isEqualTo: v);
    if (i == 1) {
      query = dbTable.where("$k", isEqualTo: "$v");
    } else {
      query = query.where("$k", isEqualTo: "$v");
    }
    i++;
  });

  query = (query == null || query == '') ? dbTable : query;

  //final data = await dbTable.get().then(
  final data = await query.get().then(
    (res) {
      Map<int, dynamic> returnData2 = new Map();
      int k = 0;

      for (var doc in res.docs) {
        //returnData2[doc.id] = doc.data();
        Map<String, dynamic> temp = doc.data();
        temp['id'] = doc.id;
        returnData2[k] = temp;
        k++;
      }

      // print("${returnData2} =====j2 ");
      return returnData2;
    },
    onError: (e) => print("Error completing: $e"),
  );

  return data;
}
