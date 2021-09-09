import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit(): super(AppInitalState());

  static AppCubit get (context){
    return BlocProvider.of(context);
  }
  var database ;
  int curindex = 0;
  List<Map>newtasks = [];
  List<Map>donetasks = [];
  List<Map>archivedtasks = [];




  List<Widget>screens =[
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  List<String>titles =[
    'Tasks',
    'Done Tasks',
    'Archived Tasks'
  ];

  void changeIndex(int index){
    curindex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() async{
     openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database , version){
        print('created');
        database.execute('CREATE TABLE TASKS (id INTEGER PRIMARY KEY, title TEXT ,date TEXT, time Text ,statues TEXT)').then((value) {

        }).catchError((error){
          print("error when creating DataBase ${error.toString()}");
        });
      },
      onOpen: (database){
         getDataFromDatabase(database);
        print("opened");
      },
    ).then((value) {
      database=value;
      print(database);
      emit(AppCreateDatabaseState());
    });
  }


  Future insertToDatabase({
    required String title,
    required String Time,
    required String Date
  }) async
  {
    return await database.transaction((txn)async
    {
      txn.rawInsert('INSERT INTO tasks (title,date,time,statues) VALUES ("$title","$Date","$Time","new")').
      then((value){
        print(" Inserted successfully");
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }
      ).catchError((error){
        print("error in inserting");

      });
      return null;
    });
  }

  void getDataFromDatabase(database) async
  {
    newtasks=[];
    donetasks=[];
    archivedtasks=[];
    emit(AppGetDatabaseLoadingState());
      await database.rawQuery('Select * from tasks').then((value) {
       value.forEach((element){
         if(element['statues']=='new')
           newtasks.add(element);
         else if (element['statues']=='done')
           donetasks.add(element);
         else
           archivedtasks.add(element);
       });
        emit(AppGetDatabaseState());
      });;
  }

  bool isBottomSheetShown = false;
  IconData floatingbuttnIcon = Icons.edit ;

  void changeBottomSheetState({
    required bool ishow,
    required IconData icon
  })
  {
    isBottomSheetShown = ishow;
    floatingbuttnIcon=icon;
    emit(AppChangeBottomsheetState());

  }

  void updateData ({
    required String status,
    required int id,
}) async
  {
    database.rawUpdate('UPDATE tasks SET statues = ? WHERE id = ?',
   ['$status',id],).then((value){
     emit(AppUpdateDatabaseState());
     getDataFromDatabase(database);
    });

  }

  void DeleteData ({
    required int id,
  }) async
  {
    database.rawUpdate('DELETE FROM tasks WHERE id = ?',
      [id],).then((value){
      emit(AppDeleteDatabaseState());
      getDataFromDatabase(database);
      emit(AppGetDatabaseLoadingState());
    });

  }
}