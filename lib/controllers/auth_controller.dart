
import 'package:chatapp_getx/screens/auth_screen.dart';
import 'package:chatapp_getx/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AuthController extends GetxController{
 static AuthController get authGetter=>Get.find<AuthController>();
 final obsecure=true.obs;
 FirebaseAuth _auth=FirebaseAuth.instance;
 FirebaseFirestore _cloudFireStore=FirebaseFirestore.instance;
 late Rx<User?> user;
 var isLoading=false;
 User? get userdata{
  return user.value;
 }

 @override
  void onReady() {
  user=Rx<User?>(_auth.currentUser);
  user.bindStream(_auth.userChanges());
  ever(user, _initialScreen);
    super.onReady();
  }

   _initialScreen(User? user) {
  if (user!=null) {
    Get.to(()=>ChatScreen());
  }else{
    Get.to(()=>AuthScreen());
  }
   }

Future<void> submitForm(GlobalKey<FormState> formkey,Map<String,String> userdata,bool islogin)async {
final isValid=formkey.currentState!.validate();
if (isValid && userdata.isNotEmpty){
 formkey.currentState!.save();
 if (islogin) {
  await login(userdata);
 }else{
  await signup(userdata);
 }
}
}
Future<void> signup(Map<String,String> userdata)async{

try{
 final response=await _auth.createUserWithEmailAndPassword(email: userdata['email']!.trim(), password: userdata['password']!.trim());
 await _cloudFireStore.collection('Users').doc('${user.value!.uid}').set({
  'username':userdata['userName'],
  'password':userdata['password'],
 });
} on PlatformException catch(error){
 final message='someThing wrong';
 Get.snackbar(error.message.toString(), message,duration: Duration(milliseconds: 1500));
}catch(error){
 Get.snackbar('something wrong', error.toString(),duration: Duration(milliseconds: 1500));

}
}

 Future<void> login(Map<String,String> userdata)async{
  print(userdata);
  try{
   final response=await _auth.signInWithEmailAndPassword(email: userdata['email']!.trim(), password: userdata['password']!.trim());
  } on PlatformException catch(error){
   final message='someThing wrong';
   Get.snackbar(error.message.toString(), message,duration: Duration(milliseconds: 1500));
  }catch(error){
   Get.snackbar('something wrong', error.toString(),duration: Duration(milliseconds: 1500));

  }
 }

 Future<void> logout()async{
  try{
   final response=_auth.signOut();
  } on PlatformException catch(error){
   final message='Somthing Gone Wrong';
   Get.snackbar(message, error.message.toString());
  }
 }
}
