import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:petfit/Firebase/firebase_auth_handler.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../src/app.dart';

GetIt locator = GetIt.instance;

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  //setupSingletons();

  runApp(RootScreen());
}

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationProvider?>(
          create: (_) => AuthenticationProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationProvider?>()?.authState,
          initialData: null,
        )
        // StreamProvider(
        //   create: (context) => context.read<AuthenticationProvider>().authState,
        //   initialData: "Guest",
        // ),
      ],
      child: App(),
    );
  }
}
