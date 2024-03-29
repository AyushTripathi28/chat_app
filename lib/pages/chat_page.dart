import 'dart:io';

import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/chat_textfield.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;
  ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  //text controller for message input
  final TextEditingController _messageController = TextEditingController();

  //scroll controller for message list to go to end
  final ScrollController _scrollController = ScrollController();

  //funtion to scroll to end
  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  //chat & auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  //send message
  void sendMessage() async {
    //check if message is not empty
    if (_messageController.text.isNotEmpty) {
      _chatService.sendMessage(receiverID, _messageController.text);
      _messageController.clear();
    }
    _scrollToEnd();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(receiverEmail),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              //display all messages
              Flexible(
                child: _buildMessageList(),
              ),

              _buildMessageInput(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return const Center(
            child: Text("Error"),
          );
        }

        // //loading
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   print("objectttt");
        // return const Center(
        //   child: CircularProgressIndicator(),
        // );
        // }

        if (!snapshot.hasData) {
          print("no data");
          return const Center(
            child: CircularProgressIndicator(),
          );
          // return const Center(
          //   child: Text("Please write message to initiate chat"),
          // );
        }

        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs
              .map((messageData) => _buildMessageItem(messageData))
              .toList(),
        );
      },
    );
  }

  //build message list item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    //check if message is sent by current user
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //is current user
    bool isCurrentUser = data["senderID"] == _authService.getCurrentUser()!.uid;

    //align message to right if current user
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: ChatBubble(
          message: data["message"],
          isCurrentUser: isCurrentUser,
        ));
  }

  //build message input
  Widget _buildMessageInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Platform.isAndroid ? 10.0 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: ChatTextField(
              controller: _messageController,
              hintText: "Type a message",
              obscureText: false,
            ),
          ),
          GestureDetector(
            onTap: sendMessage,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                shape: BoxShape.circle,
              ),
              margin: const EdgeInsets.only(right: 15, bottom: 3),
              padding: const EdgeInsets.all(12),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
