part of 'route_imports.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '',
    routes: [],
    redirect: (context,state){
      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(state.error.toString()),
      ),
    ),


  );
}