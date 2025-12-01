import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:projectakhir_mobile/Models/user.dart';
import 'package:projectakhir_mobile/Models/cart_manager.dart';
import 'package:projectakhir_mobile/Views/login_screen.dart';

String boxName = 'USER';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<UserModel>(UserModelAdapter());
  await Hive.openBox<UserModel>(boxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartManager(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Valorant App',
        home: LoginScreen(),
      ),
    );
  }
}
