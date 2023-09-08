import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatzone/main.dart';
import 'package:chatzone/models/chat_user.dart';
import 'package:chatzone/screens/screen_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

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
      margin: EdgeInsets.symmetric(
        horizontal: mq.width * .01,
        vertical: 4,
      ),
      elevation: 0.5,
      color: Colors.deepPurple[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScreenChat(user: widget.user,),
            ),
          );
        },
        child: ListTile(

            //* User profile picture
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .3),
              child: CachedNetworkImage(
                height: mq.height * .055,
                width: mq.height * .055,
                imageUrl: widget.user.image,
                placeholder: (context, url) {
                  return const CircularProgressIndicator();
                },
                errorWidget: (context, url, error) {
                  return const CircleAvatar(
                    child: Icon(
                      CupertinoIcons.person,
                    ),
                  );
                },
              ),
            ),
            title: Text(
              widget.user.name,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              widget.user.about,
              maxLines: 1,
            ),
            trailing: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                height: 15,
                width: 15,
                color: Colors.purple[200],
              ),
            )
            // trailing: Text(
            //   '12:32',
            //   style: TextStyle(
            //     color: Colors.black54,
            //   ),
            // ),
            ),
      ),
    );
  }
}
