import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatzone/api/apis.dart';
import 'package:chatzone/helper/my_date_util.dart';
import 'package:chatzone/main.dart';
import 'package:chatzone/models/chat_user.dart';
import 'package:chatzone/models/message.dart';
import 'package:chatzone/screens/screen_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  //* Last message info ( if null --> no message)
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: mq.width * .01,
        vertical: 4,
      ),
      elevation: 0.5,
      color: Colors.indigo[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScreenChat(
                user: widget.user,
              ),
            ),
          );
        },
        child: StreamBuilder(
          stream: APIs.getLastMessage(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            // print('Data: ${jsonEncode(data![0].data())}');
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) _message = list[0];

            return ListTile(
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
                  fit: BoxFit.cover,
                ),
              ),
              //* User Name
              title: Text(
                widget.user.name,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              //* Last Message
              subtitle: Text(
                _message != null
                    ? _message!.type == Type.image
                        ? 'Image'
                        : _message!.msg
                    : widget.user.about,
                maxLines: 1,
              ),

              //* Last message time
              trailing: _message == null
                  ? null
                  : _message!.read.isEmpty && _message!.fromId != APIs.user.uid
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            height: 15,
                            width: 15,
                            color: Colors.purple[200],
                          ),
                        )
                      : Text(
                          MyDateUtil.getLastMessageTime(
                            context: context,
                            time: _message!.sent,
                          ),
                        ),
            );
          },
        ),
      ),
    );
  }
}
