import 'package:flutter/material.dart';
import 'package:timetable/database/sqflite.dart';
import 'package:timetable/main.dart';
import 'package:timetable/model/users.dart';
import 'package:timetable/view/homePage.dart';
import 'package:timetable/view/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final username = TextEditingController();
  final password = TextEditingController();
  bool isVisible= false;
  bool isLoginTrue = false;

  final formKey = GlobalKey<FormState>();
  final db = SqlDb();

  login() async{
    var response = await db.login(Users(userName: username.text, userPassword: password.text));
    if (response == true) {
      int userIde = await db.getUserId(Users(userName: username.text, userPassword: password.text));
      username.clear();
      password.clear();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userId: userIde)),
      );
    }
    else {
      setState(() {
        isLoginTrue = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Image.asset( "lib/assets/login.png"),
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
                          login();
                      }
                    },
                    child: const Text("LOGIN",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignupScreen()));
                    }, child: const Text(
                        "SIGN UP",
                        style:TextStyle(color: Colors.deepPurple)
                    )
                    )
                  ],
                ),

                isLoginTrue? const Text(
                  "Username or password is incorrect",
                  style: TextStyle(color: Colors.red)
                ): const SizedBox()
              ],
            ),
          ),
        )),
      ),
    );
  }
}
