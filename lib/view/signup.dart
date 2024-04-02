import 'package:flutter/material.dart';
import 'package:timetable/database/sqflite.dart';
import 'package:timetable/model/users.dart';
import 'package:timetable/view/login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final formKey= GlobalKey<FormState>();
  bool isVisible = false;
  bool isVisible2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ListTile(
                  title: Text("Register New Account",style: TextStyle(fontSize: 60,fontWeight: FontWeight.bold),),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple.withOpacity(0.2)
                  ),
                  child: TextFormField(
                    controller: username,
                    validator: (value){
                      if(value!.isEmpty)
                      {
                        return "username is required";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: "username",
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple.withOpacity(0.2)
                  ),
                  child: TextFormField(
                    controller: password,
                    validator: (value){
                      if(value!.isEmpty)
                      {
                        return "password is required";
                      }
                      return null;
                    },
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.lock),
                        hintText: "Password",
                        suffixIcon: IconButton(onPressed:(){
                          setState(() {
                            isVisible=!isVisible;
                          });
                        },icon:Icon(isVisible? Icons.visibility: Icons.visibility_off))
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple.withOpacity(0.2)
                  ),
                  child: TextFormField(
                    controller: confirmPassword,
                    validator: (value){
                      if(value!.isEmpty)
                      {
                        return "confirm password is required";
                      } else if(password.text != confirmPassword.text){
                        return "passowrds don't match";
                      }
                      return null;
                    },
                    obscureText: !isVisible2,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.lock),
                        hintText: "Confirm password",
                        suffixIcon: IconButton(onPressed:(){
                          setState(() {
                            isVisible2=!isVisible2;
                          });
                        },icon:Icon(isVisible2? Icons.visibility: Icons.visibility_off))
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width* 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple
                  ),
                  child: TextButton(
                      onPressed: () {
                        if(formKey.currentState!.validate()){
                          final db = SqlDb();
                          db.signup(Users(userName: username.text, userPassword: password.text)).whenComplete(() => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen())));
                        }
                      },
                      child: const Text("SIGN UP",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("already have an account?"),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
                    }, child: const Text(
                        "LOG IN",
                        style:TextStyle(color: Colors.deepPurple)
                    )
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
