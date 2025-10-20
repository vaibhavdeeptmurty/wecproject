import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mychat/helper/my_date_util.dart';
import 'package:mychat/main.dart';
import 'package:mychat/models/chat_user.dart';

// PROFILE SCREEN OF SIGNED IN USER
class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Joined On: ',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Text(
            MyDateUtil.getLastMessageTime(context, widget.user.createdAt,
                showYear: true),
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).colorScheme.primary),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.height * 0.03),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // FOR ADDING EXTRA SPACE
              SizedBox(
                width: mq.width,
                height: mq.height * 0.04,
              ),
              // USER PROFILE PICTURE
              ClipOval(
                // IMAGE FROM SERVER
                child: CachedNetworkImage(
                  width: mq.height * 0.2,
                  height: mq.height * 0.2,
                  fit: BoxFit.cover,
                  imageUrl: widget.user.image,
                  errorWidget: (context, url, error) =>
                      const Icon(CupertinoIcons.person),
                ),
              ),
              SizedBox(width: mq.width, height: mq.height * 0.04),
              // USER EMAIL
              Text(
                widget.user.email,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary, fontSize: 18),
              ),
              SizedBox(
                height: mq.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'About: ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    widget.user.about,
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
