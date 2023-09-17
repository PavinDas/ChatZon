import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatzone/api/apis.dart';
import 'package:chatzone/helper/my_date_util.dart';
import 'package:chatzone/main.dart';
import 'package:chatzone/models/chat_user.dart';
import 'package:chatzone/models/message.dart';
import 'package:chatzone/screens/screen_view_profile%20.dart';
import 'package:chatzone/widgets/message_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScreenChat extends StatefulWidget {
  final ChatUser user;

  const ScreenChat({super.key, required this.user});

  @override
  State<ScreenChat> createState() => _ScreenChatState();
}

class _ScreenChatState extends State<ScreenChat> {
  //* For storing all messages
  List<Message> _list = [];

  //* For handling message text changes
  final _textController = TextEditingController();

  //* showEmoji --> For showing or hiding emoji keyboard
  //* isUploading --> For checking any images are uploading or not
  bool _showEmoji = false, _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();

        setState(() {
          if (_showEmoji) _showEmoji = !_showEmoji;
        });
      },
      child: SafeArea(
        child: WillPopScope(
          //* If emojis is on & back button is pressed when search
          //* or else simple close current screen on back button click
          onWillPop: () {
            if (_showEmoji) {
              setState(
                () {
                  _showEmoji = !_showEmoji;
                },
              );
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),backgroundColor: Colors.deepPurple,
            ),

            backgroundColor:Colors.indigo[50],

            //* Body
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //* If Data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();

                        //* if Some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          // print('Data: ${jsonEncode(data![0].data())}');
                          _list = data
                                  ?.map(
                                    (e) => Message.fromJson(e.data()),
                                  )
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              reverse: true,
                              itemCount: _list.length,
                              padding: EdgeInsets.only(top: mq.height * .008),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return MessageCard(
                                  message: _list[index],
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: Text(
                                'Say hai 👋',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color:Colors.deepPurple,
                                ),
                              ),
                            );
                          }
                      }
                    },
                  ),
                ),

                //* Progress indicator for image uploading
                if (_isUploading)
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 20,
                      ),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),

                //* Chat input field
                _chatInput(),

                //* Show emoji on keyboard
                if (_showEmoji)
                  SizedBox(
                    height: mq.height * .35,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: Config(
                        bgColor: Colors.indigo.withOpacity(.09),
                        columns: 8,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //* AppBar widget
  Widget _appBar() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScreenViewProfile(user: widget.user),
          ),
        );
      },
      child: StreamBuilder(
        stream: APIs.getUserInfo(widget.user),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;
          // print('Data: ${jsonEncode(data![0].data())}');
          final list =
              data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

          return Row(
            children: [
              //* Back Button
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.white,
                ),
              ),

              //* Profile picture
              ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .3),
                child: CachedNetworkImage(
                  height: mq.height * .047,
                  width: mq.height * .047,
                  imageUrl: list.isNotEmpty ? list[0].image : widget.user.image,
                  fit: BoxFit.cover,
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

              //* Adding some space
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //* Name of user
                  Text(
                    list.isNotEmpty ? list[0].name : widget.user.name,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.6,
                    ),
                  ),

                  //* Adding some space
                  const SizedBox(
                    height: 2,
                  ),

                  //* Online status or Last seen
                  Text(
                    list.isNotEmpty
                        ? list[0].isOnline
                            ? 'Online'
                            : MyDateUtil.getLastActiveTime(
                                context: context,
                                lastActive: list[0].lastActive)
                        : MyDateUtil.getLastActiveTime(
                            context: context,
                            lastActive: widget.user.lastActive),
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                      letterSpacing: .6,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  //* Bottom chat input field
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: mq.height * .01,
        horizontal: mq.width * .020,
      ),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: const Color.fromARGB(255, 239, 241, 241),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                //* Input fields and buttons
                children: [
                  //* Emoji Button
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(
                        () => _showEmoji = !_showEmoji,
                      );
                    },
                    icon: const Icon(
                      Icons.emoji_emotions,
                    ),
                    color:Colors.deepPurple,
                    iconSize: 25,
                  ),

                  //* Text Input Field
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          if (_showEmoji) _showEmoji = !_showEmoji;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Type something...',
                        hintStyle: TextStyle(
                          color:Colors.deepPurple.withOpacity(.6),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  //* Gallery Button
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      //*  Pick multiple image.
                      final List<XFile> images = await picker.pickMultiImage(
                        imageQuality: 70,
                      );

                      //* Uploading and sending images one by one
                      for (var i in images) {
                        log('\nImage Path: ${i.path}');

                        setState(
                          () => _isUploading = true,
                        );

                        await APIs.sendChatImage(
                          widget.user,
                          File(i.path),
                        );
                        setState(
                          () => _isUploading = false,
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.image,
                    ),
                    color:Colors.deepPurple,
                    iconSize: 26,
                  ),

                  //* Camera Button
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 70,
                      );

                      if (image != null) {
                        log('\nImage Path: ${image.path}');
                        setState(
                          () => _isUploading = true,
                        );

                        await APIs.sendChatImage(
                          widget.user,
                          File(image.path),
                        );

                        setState(
                          () => _isUploading = false,
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                    ),
                    color: Colors.deepPurple,
                    iconSize: 26,
                  ),

                  //* Adding some space
                  SizedBox(
                    width: mq.width * .02,
                  )
                ],
              ),
            ),
          ),

          //* Message send button
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text, Type.text);
                _textController.text = '';
              }
            },
            color: const Color.fromARGB(255, 239, 241, 241),
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 10,
              right: 5,
            ),
            child: Icon(
              Icons.send,
              color:Colors.deepPurple,
              size: 27,
            ),
            shape: const CircleBorder(),
            minWidth: 0,
          )
        ],
      ),
    );
  }
}
