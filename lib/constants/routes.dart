import 'package:flutter/material.dart';
import 'package:paper/views/home_view.dart';
import 'package:paper/views/login_view.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoutes = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: LoginView()),
});
final loggedInRoutes = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: HomeView()),
});
