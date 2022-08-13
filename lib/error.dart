
import 'package:flutter/material.dart';


class ErrorMessage extends StatelessWidget {

  final String message;

  const ErrorMessage({Key? key, this.message = 'Oprostite došlo je do pogreške.'}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(message,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,),
            const SizedBox(height: 18,),
            const Icon(Icons.error_outline, size: 46, color: Colors.red,),
          ],
        ),
      ),
    );
  }
}
