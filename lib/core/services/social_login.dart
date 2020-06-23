import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myassistantv2/core/global/variables.dart';
import 'package:myassistantv2/core/services/authentication.dart';
import 'package:myassistantv2/ui/pages/methods/pref.dart';

class SocialLogin{
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static FacebookLogin _facebookLogin = new FacebookLogin();
  static GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

static Future googleLogIn(context) async {
    try {
      await _googleSignIn.signIn().then((result) {
        print(result.displayName);
        print(result.email);
        print(result.id);
       saveGoogle(true);
       googleActive = true;
       Authentication.registerNew(result.email.toString(),  result.id.toString(), context);
      });
    } catch (error) {
      print(error);
    }
  }

  static Future facebookSignIn(context) async {
    await _facebookLogin.logIn(['email']).then((result) {
      print(result.accessToken);
      if (result.status == FacebookLoginStatus.loggedIn) {
        final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: "${result.accessToken.token}");
        _firebaseAuth.signInWithCredential(credential).then((user) {
           saveFb(true);
            fbActive = true;
          Authentication.registerNew(user.user.email.toString(), user.user.uid.toString(),context);
        }).catchError((e) {
          print(e);
        });
      }
    });
  }
}