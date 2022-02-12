import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
enum Items{
  logout,
  setting,
}
class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authController=AuthController.authGetter;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  Text('${authController.userdata!.email}'),
        actions: [
          PopupMenuButton(
              itemBuilder: (_)=>[
            PopupMenuItem(child: Text('Logout'),value: Items.logout,),
            PopupMenuItem(child: Text('setting'),value: Items.setting,),
          ],
            onSelected: (Items items){
                if (items==Items.logout) {
                  authController.logout();
                }
            },
          )
        ]
      ),
      body:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
        stream:FirebaseFirestore.instance.collection('chats/${authController.userdata!.uid}/messages').snapshots(),
        builder:(context,snapshot){
          if (snapshot.connectionState==ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          }else if (snapshot.hasData) {
            final data=snapshot.data!.docs;
            return  ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index){
                  return Text(data[index].data()['text'].toString());
                }
            );
          }
          return Text('Opps SomeThing wrong');
        } ,
      ),
      floatingActionButton: FloatingActionButton(
         onPressed: () {
           FirebaseFirestore.instance.collection('chats/${authController.userdata!.uid}/messages').add({
             'text':'Press me'
           }).whenComplete(() => Get.snackbar('Add data', 'Success',duration: Duration(milliseconds: 200),animationDuration: Duration(milliseconds: 200)));
         }
      ),
    );
  }
}
