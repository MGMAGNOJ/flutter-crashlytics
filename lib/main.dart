import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:alura_crashlytics/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as Foundation;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this

  // Inicializa o Firebase
  await Firebase.initializeApp();
  // Main do App DEBUG
  if (Foundation.kDebugMode) {
    print("App in debug mode");
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    runApp(MyApp());
  }

  // Main do APP Production
  if (Foundation.kReleaseMode) {
    runZonedGuarded<Future<void>>(() async {
      print('App in release mode');
      // Inicialização do Crashlytics
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      // Seta o Username
      FirebaseCrashlytics.instance.setUserIdentifier("mario.magno");
      // Pass all uncaught errors from the framework to Crashlytics.
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      runApp(MyApp());
    },
        (error, stack) =>
            FirebaseCrashlytics.instance.recordError(error, stack));
  }

  //save(Transaction(200.0, Contato(0, 'Gui', 2000))).then((transaction) {
  //  print(transaction);
  //});

  //findAll().then((transactions) {
  //  print('Novas transações $transactions');
  //}
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ByteBankApp',
      theme: ThemeData(
        primaryColor: Colors.green,
        accentColor: Colors.blueAccent.shade700,
      ),
      home: Dashboard(),
    );
  }
}
