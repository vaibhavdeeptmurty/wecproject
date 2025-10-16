import 'package:flutter/material.dart';
import 'package:mychat/screens/auth/login_screens.dart';
import 'package:mychat/screens/home_screen.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        Navigator.pushReplacement(
            context,MaterialPageRoute(builder: (_)=> const LoginScreen())
        );
      }
      );

      });



  }



  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(

      body:Stack(
        children: [
          // App logo
          Positioned(
              top: mq.height*.15,
              width: mq.width*.5,
              left: mq.width*.25,
              child: Opacity(
                  opacity: 0.8,
                  child: Image.asset('images/chat.png',)
              )
          ),
          // Made with love
          Positioned(
              bottom: mq.height*.15,
              width: mq.width,
              child: Center(child: Text('MADE BY VAIBHAV WITH ❤️',style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,letterSpacing: 4
              ),))
          )

        ],
      ) ,


    );
  }
}
