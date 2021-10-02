import 'package:facto_user/util/colors.dart';
import 'package:facto_user/util/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toast/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';

GoogleSignIn googleSignIn = GoogleSignIn();
FirebaseAuth auth = FirebaseAuth.instance;
User user;
String yourClientId = "1666359023559767";
String yourRedirectUrl = "https://www.google.com";
String _verificationId = '';



Future<User> signInWithGoogle() async {
  googleSignIn = GoogleSignIn();
  auth = FirebaseAuth.instance;
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    var int = await auth.signInWithCredential(credential);
  return int.user;
}

Future<User> verifyPhone(String phone, BuildContext context) async {
  auth = FirebaseAuth.instance;
  // auth.setSettings(appVerificationDisabledForTesting: true);
  final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
    _verificationId = verId;
  };
  try {
    await auth.verifyPhoneNumber(
        phoneNumber: '+91'+phone,
        codeAutoRetrievalTimeout: (String verId) {
          _verificationId = verId;
        },
        codeSent: smsOTPSent,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (AuthCredential phoneAuthCredential) {},
        verificationFailed: (FirebaseAuthException exception) {
          // Navigator.pop(context, exception.message);
        });
  } catch (e) {
    Navigator.pop(context, (e as PlatformException).message);
  }
}

Future<User> signInWithPhone(String otp,BuildContext context) async {
  print('entered otp is ${otp}');
  try {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: otp,
    );
    final User user = (await auth.signInWithCredential(credential)).user;
    print("Successfully signed in UID: ${user.uid}");
    Navigator.of(context).pushReplacementNamed('/dashboard');
    return user;
  } catch (e) {
    print("Failed to sign in: " + e.toString());
  }
}


Future<User> loginWithFacebook(BuildContext context) async{
  auth = FirebaseAuth.instance;
  String result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CustomWebView(
            selectedUrl:
            'https://www.facebook.com/dialog/oauth?client_id=$yourClientId&redirect_uri=$yourRedirectUrl&response_type=token&scope=email,public_profile,',
          ),
          maintainState: true));
  if (result != null) {
    try {
      print(result);
      final facebookAuthCred =
      FacebookAuthProvider.credential(result);
      final user =
      await auth.signInWithCredential(facebookAuthCred);
      return user.user;
    } catch (e) {
      print(e.message);
      Toast.show(e.message, context);
    }
  }
  else{
    print('kuch na hua');
  }
  }

class CustomWebView extends StatefulWidget {
  final String selectedUrl;

  CustomWebView({this.selectedUrl});

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.contains("#access_token")) {
        succeed(url);
      }

      if (url.contains(
          "https://www.facebook.com/connect/login_success.html?error=access_denied&error_code=200&error_description=Permissions+error&error_reason=user_denied")) {
        denied();
      }
    });
  }

  denied() {
    Navigator.pop(context);
  }

  succeed(String url) {
    var params = url.split("access_token=");

    var endparam = params[1].split("&");

    Navigator.pop(context, endparam[0]);
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
        url: widget.selectedUrl,
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(66, 103, 178, 1),
          title: new Text("Facebook login"),
        ));
  }
}