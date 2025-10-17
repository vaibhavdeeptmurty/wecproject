

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mychat/api/api.dart';
import 'package:mychat/main.dart';
import 'package:mychat/models/chat_user.dart';



// PROFILE SCREEN OF SIGNED IN USER
class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

    List<ChatUser>list =[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),

      ),

      //   SIGN OUT BTN
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 0,top: 0,right: 10,bottom: 15),
        child: FloatingActionButton.extended(
          onPressed: () async {
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
          },
          backgroundColor: Colors.red.shade800,
          label: const Text('Sign Out'),
          icon: const Icon(Icons.logout),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.height*0.03),
        child: Column(
          children: [
            // FOR ADDING EXTRA SPACE
            SizedBox(width: mq.width, height: mq.height*0.04,
                      ),
            // USER PROFILE PICTURE
            ClipOval(
              child: CachedNetworkImage(
                width: mq.height*0.2,
                height:mq.height*0.2,
                fit: BoxFit.fill,
                imageUrl: widget.user.image,
                errorWidget: (context, url, error) => const Icon(CupertinoIcons.person),
              ),
            ),
            SizedBox(width: mq.width, height: mq.height*0.04),
            // USER EMAIL
            Text(widget.user.email,style: TextStyle(
                color: Theme.of(context).colorScheme.primary,fontSize: 18),
            ),
            SizedBox(width: mq.width, height: mq.height*0.04,
            ),
          //   NAME
            TextFormField(
              initialValue: widget.user.name,
              decoration: InputDecoration(
                prefixIcon: const Icon(CupertinoIcons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'Your Name...',
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                label: const Text('Name'),
              ),
            ),
            // ADDING SPACE
            SizedBox(width: mq.width, height: mq.height*0.04,),
            //   ABOUT
            TextFormField(
              initialValue: widget.user.about,
              decoration: InputDecoration(
                prefixIcon: const Icon(CupertinoIcons.info),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'Hey! I am new here.',
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                label: const Text('About'),
              ),
            ),
            // ADDING SPACE
            SizedBox(width: mq.width, height: mq.height*0.04,),
            // TO UPDATE CHANGED INFO IN DB
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(minimumSize: Size(mq.width*0.4, mq.height*0.05),elevation: 5,backgroundColor: Theme.of(context).colorScheme.secondary),
                onPressed: (){},
                icon: const Icon(Icons.edit),
                label: const Text('UPDATE'),
            )
          ],
        ),
      ),
    );
  }
}

