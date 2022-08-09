
import 'package:flutter/material.dart';


Future showAlertWindow(BuildContext context, String message, VoidCallback onPress) async {

  showDialog(context: context,
    builder: (context) =>
        StatefulBuilder(
            builder: (context, setState) {
              FocusScope.of(context).unfocus();
              return AlertDialog(
                backgroundColor: Colors.black87,
                title:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('Upozorenje!', style: TextStyle(color: Colors.white),),
                    IconButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.cancel_presentation,size: 22, color: Colors.white,),
                      tooltip: 'Izađi',
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children:[
                    Container(
                      child: Text(message, softWrap: false,
                        overflow: TextOverflow.fade, style: TextStyle(color: Colors.white),) ,
                    ),

                  ],
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        child: const Text('DA'),
                        onPressed: onPress,
                      ),
                      ElevatedButton(
                          child: const Text('NE'),
                          onPressed: () async {
                            Navigator.of(context).pop();
                          }
                      ),
                    ],
                  ),
                ],
              );}),
  );

}