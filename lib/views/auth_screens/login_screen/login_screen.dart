import 'package:chakracabs/views/auth_screens/phone_verification_screen/phone_verification_screen.dart';
import 'package:chakracabs/views/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/export.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController countryCode = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  // Controllers for the signup form fields
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    countryCode.text = '+91';
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size size = mediaQueryData.size;
    double width = size.width;
    double height = size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HeadingText(text: 'Log In'),
                        SizedBox(height: height * .06),
                        const AuthPurposeText(text: 'Enter Your Mobile Number'),
                        const SizedBox(height: 4),
                        Text(
                          'Your security is important to us! Please verify your phone number to proceed.',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // country code
                            SizedBox(
                              width: 40,
                              child: TextFormField(
                                controller: countryCode,
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('+')) {
                                    return 'Country code is not valid';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.phone,
                                cursorColor: const Color(0xffaf4b2f),
                                decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  hintText: '+91',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xffaf4b2f),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // phone number
                            SizedBox(
                              width: width - 64,
                              child: TextFormField(
                                controller: phoneNumber,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      value.length < 8 ||
                                      value.length > 15) {
                                    return 'Phone Number is not valid';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.phone,
                                cursorColor: const Color(0xffaf4b2f),
                                decoration: const InputDecoration(
                                  hintText: 'Mobile Number',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xffaf4b2f),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * .07),
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : AuthButton(
                                onTap: () async {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await login();
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                              ),
                        SizedBox(height: height * .08),
                        Text(
                          'Or Login With',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              child: Image.asset('assets/images/google.png',
                                  fit: BoxFit.fill),
                            ),
                            const SizedBox(width: 12),
                            CircleAvatar(
                              radius: 12,
                              child: Image.asset('assets/images/facebook.png'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: height * .3,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Image.asset('assets/images/signup.png'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      bool userExists =
          await checkUserExists('${countryCode.text}${phoneNumber.text}');
      if (!userExists) {
        showSnackbar(
            "User does not exist. Please sign up.", Colors.red, context);
        openSignupBottomSheet();
        return;
      }

      try {
        await loginUserWithPhone(context, countryCode.text, phoneNumber.text);
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        showSnackbar("Login failed. Please try again.", Colors.red, context);
      }
    }
  }

  Future<bool> checkUserExists(String phoneNumber) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('fullPhoneNumber', isEqualTo: phoneNumber)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      showSnackbar("Error checking user existence: $e", Colors.red, context);
      return false;
    }
  }

  Future<void> loginUserWithPhone(
      BuildContext context, String countryCode, String phoneNumber) async {
    String fullPhoneNumber = '$countryCode$phoneNumber';

    _auth.verifyPhoneNumber(
      phoneNumber: fullPhoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        // Fetch user details from Firestore
        await fetchUserDetails(fullPhoneNumber, context);
        showSnackbar("User logged in successfully!", Colors.green, context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PhoneVerifyScreen(
              verificationId: credential.smsCode!,
              phoneNumber: fullPhoneNumber,
            ),
          ),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        showSnackbar("Verification failed: ${e.message}", Colors.red, context);
      },
      codeSent: (String verificationId, int? resendToken) async {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PhoneVerifyScreen(
              verificationId: verificationId,
              phoneNumber: fullPhoneNumber,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        showSnackbar("Code auto retrieval timed out", Colors.orange, context);
      },
    );
  }

  Future<void> fetchUserDetails(
      String fullPhoneNumber, BuildContext context) async {
    print('hiiii');
    try {
      // Query Firestore for the user details
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('fullPhoneNumber', isEqualTo: fullPhoneNumber)
          .get();
  
      if (querySnapshot.docs.isNotEmpty) {
        // User found, navigate to HomeScreen with user data
        var userData = querySnapshot.docs[0].data();

        print(userData);

        showSnackbar("User logged in successfully!", Colors.green, context);

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => HomeScreen(
        //       userData: userData, // Pass user data to the HomeScreen
        //     ),
        //   ),
        // );
      } else {
        showSnackbar("User data not found.", Colors.red, context);
      }
    } catch (e) {
      showSnackbar("Error fetching user details: $e", Colors.red, context);
    }
  }

  void openSignupBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: signupFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: firstNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'First name cannot be empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'First Name'),
                ),
                TextFormField(
                  controller: lastNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Last name cannot be empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Last Name'),
                ),
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email cannot be empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (signupFormKey.currentState!.validate()) {
                      await signUpUser();
                      Navigator.pop(context);
                      showSnackbar("User signed up successfully!", Colors.green,
                          context);
                    }
                  },
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> signUpUser() async {
    String fullPhoneNumber = '${countryCode.text}${phoneNumber.text}';
    await FirebaseFirestore.instance.collection('users').add({
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'email': emailController.text,
      'fullPhoneNumber': fullPhoneNumber,
    });
  }
}
