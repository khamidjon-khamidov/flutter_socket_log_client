import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_socket_log_client/app.dart';
import 'package:flutter_socket_log_client/domain/repsitory/home_repository.dart';
import 'package:flutter_socket_log_client/ui/screens/home/bloc/home_bloc.dart';

void main() async {
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HomeRepository>(
          create: (context) => HomeRepository(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(context.read<HomeRepository>()),
          )
        ],
        child: App(),
      ),
    ),
  );
}
