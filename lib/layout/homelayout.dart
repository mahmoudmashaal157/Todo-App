import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo/shared/components/compnents.dart';
import 'package:todo/shared/components/constants.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {

  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timingController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext contxt)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder:(context,state){
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key:scaffoldkey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.curindex],
              ),
            ),
            body: state is! AppGetDatabaseLoadingState? cubit.screens[cubit.curindex]:Center(child: CircularProgressIndicator()),
            floatingActionButton: FloatingActionButton (
              onPressed: () {
                if(cubit.isBottomSheetShown){
                  if(formKey.currentState!.validate()){
                    cubit.insertToDatabase(title: titleController.text,
                        Time: timingController.text,
                        Date: dateController.text);
                  }
                }
                else{
                  scaffoldkey.currentState!.showBottomSheet((context) {
                    return Container(
                      color: Colors.grey[100],
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFormField(
                                  controller: titleController,
                                  type: TextInputType.text,

                                  label: 'Task Title',
                                  prefix: Icons.title ,
                                  onTap: (){},
                                  validationText: "Title couldn't be empty"
                              ),
                              SizedBox(height: 20.0,),
                              defaultFormField(
                                controller: timingController,
                                type: TextInputType.datetime,

                                label: 'Task Time',
                                prefix: Icons.watch_later_outlined ,
                                onTap: (){
                                  print("tabed");
                                  showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                                    print(value.toString());
                                    timingController.text = value!.format(context).toString();
                                  }).catchError((onError){
                                    print("error in time picker ");
                                  });
                                },
                                validationText: "Timing couldn't be empty",

                              ),
                              SizedBox(height: 20.0,),
                              defaultFormField(
                                controller: dateController,
                                type: TextInputType.datetime,
                                label: 'Task Date',
                                prefix: Icons.calendar_today_rounded ,
                                onTap: (){
                                  showDatePicker(context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2200-05-03')).then((value)
                                  {
                                    print(DateFormat.yMMMd().format(value!));
                                    dateController.text=DateFormat.yMMMd().format(value);
                                  });
                                },
                                validationText: "Date must not be empty",
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                      elevation: 25.0
                  ).closed.then((value) {
                    cubit.changeBottomSheetState(ishow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(ishow: true, icon: Icons.add);
                }
              },
              child: Icon(
                  cubit.floatingbuttnIcon
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.curindex,
              onTap: (index){
                cubit.changeIndex(index);
                // setState(() {
                //   curindex =index;
                // });
              },
              items: [
                BottomNavigationBarItem(
                  label: "Tasks",
                  icon: Icon(
                      Icons.menu
                  ),
                ),
                BottomNavigationBarItem(
                  label: "Done",
                  icon: Icon(
                      Icons.check_circle_outline
                  ),
                ),
                BottomNavigationBarItem(
                  label: "Archived",
                  icon: Icon(
                      Icons.archive_outlined
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}



