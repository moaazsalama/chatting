import 'package:chatting/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createat', descending: true)
          .snapshots(includeMetadataChanges: true),
      builder: (ctx, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final List  <QueryDocumentSnapshot> docs = snapShot.data.docs;



        return ListView.builder(
          reverse: true,
          itemBuilder: (context, index) => MessageBubble(

            docs[index]['text'],
            docs[index]['username'],
            docs[index]['userImage'],

            docs[index]['userid']==FirebaseAuth.instance.currentUser.uid,
            key: ValueKey(docs[index].id),
          ),
          itemCount: snapShot.data.docs.length,
        );
      },
    );
  }
}
