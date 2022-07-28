
import 'package:flutter/material.dart';


class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(child:  SizedBox(
      width: size.width * 0.48,
      height: size.width * 0.48,
      child: CircularProgressIndicator(strokeWidth: 10, color: Colors.blueAccent,),
    ),);
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Molimo pričekajte\nZahvaljujemo se na Vašem strpljenju',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            textAlign: TextAlign.center,),
            Loader(),
          ],
        ),
      ),
    );
  }
}