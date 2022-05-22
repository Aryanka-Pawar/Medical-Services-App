import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import '../shared/helperFunctions.dart';
import 'firebaseDatabase.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;
  final String tableUser = "User";

  final String columnUserId = "userId";
  final String columnUserEmail = "userEmail";
  final String columnUserName = "userName";
  final String columnUserPassword = "userPassword";
  final String columnUserIsDoctor = "isDoctor";

  Future<Database> get db async => _db ??= await initDb();

  DatabaseHelper.internal();

   initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "main.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE User(id INTEGER PRIMARY KEY, userId TEXT, userEmail TEXT, userName TEXT, userPassword TEXT, isDoctor TEXT)");
    print("Table is created");
  }

  //insertion
  Future<int> saveUser(User user) async {
    print("\n Here \n\n");
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMap());
    List<Map> list = await dbClient.rawQuery('SELECT * FROM User');
    print(list);

    await DatabaseService(uid: user.userId).updateUserData(user);

    HelperFunctions.saveUserLoggedInSharedPreference(true);
    HelperFunctions.saveUserIdSharedPreference(int.parse(user.userId));
    HelperFunctions.saveUserEmailSharedPreference(user.userEmail);
    HelperFunctions.saveUserNameSharedPreference(user.userName);
    HelperFunctions.saveIsDoctorSharedPreference(user.isDoctor ==  "true" ? true: false);
    return list.elementAt(list.length-1)["id"];
  }

  //deletion
  Future<int> deleteUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.delete("User");
    return res;
  }

  //select
  Future<User?> selectUser(User user) async{
     var dbClient = await db;
     List<Map> maps = await dbClient.query(tableUser,
         columns: [columnUserId, columnUserEmail, columnUserName, columnUserPassword, columnUserIsDoctor],
         where: "$columnUserEmail = ? and $columnUserPassword = ?",
         whereArgs: [user.userEmail,user.userPassword]);
     print(maps);
     if (maps.isNotEmpty) {
       print("User Exist !!!");
       User myUser = User(maps.elementAt(0)["userId"], maps.elementAt(0)["userEmail"], maps.elementAt(0)["userName"], maps.elementAt(0)["userPassword"], maps.elementAt(0)["isDoctor"]);
       HelperFunctions.saveUserIdSharedPreference(int.parse(maps.elementAt(0)["userId"]));
       return myUser;
     }else {
       return null;
     }
   }
}