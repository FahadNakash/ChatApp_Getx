import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../animations/animations_controller.dart';
import '../controllers/auth_controller.dart';
// enum AuthMode{
//   Login,
//   Signup,
// }
class AuthForm extends StatefulWidget {
  final AnimationController controller;

  @override
  State<AuthForm> createState() => _AuthFormState();
  AuthForm(this.controller);
}
class _AuthFormState extends State<AuthForm> {
  final authController=AuthController.authGetter;
  final formKey=GlobalKey<FormState>();

  Map<String,String> _userData={
    'email':'',
    'userName':'',
    'password':''
  };
  bool _isLogin=true;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height:_isLogin?300:350,
        color: Colors.white,
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('CHATING WITH BUDDIES',style: TextStyle(fontFamily: 'Comfortaa'),),
                SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                    hintText: 'example@gmail.com',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    labelText: 'E-mail',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value){
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please Enter the Valid email';
                    }
                    return null;
                  },
                  onSaved:(value){
                    _userData['email']=value!;
                  },
                ),
                SizedBox(height: 10,),
                if(!_isLogin)
                TextFormField(
                  key: ValueKey('username'),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      hintText: 'First Name',
                      labelText: 'UserName'
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  validator: (value){
                    if (value!.isEmpty || value.isNum) {
                      return 'Please correct the userName';
                    }
                    return null;
                  },
                  onSaved:(value){
                    _userData['userName']=value!;
                  },
                ),
                SizedBox(height: 10,),
                Obx(()=>TextFormField(
                  key: ValueKey('password'),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      hintText: '0-9,A-Z',
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon:Icon(
                          authController.obsecure.value?Icons.remove_red_eye_outlined:Icons.remove_red_eye,
                          color: authController.obsecure.value?Colors.grey:Colors.purple,),
                        onPressed: (){
                          authController.obsecure.value=!authController.obsecure.value;
                        },)
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: authController.obsecure.value,
                  validator: (value){
                    if (value!.isEmpty || value.length<6) {
                      return 'Please enter the correct password';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _userData['password']=value!;
                  },
                ),),
                SizedBox(height: 10,),
                if (authController.isLoading) Center(child: CircularProgressIndicator(color:Colors.purple,)),
                if (!authController.isLoading)
                FlatButton(
                   color: Theme.of(context).primaryColor,
                    onPressed: ()async{
                       setState(() {
                         authController.isLoading=true;
                       });
                      await authController.submitForm(formKey,_userData,_isLogin);
                     setState(() {
                       authController.isLoading=false;
                     });
                    },
                    child:Text(_isLogin?'Login':'SignUp')),
                if (!authController.isLoading)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text(_isLogin?'Create New Account':'Already Account?'),
                  TextButton(
                      onPressed: (){
                    setState(() {
                      _isLogin=!_isLogin;
                      print(_isLogin);
                    });
                  }, child: Text(_isLogin?'Signup':'Login',style: TextStyle(fontFamily: 'Comfortaa'),))
                ],)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
