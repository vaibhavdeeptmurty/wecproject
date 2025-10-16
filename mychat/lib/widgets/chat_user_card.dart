import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mychat/models/chat_user.dart';


class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {

  @override
  Widget build(BuildContext context) {
    return  Card(
      child: InkWell(child: ListTile(
        // profile pic
        leading: const CircleAvatar(child: Icon(CupertinoIcons.person),),
        // user name
        title: Text(widget.user.name),
        // last message
        subtitle: Text(widget.user.about, maxLines: 1,),
        // last message time
        trailing: Text('12:00 PM',style: TextStyle(fontSize: 12,color: Theme.of(context).colorScheme.primary),),
      )
      ),
    );
  }
}

