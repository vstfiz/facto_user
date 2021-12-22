import 'package:facto_user/model/user.dart';
import 'package:facto_user/services/auth/auth.dart';
import 'package:facto_user/util/globals.dart';
import 'package:facto_user/view/about_us/about_us.dart';
import 'package:facto_user/view/auth/otp.dart';
import 'package:facto_user/view/auth/sign_in.dart';
import 'package:facto_user/view/dashboard/dashboard.dart';
import 'package:facto_user/view/dashboard/details.dart';
import 'package:facto_user/view/edit_profile/edit_profile.dart';
import 'package:facto_user/view/explore/explore.dart';
import 'package:facto_user/view/file_claim/file_claim.dart';
import 'package:facto_user/view/home_screen/home_screen.dart';
import 'package:facto_user/view/search/search.dart';
import 'package:facto_user/view/splash/splash_screen.dart';
import 'package:facto_user/view/user_profile/list_claim.dart';
import 'package:facto_user/view/user_profile/user_profile.dart';
import 'package:facto_user/view/welcome/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart' as fAuth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        Globals.height = constraints.maxHeight;
        Globals.width = constraints.maxWidth;
        print(Globals.height);
        print(Globals.width);
        return MaterialApp(
            title: 'Major Project',
            theme: ThemeData(
              textTheme: TextTheme(
                  headline1: GoogleFonts.montserrat(fontWeight: FontWeight.w300),
                  headline2: GoogleFonts.montserrat(fontWeight: FontWeight.w300),
                  headline3: GoogleFonts.montserrat(fontWeight: FontWeight.w300),
                  headline4: GoogleFonts.montserrat(fontWeight: FontWeight.w300),
                  headline5: GoogleFonts.montserrat(fontWeight: FontWeight.w300),
                  headline6: GoogleFonts.montserrat(fontWeight: FontWeight.w300),
                  subtitle1: GoogleFonts.montserrat(fontWeight: FontWeight.w300),
                  subtitle2: GoogleFonts.montserrat(fontWeight: FontWeight.w300),
                  bodyText1: GoogleFonts.montserrat(fontWeight: FontWeight.w300),
                  bodyText2: GoogleFonts.montserrat(fontWeight: FontWeight.w300),
                  caption: GoogleFonts.montserrat(fontWeight: FontWeight.w300),
                  button: GoogleFonts.montserrat(fontWeight: FontWeight.w300),
                  overline: GoogleFonts.montserrat(fontWeight: FontWeight.w300),
              ),
              primarySwatch: Colors.lightBlue,
            ),
            routes: {
              '/dashboard' : (context) => DashBoard(),
              '/search' : (context) => Search(),
            },
            home: StreamBuilder(
              stream: auth.authStateChanges(),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  fAuth.User u = snapshot.data;
                  Globals.user = new User(u.photoURL, u.displayName, u.uid, u.email, u.phoneNumber);
                }
                return SplashScreen();
              },
            )
        );
      });
    });
  }
}
