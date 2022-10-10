import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/observer.dart';
import 'screens/home/bloc/home_bloc.dart';
import 'screens/home/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocOverrides.runZoned(
    () {
      runApp(const ShotCallerMinter());
    },
    blocObserver: AppObserver(),
  );
}

class ShotCallerMinter extends StatelessWidget {
  const ShotCallerMinter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
      ],
      child: const MaterialApp(
        title: 'ShotCaller Minter',
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
