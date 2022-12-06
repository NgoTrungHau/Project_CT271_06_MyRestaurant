import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'ui/reservations/book_dishes_detail_screen.dart';
import 'ui/screen.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => AuthManager(),
          ),
          ChangeNotifierProxyProvider<AuthManager, DishesManager>(
              create: (ctx) => DishesManager(),
              update: (ctx, authManager, dishesManager) {
                dishesManager!.authToken = authManager.authToken;
                return dishesManager;
              }),
          ChangeNotifierProvider(
            create: (ctx) => CartManager(),
          ),
          ChangeNotifierProxyProvider<AuthManager, ReservationsManager>(
              create: (ctx) => ReservationsManager(),
              update: (ctx, authManager, reservationsManager) {
                reservationsManager!.authToken = authManager.authToken;
                return reservationsManager;
              }),
          ChangeNotifierProvider(
            create: (ctx) => OrdersManager(),
          ),
        ],
        child: Consumer<AuthManager>(builder: (ctx, authManager, child) {
          return MaterialApp(
            title: 'My Restaurant',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: Colors.orange,
                fontFamily: 'Lato',
                colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Colors.orange,
                ).copyWith(
                  secondary: Colors.deepOrange,
                )),
            home: authManager.isAuth
                ? const DishesOverviewScreen()
                : FutureBuilder(
                    future: authManager.tryAutoLogin(),
                    builder: ((context, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen();
                    })),
            routes: {
              ReservationScreen.routeName: (ctx) => const ReservationScreen(),
              CartScreen.routeName: (ctx) => const CartScreen(),
              OrdersScreen.routeName: (ctx) => const OrdersScreen(),
              UserDishesScreen.routeName: (ctx) => const UserDishesScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == DishDetailScreen.routeName) {
                final dishId = settings.arguments as String;
                return MaterialPageRoute(builder: (ctx) {
                  return DishDetailScreen(
                    ctx.read<DishesManager>().findById(dishId),
                  );
                });
              }
              if (settings.name == EditDishScreen.routeName) {
                final dishId = settings.arguments as String?;
                return MaterialPageRoute(builder: (ctx) {
                  return EditDishScreen(
                    dishId != null
                        ? ctx.read<DishesManager>().findById(dishId)
                        : null,
                  );
                });
              }
              if (settings.name == EditTableScreen.routeName) {
                final tableId = settings.arguments as String?;
                return MaterialPageRoute(builder: (ctx) {
                  return EditTableScreen(
                    tableId != null
                        ? ctx.read<ReservationsManager>().findById(tableId)
                        : null,
                  );
                });
              }
              if (settings.name == BookScreen.routeName) {
                final tableId = settings.arguments as String;
                return MaterialPageRoute(builder: (ctx) {
                  return BookScreen(
                    ctx.read<ReservationsManager>().findById(tableId),
                  );
                });
              }
              if (settings.name == BookDishDetailScreen.routeName) {
                final dishId = settings.arguments as String;
                return MaterialPageRoute(builder: (ctx) {
                  return BookDishDetailScreen(
                    ctx.watch<DishesManager>().findById(dishId),
                  );
                });
              }
              return null;
            },
          );
        }));
  }
}
