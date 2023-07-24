import 'package:chat_first/core/utils/constants.dart';
import 'package:chat_first/src/Features/Home/Pages/main_page.dart';
import 'package:go_router/go_router.dart';

import '../src/Features/call_screen/Pages/call_contact.dart';
import '../src/Features/profile_screen/Pages/profile.dart';
import '../src/Features/sign_in/Pages/sign_in_screen.dart';

// GoRouter configuration

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => Constants.idForMe == null || Constants.idForMe == '' || Constants.idForMe == 'null' ? SignIn() : const MainPage(),
    ),
    /*GoRoute(
        path: '/Chat',
        builder: (context, state) => Chat(),
      ),*/
    GoRoute(
      path: '/CallContact',
      builder: (context, state) => const CallContact(),
    ),
    GoRoute(
      path: '/Edit',
      builder: (context, state) => Profile(firstTimeSign: false),
    ),
    GoRoute(
      path: '/Sign',
      builder: (context, state) => SignIn(),
    ),
  ],
);
