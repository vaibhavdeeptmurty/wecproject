import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mychat/models/chat_user.dart';

import '../main.dart';
import '../screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          onTap: () {
            // FOR NAVIGATING TO CHAT SCREEN
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          user: widget.user,
                        )));
          },
          child: ListTile(
              // profile pic
              leading: ClipOval(
                child: CachedNetworkImage(
                  width: mq.height * 0.05,
                  height: mq.height * 0.05,
                  imageUrl: widget.user.image,
                  errorWidget: (context, url, error) =>
                      const Icon(CupertinoIcons.person),
                ),
              ),
              // user name
              title: Text(widget.user.name),
              // last message
              subtitle: Text(
                widget.user.about,
                maxLines: 1,
              ),
              // last message time
              trailing: Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    color: Colors.green.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ))
              // Text('12:00 PM',style: TextStyle(fontSize: 12,color: Theme.of(context).colorScheme.primary),),
              )),
    );
  }
}
