import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/compnents.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class DoneTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context, state) {
        var tasks = AppCubit.get(context).donetasks;
        if(tasks.isEmpty){
          return emptyTasks();
        }
        else {
          return ListView.separated(
              itemBuilder: (context,index){
                return buildTaskItem(tasks[index],context);
              },
              separatorBuilder: (context,index){
                return Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey[300],
                );
              },
              itemCount: tasks.length
          );
        }
      },

    );

  }
}
