import 'package:chat_first/core/utils/constants.dart';
import 'package:chat_first/presentation/screens/main_page.dart';
import 'package:go_router/go_router.dart';

import '../presentation/screens/call_screen/call_contact.dart';
import '../presentation/screens/contact_screen/edit_progile/edit_profile.dart';
import '../presentation/screens/sign_in/sign_in_screen.dart';


// GoRouter configuration

  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',

        builder: (context, state) =>Constants.idForMe==null? SignIn(): const MainPage(),
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
        builder: (context, state) => EditProfile(),

      ),

    ],
  );
