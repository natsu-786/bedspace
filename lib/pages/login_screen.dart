// ignore_for_file: camel_case_types

import 'package:bedspace/auth_service.dart';
import 'package:bedspace/pages/add_product.dart';
import 'package:flutter/material.dart';
import 'package:bedspace/Animation/FadeAnimation.dart';
import 'package:provider/provider.dart';
// ignore: constant_identifier_names
enum AuthMode { Signup, Login }
// ignore: must_be_immutable
class login_screen extends StatefulWidget with ChangeNotifier{
   login_screen({Key? key}) : super(key: key);
  static const routename = "/login_screen";

  @override
  State<login_screen> createState() => _login_screenState();
}
class _login_screenState extends State<login_screen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController(text: "");

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  AuthMode _authMode = AuthMode.Login;

  bool isLoading = false;
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });
    if (_authMode == AuthMode.Login) {
      // Log user in
      await Provider.of<auth_service>(context, listen: false).login(
        _authData['email'].toString(),
        _authData['password'].toString(),
      ).then((value) => Navigator.of(context).pushReplacementNamed(add_product.routename));
    } else {
      // Sign user up
      await Provider.of<auth_service>(context, listen: false).signup(
        _authData['email'].toString(),
        _authData['password'].toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      _authMode = AuthMode.Signup;
    } else {
      _authMode = AuthMode.Login;
    }
  }
  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    var height = MediaQuery.of(context).size.height;
    //var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: height/2,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/background.png'),
                        fit: BoxFit.fill
                    )
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: FadeAnimation(1, Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/light-1.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: FadeAnimation(1.3, Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/light-2.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: FadeAnimation(1.5, Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/clock.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      child: FadeAnimation(1.6, Container(
                        margin: const EdgeInsets.only(top: 50),
                        child:  Center(
                          child: Text(
                              _authMode == AuthMode.Login ? 'LOGIN' : 'SIGNUP' ,style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                        ),
                      )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    FadeAnimation(1.8, Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(143, 148, 251, .2),
                                blurRadius: 20.0,
                                offset: Offset(0, 10)
                            )
                          ]
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey))
                            ),
                            child: Form(key : _formKey,child: Column(children: [
                              TextFormField(
                                initialValue: '',
                                decoration: const InputDecoration(labelText: 'E -Mail'),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'Invalid email!';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  setState(() {
                                    _authData['email'] = value!;
                                  });

                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(labelText: 'Password'),
                                obscureText: true,
                                controller: _passwordController,
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 5) {
                                    return 'Password is too short!';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  setState(() {
                                    _authData['password'] = value!;
                                  });

                                },
                              ),
                              if (_authMode == AuthMode.Signup)
                                TextFormField(
                                  enabled: _authMode == AuthMode.Signup,
                                  decoration: const InputDecoration(labelText: 'Confirm Password'),
                                  obscureText: true,
                                  validator: _authMode == AuthMode.Signup
                                      ? (value) {
                                    if (value != _passwordController.text) {
                                      return 'Passwords do not match!';
                                    }
                                    return null;
                                  }
                                      : null,
                                ),
                              const SizedBox(
                                height: 20,
                              ),


                            ],),),
                          ),

                        ],
                      ),
                    )),
                    const SizedBox(height: 30,),
                    TextButton(onPressed: (){
                      setState(() {
                        _submit();
                      });

                      },
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue.shade500)),
                      child: Text(
                          _authMode == AuthMode.Login ? 'LOGIN' : 'SIGNUP',style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                    ),
                     TextButton(
                      child: Text(
                          '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                      onPressed: (){setState(() {
                        _switchAuthMode();
                        _passwordController.clear();
                      });},
                      // padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                      // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // textColor: Theme.of(context).primaryColor,
                    ),
                    TextButton(onPressed: ()=>Navigator.of(context).pushReplacementNamed(add_product.routename), child: Text('Add product')),


                    const SizedBox(height: 70,)



                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}
