import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mychat/models/chat_user.dart';
import 'package:mychat/screens/view_profile_screen.dart';

import '../main.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});
  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        height: mq.height * 0.35,
        width: mq.width * 0.6,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * 0.25),
                // PROFILE PICTURE
                child: CachedNetworkImage(
                  width: mq.width * 0.5,
                  fit: BoxFit.cover,
                  imageUrl: user.image,
                  errorWidget: (context, url, error) =>
                      const Icon(CupertinoIcons.person),
                ),
              ),
            ),

            // NAME OF USER
            Positioned(
              left: mq.width * 0.04,
              top: mq.height * 0.01,
              width: mq.width * 0.55,
              child: Text(
                user.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),

            //   INFO ICON TO GO DETAIL VIEW_PROFILE
            Align(
                alignment: Alignment.topRight,
                child: MaterialButton(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(0),
                  minWidth: 0,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ViewProfileScreen(user: user)));
                  },
                  child: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
