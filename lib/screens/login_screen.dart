import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

import 'home_screen.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  late String verificationId;

  bool showLoading = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
      await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if(authCredential.user != null){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
      }

    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('error'),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  getMobileFormWidget(context) {
    return Container(
      child: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Column(
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 40),
                  child: Image.asset(
                    'assets/images/icon.png',
                    scale: 2,
                  ),
                ),
              ),
              Spacer(),
              Center(child: Text("Sign in", style: TextStyle(color: Colors.black87, fontSize: 30,fontWeight: FontWeight.bold),)),
              SizedBox(height: 40,),
              //Spacer(),
              Row(
                children: [
                  Image.asset('assets/images/france.png',scale: 2.3,),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          hintText: "+33 100 700 300",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    showLoading = true;
                  });

                  await _auth.verifyPhoneNumber(
                    phoneNumber: phoneController.text,
                    verificationCompleted: (phoneAuthCredential) async {
                      setState(() {
                        showLoading = false;
                      });
                      //signInWithPhoneAuthCredential(phoneAuthCredential);
                    },
                    verificationFailed: (verificationFailed) async {
                      setState(() {
                        showLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Failed to verify'),
                        behavior: SnackBarBehavior.floating,
                      ));
                    },
                    codeSent: (verificationId, resendingToken) async {
                      setState(() {
                        showLoading = false;
                        currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                        this.verificationId = verificationId;
                      });
                    },
                    codeAutoRetrievalTimeout: (verificationId) async {},
                  );
                },
                child: Text("SEND"),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  getOtpFormWidget(context) {
    return Container(
      child: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Column(
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 40),
                  child: Image.asset(
                    'assets/images/icon.png',
                    scale: 2,
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: TextField(
                  controller: otpController,
                  decoration: InputDecoration(
                    hintText: "Enter OTP",
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () async {
                  PhoneAuthCredential phoneAuthCredential =
                  PhoneAuthProvider.credential(
                      verificationId: verificationId, smsCode: otpController.text);

                  signInWithPhoneAuthCredential(phoneAuthCredential);
                },
                child: Text("VERIFY"),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: showLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
              ? getMobileFormWidget(context)
              : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        ));
  }
}