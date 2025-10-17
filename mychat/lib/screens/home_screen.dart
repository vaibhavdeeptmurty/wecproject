import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mychat/api/api.dart';
import 'package:mychat/models/chat_user.dart';
import 'package:mychat/widgets/chat_user_card.dart';
import '../../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

    List<ChatUser>list =[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.home),
        title: const Text('MyChat'),
        actions: [
          // search button
          IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
          // more button
          IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert))
        ],
      ),
      // floating add button to add new user
      //   temp sign out button
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 0,top: 0,right: 10,bottom: 15),
        child: FloatingActionButton(
          onPressed: () async {
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
          },
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          child: const Icon(Icons.add),
        ),
      ),
      body: StreamBuilder(
          
          stream: APIs.firestore.collection('users').snapshots(),
          builder: (context,snapshot){
            switch(snapshot.connectionState) {
              // for loading data
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              //   after loaded data to show
              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;
                list = data?.map((e)=>ChatUser.fromJson(e.data())).toList()?? [];

                if(list.isNotEmpty){
                  return ListView.builder(
                      itemCount: list.length,
                      padding: EdgeInsets.only(top: mq.height*0.01),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context,index){
                        return ChatUserCard(user: list[index],);
                        // return Text('Name: ${list[0]}');
                      });
                }
                else{
                  return const Center(child: Text('No connection found!'));
                }
            }
      }, )
    );
  }
}
