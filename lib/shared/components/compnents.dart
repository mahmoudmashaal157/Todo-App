
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';

Widget defaultFormField ({
  required TextEditingController controller ,
  required TextInputType type ,
  Function? onSubmit ,
  Function? onChange ,
  required String label,
  required String validationText,
  required IconData prefix,
  bool isPassword = false,
  IconData? suffix,
   Function? onTap,
  bool isClickable = true,
})
{
  return TextFormField(
    keyboardType: type,
    obscureText: isPassword,
    controller: controller,
    enabled: isClickable,
    validator: (s){
      if(s!.isEmpty){
        return validationText;
      }
    },
    onTap: (){
      onTap!();
    },
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
      prefixIcon: Icon(prefix),
      suffixIcon: suffix!=null ? Icon(suffix) : null,
    ),
  );
}

Widget buildTaskItem(Map model,context){
  return  Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text(
                "${model['time']}",
              style: TextStyle(
                fontSize: 15,

              ),
            ),

          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${model['title']}",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  "${model['date']}",
                  style: TextStyle(
                      color: Colors.grey
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20.0,),
          IconButton(
              onPressed: (){
                AppCubit.get(context).updateData(status: 'done', id: model['id']);
              },
              icon:
              Icon(
                Icons.check_box_rounded,
                color: Colors.green,
              )),
          IconButton(
              onPressed: (){
                AppCubit.get(context).updateData(status: 'archived', id: model['id']);

              },
              icon: Icon(
                Icons.archive,
                color: Colors.grey,
              )),
        ],
      ),
    ),
    onDismissed: (direction){
      AppCubit.get(context).DeleteData(id: model['id']);
    },
  );
}

Widget emptyTasks(){
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100,
          color: Colors.grey,
        ),
        SizedBox(width: 15.0,),
        Text(
          "There is no Tasks yet",
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey
          ),
        )
      ],
    ),
  );

}