import 'package:dilivery_app/widget_ui/widgets_navigation/Navigator_observer/navigator_obs.dart';
import 'package:dilivery_app/widget_ui/widgets_screens/Authentificatiton_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'items_details/widgets/items_provider/cart_provider.dart'; // Correct import
import 'items_details/widgets/items_provider/selected_quantity_provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';


// Ensure you are importing the correct widget

// Create root app for our application
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51QW5b2Eo6eVeVEUeEibtZFUc9OsZ4o3iFczsjjYhPHs3huUt358fSNHP4KN09k5tMPu13SD6mdeJ2zJw8HHa6xjs00JF6OHwaH";
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),       // Provide CartProvider
        ChangeNotifierProvider(create: (_) => QuantityProvider()),
        // Provide QuantityProvider
      ],


      child: MyApp(),
    ),


  );

}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [SystemUiObserver()],
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,  // This will set a black background globally
      ),
      home: SplashScreen(), // Make sure Home is correctly defined
    );
  }
}
