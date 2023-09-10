import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatzone/main.dart';
import 'package:chatzone/models/chat_user.dart';
import 'package:chatzone/screens/screen_view_profile%20.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: SizedBox(
        width: mq.width * .6,
        height: mq.height * .35,
        child: Stack(
          children: [
            //* User profile picture
            Positioned(
              top: mq.height * .070,
              left: mq.width * .085,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .25),
                child: CachedNetworkImage(
                  imageUrl: user.image,
                  width: mq.width * .5,
                  height: mq.height * .24,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(
                      CupertinoIcons.person,
                    ),
                  ),
                ),
              ),
            ),

            //* User name
            Positioned(
              left: mq.width * .04,
              top: mq.height * .01,
              width: mq.width * .55,
              child: Text(
                user.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[900],
                ),
              ),
            ),

            //* Info button
            Positioned(
              right: 8,
              top: 1,
              child: MaterialButton(
                padding: EdgeInsets.all(0),
                minWidth: 0,
                shape: CircleBorder(),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScreenViewProfile(user: user),
                    ),
                  );
                },
                child: Icon(
                  Icons.info_outline,
                  color: Colors.indigo[900],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
